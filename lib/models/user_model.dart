import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../dto/BookingDTO.dart';
import '../dto/RideDTO.dart';
import '../dto/VehicleDTO.dart';

class UserModel with ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _token;
  List<RideDTO> rides = [];
  List<VehicleDTO> vehicles = [];
  List<Booked> bookings = [];
  bool isLoading = false;

  Map<String, dynamic>? get user => _user;
  String? get token => _token;

  void updateUser(Map<String, dynamic> updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  Future<void> setUserData(Map<String, dynamic> user, String token) async {
    print('Setting user data: $user');
    _user = user;
    _token = token;
    isLoading = true;
    notifyListeners();

    print('Starting to fetch rides and vehicles...');
    try {
      // Wait for both fetches to complete
      await Future.wait([
        _fetchRides(),
        _fetchVehicles(),
        _fetchBookings(),
      ]);
      print('Finished fetching rides and vehicles');
      print('Final rides count: ${rides.length}');
      print('Final vehicles count: ${vehicles.length}');
      print('Final bookings count: ${bookings.length}');
    } catch (e) {
      print('Error in setUserData: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshBookings() async {
    await _fetchBookings();
  }


  // Getter for rides
  List<RideDTO> get getRides => rides;

  // Getter for vehicles
  List<VehicleDTO> get getVehicles => vehicles;

  List<Booked> get getBookings => bookings;

  Future<void> _fetchRides() async {
    print('Starting _fetchRides()');
    if (_user == null) {
      print('_user is null, returning');
      return;
    }

    if (_user!['publishedRides'] == null) {
      print('publishedRides is null, returning');
      return;
    }

    print('publishedRides: ${_user!['publishedRides']}');
    List<RideDTO> fetchedRides = [];

    for (var rideId in _user!['publishedRides']) {
      print('Fetching ride with ID: $rideId');
      try {
        var rideResponse = await _getRideById(rideId);
        if (rideResponse != null) {
          print('Successfully fetched ride: ${rideResponse.rideId}');
          fetchedRides.add(rideResponse);
        } else {
          print('Failed to fetch ride with ID: $rideId');
        }
      } catch (e) {
        print('Error fetching ride $rideId: $e');
      }
    }

    print('Total rides fetched: ${fetchedRides.length}');
    rides = fetchedRides;
    notifyListeners();
  }

  Future<RideDTO?> _getRideById(int rideId) async {
    try {
      final url = Uri.parse('http://localhost:8080/rides/$rideId');
      print('Sending GET request to: $url');

      // Add authorization header with bearer token
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

      print('Request headers: $headers');
      final response = await http.get(url, headers: headers);

      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response body: ${JsonEncoder.withIndent('  ').convert(jsonDecode(response.body))}');
        final decodedBody = utf8.decode(response.bodyBytes);
        final rideData = jsonDecode(decodedBody);

        return RideDTO.fromJson(rideData);
      } else {
        print('Error response: ${response.body}');
      }
    } catch (e) {
      print('Exception in _getRideById: $e');
    }
    return null;
  }

  Future<void> _fetchVehicles() async {
    print('Starting _fetchVehicles()');
    if (_user == null) {
      print('_user is null, returning');
      return;
    }

    if (_user!['vehicles'] == null) {
      print('vehicles is null, returning');
      return;
    }

    print('vehicles: ${_user!['vehicles']}');
    List<VehicleDTO> fetchedVehicles = [];

    for (var vehicleId in _user!['vehicles']) {
      print('Fetching vehicle with ID: $vehicleId');
      try {
        var vehicleResponse = await _getVehicleById(vehicleId);
        if (vehicleResponse != null) {
          print('Successfully fetched vehicle: ${vehicleResponse.vehicleId}');
          fetchedVehicles.add(vehicleResponse);
        } else {
          print('Failed to fetch vehicle with ID: $vehicleId');
        }
      } catch (e) {
        print('Error fetching vehicle $vehicleId: $e');
      }
    }

    print('Total vehicles fetched: ${fetchedVehicles.length}');
    vehicles = fetchedVehicles;
    notifyListeners();
  }

  Future<VehicleDTO?> _getVehicleById(int vehicleId) async {
    try {
      final url = Uri.parse('http://localhost:8080/vehicles/$vehicleId');
      print('Sending GET request to: $url');

      // Add authorization header with bearer token
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

      print('Request headers: $headers');
      final response = await http.get(url, headers: headers);

      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response body: ${JsonEncoder.withIndent('  ').convert(jsonDecode(response.body))}');
        final decodedBody = utf8.decode(response.bodyBytes);
        final vehicleData = jsonDecode(decodedBody);

        return VehicleDTO.fromJson(vehicleData);
      } else {
        print('Error response: ${response.body}');
      }
    } catch (e) {
      print('Exception in _getVehicleById: $e');
    }
    return null;
  }


  Future<void> _fetchBookings() async {
    print('Starting _fetchBookings()');
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
        bookings = responseData.map((booking) => Booked.fromJson(booking)).toList();
        print('Fetched ${bookings.length} bookings.');
        bookings.forEach((booking) {
          print(booking);
        });

      } else {
        print('Failed to fetch bookings. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in _fetchBookings: $e');
    }
    notifyListeners();
  }
}
