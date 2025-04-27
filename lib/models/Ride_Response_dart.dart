
/*class RideResponse {
  final int driverId;
  final String driverName;
  final String stopoverName;
  final double distanceBetween;
  final String driverPreferences;

  RideResponse({
    required this.driverId,
    required this.driverName,
    required this.stopoverName,
    required this.distanceBetween,
    required this.driverPreferenc, required double rateDriveres,
  });

  factory RideResponse.fromJson(Map<String, dynamic> json) {
    return RideResponse(
      driverId: json['driver_id'],
      driverName: json['driver_name'],
      stopoverName: json['stopover_name'],
      distanceBetween: (json['distance_between'] as num).toDouble(),
      driverPreferences: json['driver_preferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'driver_name': driverName,
      'stopover_name': stopoverName,
      'distance_between': distanceBetween,
      'driver_preferences': driverPreferences,
    };
  }
}*/
class RideResponse {
  int driverId;
  String driverName;
  String carName;
  double rateDriver;
  String stopoverName;
  String distanceBetween;
  List<String> preferences;

  RideResponse({
    required this.driverId,
    required this.driverName,
    required this.carName,
    required this.rateDriver,
    required this.stopoverName,
    required this.distanceBetween,
    required this.preferences,
  });

  factory RideResponse.fromJson(Map<String, dynamic> json) {
    return RideResponse(
      driverId: json['driver_id'],
      driverName: json['driver_name'],
      carName: json['car_name'],
      rateDriver: (json['rate_driver'] as num).toDouble(),
      stopoverName: json['stopover_name'],
      distanceBetween: json['distance_between'],
      preferences: List<String>.from(json['preferences']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'driver_name': driverName,
      'car_name': carName,
      'rate_driver': rateDriver,
      'stopover_name': stopoverName,
      'distance_between': distanceBetween,
      'preferences': preferences,
    };
  }
}
