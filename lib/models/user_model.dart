import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../dto/FriendChatDto.dart';
import '../dto/RideDTO.dart';
import '../dto/VehicleDTO.dart';
import 'booking_response_data.dart';
class UserModel with ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _token;
  List<RideDTO> rides = [];
  List<VehicleDTO> vehicles = [];
  List<BookingResponseDto> bookings = [];
  List<FriendChatDTO> friends = [];



  bool isLoading = false;

  Timer? _autoRefreshTimer;

  Map<String, dynamic>? get user => _user;
  String? get token => _token;
  List<FriendChatDTO> get getFriends => friends;

  void updateUser(Map<String, dynamic> updatedUser) {
    _autoRefreshTimer?.cancel();
    _user = updatedUser;
    notifyListeners();
  }



  Future<void> setUserData(Map<String, dynamic> user, String token) async {
    //('Setting user data: $user');
    _user = user;
    _token = token;
    isLoading = true;
    notifyListeners();

    //('Starting to fetch rides and vehicles...');
    try {
      // Wait for both fetches to complete
      await Future.wait([
        fetchRides(),
        _fetchVehicles(),
        _fetchBookings(),
        _fetchFriends(),
      ]);
      print('Finished fetching rides and vehicles');
      print('Final rides count: ${rides.length}');
      print('Final vehicles count: ${vehicles.length}');
      print('Final bookings count: ${bookings.length}');
    } catch (e) {
      //('Error in setUserData: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
    _startAutoRefresh();
  }

  Future<void> refreshBookings() async {
    await _fetchBookings();
  }

  // Getter for rides
  List<RideDTO> get getRides => rides;

  // Getter for vehicles
  List<VehicleDTO> get getVehicles => vehicles;

  List<BookingResponseDto> get getBookings => bookings;

  Future<void> fetchRides() async {
    if (_user == null) return;

    final int userId = _user!['userId'];
    final url = Uri.parse('http://localhost:8080/rides/getRides/$userId');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> rideListJson = jsonDecode(decodedBody);

        rides = rideListJson.map((json) => RideDTO.fromJson(json)).toList();
        notifyListeners();
      } else {
        print("Failed to fetch rides: ${response.body}");
      }
    } catch (e) {
      print("Exception while fetching rides: $e");
    }
  }

  Future<void> _fetchVehicles() async {
    print("NFETCHIIIIIIIIIIIIIIIIIIIIIIIIIII");
    print("NFETCHIIIIIIIIIIIIIIIIIIIIIIIIIII");
    print("NFETCHIIIIIIIIIIIIIIIIIIIIIIIIIII");

    print("NFETCHIIIIIIIIIIIIIIIIIIIIIIIIIII");
    print("NFETCHIIIIIIIIIIIIIIIIIIIIIIIIIII");
    print("NFETCHIIIIIIIIIIIIIIIIIIIIIIIIIII");


    try {
      final int userId = _user!['userId'];
      final url = Uri.parse('http://localhost:8080/users/$userId/vehicles');
      print("LINNNNNEEEEE L USER ID"+userId.toString());
      print("LINNNNNEEEEE L USER ID"+userId.toString());
      print("LINNNNNEEEEE L USER ID"+userId.toString());
      print("LINNNNNEEEEE L USER ID"+userId.toString());
      print("LINNNNNEEEEE L USER ID"+userId.toString());
      print("LINNNNNEEEEE L USER ID"+userId.toString());
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print("FISISISISIISSIISIS");
        print("FISISISISIISSIISIS");
        print("FISISISISIISSIISIS");
        print("FISISISISIISSIISIS");
        print("FISISISISIISSIISIS");
        print("FISISISISIISSIISIS");
        print("FISISISISIISSIISIS");
        print("FISISISISIISSIISIS");

        final List<dynamic> vehicleJson = json.decode(response.body);
        vehicles = vehicleJson.map((v) => VehicleDTO.fromJson(v)).toList();
        notifyListeners();
      } else {
        print('NONONONONNNNONON');
        print('NONONONONNNNONON');
        print('NONONONONNNNONON');
        print('NONONONONNNNONON');
        print('NONONONONNNNONON');
        print('NONONONONNNNONON');




        // Handle server error
        print('Failed to fetch vehicles: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error
      print('Error fetching vehicles: $e');
    }
  }

  Future<void> _fetchBookings() async {
    //('Starting _fetchBookings()');
    if (_user == null || _user!['userId'] == null) return;

    final userId = _user!['userId'];
    final url = Uri.parse('http://localhost:8080/bookings/user/$userId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        bookings = responseData.map((booking) => BookingResponseDto.fromJson(booking)).toList();
        //('Fetched ${bookings.length} bookings.');
        bookings.forEach((booking) {
          //(booking);
        });

      } else {
        //('Failed to fetch bookings. Status: ${response.statusCode}');
      }
    } catch (e) {
      //('Exception in _fetchBookings: $e');
    }
    notifyListeners();
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();

    _autoRefreshTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      print('Auto-refreshing...');
      try {
        await Future.wait([
           fetchRides(),
          _fetchVehicles(),
          _fetchBookings(),
          _fetchFriends()
        ]);
      } catch (e) {
        print('Error during auto-refresh: $e');
      }
    });
  }

  Future<void> _fetchFriends() async {
    if (_user == null || _user!['userId'] == null) return;

    final userId = _user!['userId'];
    final url = Uri.parse('http://localhost:8080/messages/friends/$userId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        friends = data.map((e) => FriendChatDTO.fromJson(e)).toList();
      } else {
        print('Failed to fetch friends: ${response.statusCode}');
      }
    } catch (e) {
        print('Exception while fetching friends: $e');
    }

    notifyListeners();
  }


}

// rideId -> list of booking ->



/*

   -Enit         Start

   -Beb saadoun   arrived     (passengerId , rideId)

   -Ensi(entreprise)   arrived

 */











