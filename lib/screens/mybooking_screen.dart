import 'package:flutter/material.dart';

class MyBookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Booking",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1b4242),
        elevation: 0,
      ),
      body: Center(
        child: Text(
          "Your bookings will appear here.",
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}