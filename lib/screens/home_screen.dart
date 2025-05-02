/*import 'package:flutter/material.dart';
import 'Inboxxxxxxx_screen.dart';
import 'inbox_screen.dart';
import 'my_rides_screen.dart';
import 'profile_screen.dart';
import 'search/search_screen.dart';
import 'publish/publish_screen.dart';
import 'publishride_flow.dart';
import 'mybooking_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    MyRidesScreen(),
    MyBookingScreen(), // Add the MyBookingScreen here
    InboxPage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Green Fleet",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF1b4242),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF1b4242),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: "My Rides",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online), // New Booking Icon
            label: "Booking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: "Inbox",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App Logo/Title
          Column(
            children: [
              Icon(
                Icons.directions_car,
                size: 64,
                color: Color(0xFF1b4242),
              ),
              SizedBox(height: 16),
              Text(
                "Green Fleet",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1b4242),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Share rides, reduce emissions",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          SizedBox(height: 48),

          // Action Cards
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FindRidePage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 32,
                      color: Color(0xFF1b4242),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Search Ride",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1b4242),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Find available rides near you",
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PublishRideFlow()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 32,
                      color: Color(0xFF1b4242),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Publish Ride",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1b4242),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Share your ride with others",
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 40),

          // Additional info or stats
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1b4242).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "1,245",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1b4242),
                      ),
                    ),
                    Text(
                      "Rides shared",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "3.2t",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1b4242),
                      ),
                    ),
                    Text(
                      "CO₂ saved",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'Inboxxxxxxx_screen.dart';
import 'inbox_screen.dart';
import 'my_rides_screen.dart';
import 'profile_screen.dart';
import 'search/search_screen.dart';
import 'publish/publish_screen.dart';
import 'publishride_flow.dart';
import 'mybooking_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;

  // Screens and their corresponding titles
  final List<Widget> _screens = [
    HomePage(),
    MyRidesScreen(),
    MyBookingScreen(),
    InboxPage(),
    Profile(),
  ];

  final List<String> _titles = [
    "Green Fleet", // Title for HomePage
    "My Rides",    // Title for MyRidesScreen
    "My Bookings", // Title for MyBookingScreen
    "Inbox",       // Title for InboxPage
    "Profile",     // Title for Profile
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      //appBar: AppBar(
        // title: Text(
        //   _titles[_currentIndex], // Dynamically update AppBar title
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     color: Colors.white,
        //     fontSize: 22,
        //     letterSpacing: 0.5,
        //   ),
        // ),
        // centerTitle: true,
        // backgroundColor: Color(0xffa0e1e1),
        // elevation: 0,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(16),
        //   ),
        // ),
        // actions: [
        //   if (_currentIndex == 3) // Show notifications icon only in InboxPage
        //     IconButton(
        //       icon: Icon(Icons.notifications_outlined, color: Colors.white),
        //       onPressed: () {
        //         // Notification action
        //       },
        //     ),
        // ],
      //),
      body: FadeTransition(
        opacity: _animationController,
        child: _screens[_currentIndex],
      ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: CustomBottomNavigationBar(
                currentIndex: _currentIndex,
                onTabChanged: _onTabChanged,
                items: [
                  CustomNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: "Home"),
                  CustomNavItem(icon: Icons.directions_car_outlined, activeIcon: Icons.directions_car, label: "My Rides"),
                  CustomNavItem(icon: Icons.book_online_outlined, activeIcon: Icons.book_online, label: "Booking"),
                  CustomNavItem(icon: Icons.inbox_outlined, activeIcon: Icons.inbox, label: "Inbox"),
                  CustomNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: "Profile"),
                ],
              ),
            ),
          ),
        )


    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image Section
          Container(
            width: double.infinity,
            height: 220,
            child: Stack(
              children: [
                // Background Image
                Container(
                  width: double.infinity,
                  height: 220,
                  child: Image.asset(
                    'images/frame3.png', // Path to the local image
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Color(0xFF1b4242),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white54,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0xFF1b4242).withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                // Welcome Text
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to Green Fleet",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3.0,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Share rides, reduce emissions, and connect with eco-conscious travelers",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2.0,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1b4242),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    // Search Ride Button
                    Expanded(
                      child: _buildActionCard(
                        context,
                        icon: Icons.search,
                        title: "Search Ride",
                        subtitle: "Find rides near you",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FindRidePage()),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    // Publish Ride Button
                    Expanded(
                      child: _buildActionCard(
                        context,
                        icon: Icons.add_circle_outline,
                        title: "Publish Ride",
                        subtitle: "Share your ride",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PublishRideFlow()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),

                // Eco Tips Section
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Color(0xFF1b4242),
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Eco Tip of the Day",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1b4242),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Carpooling just once a week can reduce your carbon footprint by up to 20%. Share your ride and make a difference!",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Footer
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 24),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF1b4242).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.eco,
                          size: 20,
                          color: Color(0xFF1b4242),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Together for a greener future",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1b4242),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1b4242), Color(0xFF2d6e6e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF1b4242).withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  CustomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabChanged;
  final List<CustomNavItem> items;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.items,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          widget.items.length,
              (index) => _buildNavItem(index),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = widget.items[index];
    final isSelected = index == widget.currentIndex;
    final isHovered = index == _hoveredIndex;

    // Define colors based on state
    final Color primaryColor = Color(0xFF1b4242);
    final Color inactiveColor = Colors.grey[400]!;
    final Color hoverColor = primaryColor.withOpacity(0.1);

    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredIndex = index),
        onExit: (_) => setState(() => _hoveredIndex = null),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isHovered && !isSelected ? hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => widget.onTabChanged(index),
              borderRadius: BorderRadius.circular(12),
              splashColor: primaryColor.withOpacity(0.1),
              highlightColor: primaryColor.withOpacity(0.05),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12), // Reduced vertical padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.all(isSelected ? 2 : 0),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color: isSelected || isHovered ? primaryColor : inactiveColor,
                        size: 22, // Slightly smaller icon
                      ),
                    ),
                    SizedBox(height: 2), // Reduced spacing
                    AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 200),
                      style: TextStyle(
                        color: isSelected || isHovered ? primaryColor : inactiveColor,
                        fontSize: isSelected ? 11 : 10, // Smaller text
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      child: Text(item.label),
                    ),
                    // Indicator dot for selected item
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: 3, // Smaller height
                      width: isSelected ? 16 : 0, // Smaller width
                      margin: EdgeInsets.only(top: 2), // Reduced margin
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}