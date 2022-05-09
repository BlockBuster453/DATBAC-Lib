import 'package:stop_app/Functions/format_time.dart';

class Line {
  final String id;
  final String lineNumber;
  final String lineName;
  final String destination;
  final String platformExternalId;
  final String scheduleDepartureTime;
  String? expectedDepartureTime;
  final bool boarding;
  final String? transportSubMode;
  final String tripId;
  final int order;

  Line({
    required this.id,
    required this.lineNumber,
    required this.lineName,
    required this.destination,
    required this.platformExternalId,
    required this.scheduleDepartureTime,
    this.expectedDepartureTime,
    required this.boarding,
    required this.transportSubMode,
    required this.tripId,
    required this.order,
  });

  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
        id: json['id'],
        lineNumber: json['line_number'],
        lineName: json['line_name'],
        destination: json['destination'],
        platformExternalId: json['platform_external_id'],
        scheduleDepartureTime: json['schedule_departure_time'],
        expectedDepartureTime: json['expected_departure_time'],
        transportSubMode: json['transport_sub_mode'],
        boarding: json['boarding'],
        tripId: json['trip_id'],
        order: json['order']);
  }

  String formattedTime(String time) {
    return formatTime(time, 'HH:mm');
  }
}
