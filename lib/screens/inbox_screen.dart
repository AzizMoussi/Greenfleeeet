import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../models/user_model.dart';

class ChatPage extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  const ChatPage({super.key, required this.recipientId,required this.recipientName});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late AnimationController _typingAnimationController;

  StompClient? stompClient;
  bool isConnected = false;
  bool isConnecting = false;
  String connectionStatus = "Disconnected";

  Timer? reconnectTimer;

  late String userId; // userId from provider
  late String recipientId; // passed from widget


  @override
  void initState() {
    super.initState();
    final userModel = Provider.of<UserModel>(context, listen: false);
    userId = userModel.user?['userId'].toString() ?? '';
    recipientId = widget.recipientId;


    _typingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();

    connectToWebSocket();
  }

  void connectToWebSocket() {
    if (isConnecting || userId.isEmpty) return;

    setState(() {
      isConnecting = true;
      connectionStatus = "Connecting...";
    });

    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'http://localhost:8080/ws',
        onConnect: onConnect,
        onDisconnect: onDisconnect,
        onWebSocketError: (error) {
          print('WebSocket Error: $error');
          handleConnectionError();
        },
        stompConnectHeaders: {
          'userId': userId,
        },
        webSocketConnectHeaders: {
          'userId': userId,
        },
      ),
    );

    try {
      stompClient!.activate();
    } catch (e) {
      print('Error activating STOMP client: $e');
      handleConnectionError();
    }
  }

  void onConnect(StompFrame frame) {
    print('✅ Connected to WebSocket');

    setState(() {
      isConnected = true;
      isConnecting = false;
      connectionStatus = "Connected";
    });

    reconnectTimer?.cancel();

    stompClient!.subscribe(
      destination: '/user/$userId/queue/messages',
      callback: (frame) {
        if (frame.body == null) return;

        try {
          final body = jsonDecode(frame.body!);
          print('Received message: $body');

          final message = ChatMessage(
            text: body['content'] ?? 'Empty message',
            isMe: body['senderId'].toString() == userId,
            timestamp: DateTime.now(),
            status: MessageStatus.received,
          );

          setState(() {
            _messages.add(message); // Add to the end of the list
          });

          // ✅ Display notification when the app is not in chat screen


          // Scroll to the bottom after receiving
          _scrollToBottom();
        } catch (e) {
          print('Error parsing message: $e');
        }
      },
    );

    registerUser();
    fetchExistingMessages();
  }


  void onDisconnect(StompFrame frame) {
    print('Disconnected from WebSocket');
    setState(() {
      isConnected = false;
      connectionStatus = "Disconnected";
    });
    handleConnectionError();
  }

  void handleConnectionError() {
    setState(() {
      isConnected = false;
      isConnecting = false;
      connectionStatus = "Connection failed. Retrying...";
    });

    reconnectTimer?.cancel();
    reconnectTimer = Timer(Duration(seconds: 5), connectToWebSocket);
  }

  void registerUser() {
    try {
      stompClient!.send(
        destination: 'users/app/user.addUser',
        body: jsonEncode({
          "userId": int.parse(userId),
          "nickName": "user$userId",
          "fullName": "User Full Name",
          "status": "ONLINE"
        }),
        headers: {"content-type": "application/json"},
      );
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  void fetchExistingMessages() async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final token = userModel.token;

    final response = await http.get(
      Uri.parse('http://localhost:8080/messages/$userId/$recipientId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> messages = jsonDecode(response.body);
      setState(() {
        for (var msg in messages) {
          _messages.add(ChatMessage(
            text: msg['content'],
            isMe: msg['senderId'].toString() == userId,
            timestamp: DateTime.parse(msg['timestamp']),
            status: MessageStatus.received,
          ));
        }
      });

      // Scroll to the bottom after loading existing messages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  void sendMessage(String text) {
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text('Not connected to server. Reconnecting...'),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(8),
          duration: Duration(seconds: 3),
        ),
      );
      connectToWebSocket();
      return;
    }

    final newMessage = ChatMessage(
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    setState(() {
      _messages.add(newMessage); // Add to the end of the list
      _controller.clear();
    });

    // Scroll to the bottom after sending
    _scrollToBottom();

    try {
      final message = {
        "senderId": userId,
        "recipientId": recipientId,
        "content": text,
        "timestamp": DateTime.now().toIso8601String(),
      };

      stompClient!.send(
        destination: '/app/chat',
        body: jsonEncode(message),
        headers: {"content-type": "application/json"},
      );

      setState(() {
        newMessage.status = MessageStatus.sent;
      });
    } catch (e) {
      print('Error sending message: $e');
      setState(() {
        newMessage.status = MessageStatus.failed;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    reconnectTimer?.cancel();
    stompClient?.deactivate();
    _controller.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueGrey[100],
              child: Text(
                widget.recipientName.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipientName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isConnected ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      isConnected ? "Online" : "Offline",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Call functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // Video call functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // More options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection status indicator
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: isConnected ? 0 : 36,
            color: isConnected ? Colors.transparent : Colors.redAccent,
            child: isConnected
                ? SizedBox()
                : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    connectionStatus,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // Messages list
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage('https://i.pinimg.com/originals/97/c0/07/97c00759d90d786d9b6096d274ad3e07.png'),
                  opacity: 0.1,
                  fit: BoxFit.cover,
                ),
              ),
              child: _messages.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No messages yet',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start the conversation!',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                reverse: false, // Ensure messages flow naturally
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final showDate = index == 0 ||
                      !_isSameDay(_messages[index].timestamp, _messages[index - 1].timestamp);

                  return Column(
                    children: [
                      if (showDate) _buildDateSeparator(msg.timestamp),
                      MessageBubble(message: msg),
                    ],
                  );
                },
              ),
            ),
          ),

          // Message input
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                    onPressed: () {
                      // Attachment functionality
                    },
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              maxLines: 5,
                              minLines: 1,
                              textCapitalization: TextCapitalization.sentences,
                              onSubmitted: (text) {
                                if (text.trim().isNotEmpty) sendMessage(text);
                              },
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.emoji_emotions_outlined, color: Colors.amber),
                            onPressed: () {
                              // Emoji picker
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        final text = _controller.text.trim();
                        if (text.isNotEmpty) sendMessage(text);
                      },
                      icon: Icon(Icons.send, color: Colors.white),
                      tooltip: 'Send message',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildDateSeparator(DateTime date) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _getDateText(date),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }

  String _getDateText(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, y').format(date);
    }
  }
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  received,
  read,
  failed
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  MessageStatus status;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.status = MessageStatus.sending,
  });
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('h:mm a').format(message.timestamp);

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: message.isMe ? 64 : 0,
          right: message.isMe ? 0 : 64,
        ),
        child: Column(
          crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: message.isMe
                    ? Colors.blue[600]
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: message.isMe ? Radius.circular(16) : Radius.circular(4),
                  bottomRight: message.isMe ? Radius.circular(4) : Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isMe ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeString,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (message.isMe) SizedBox(width: 4),
                  if (message.isMe)
                    _buildStatusIcon(message.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    Color iconColor;
    IconData iconData;

    switch (status) {
      case MessageStatus.sending:
        iconColor = Colors.grey;
        iconData = Icons.access_time;
        break;
      case MessageStatus.sent:
        iconColor = Colors.grey;
        iconData = Icons.check;
        break;
      case MessageStatus.delivered:
        iconColor = Colors.grey;
        iconData = Icons.done_all;
        break;
      case MessageStatus.received:
        iconColor = Colors.grey;
        iconData = Icons.done_all;
        break;
      case MessageStatus.read:
        iconColor = Colors.blue;
        iconData = Icons.done_all;
        break;
      case MessageStatus.failed:
        iconColor = Colors.red;
        iconData = Icons.error_outline;
        break;
      default:
        iconColor = Colors.grey;
        iconData = Icons.check;
    }

    return Icon(
      iconData,
      size: 14,
      color: iconColor,
    );
  }
}
