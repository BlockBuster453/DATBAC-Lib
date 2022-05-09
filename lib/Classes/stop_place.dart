import 'package:geolocator/geolocator.dart';

class StopPlace {
  final String? id;
  final String externalId;
  final String? nsrId;
  final String? name;
  final String? description;
  final double latitude;
  final double longitude;
  final String modification;
  final String type;



  StopPlace({
    required this.id,
    required this.externalId,
    required this.nsrId,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.modification,
    required this.type,

  });

  double distanceTo(Position userLocation) {
    var distance = Geolocator.distanceBetween(
        userLocation.latitude, userLocation.longitude, latitude, longitude);
    return distance;
  }

  String distanceToAsString(Position userLocation) {
    var d = distanceTo(userLocation);
    return d.toStringAsFixed(d.truncateToDouble() == d ? 0 : 0);
  }

  factory StopPlace.fromJson(Map<String, dynamic> json) {
    return StopPlace(
      id: json['id'],
      externalId: json['id'],
      nsrId: json['nsrId'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      modification: json['modification'],
      type: json['type']
    );
  }
}
