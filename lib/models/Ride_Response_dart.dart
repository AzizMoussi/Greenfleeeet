class RideResponse {
  int driverId;
  String driverName;
  String carName;
  double rateDriver;
  String stopoverName;
  String distanceBetween;
  List<String> prefrences; // not preferences

  RideResponse({
    required this.driverId,
    required this.driverName,
    required this.carName,
    required this.rateDriver,
    required this.stopoverName,
    required this.distanceBetween,
    required this.prefrences,
  });

  factory RideResponse.fromJson(Map<String, dynamic> json) {
    return RideResponse(
      driverId: json['driverId'], // correct key
      driverName: json['driverName'],
      carName: json['carName'],
      rateDriver: (json['rateDriver'] as num).toDouble(),
      stopoverName: json['stopoverName'],
      distanceBetween: json['distanceBetween'],
      prefrences: List<String>.from(json['prefrences']), // typo respected
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'driverName': driverName,
      'carName': carName,
      'rateDriver': rateDriver,
      'stopoverName': stopoverName,
      'distanceBetween': distanceBetween,
      'prefrences': prefrences,
    };
  }
}
