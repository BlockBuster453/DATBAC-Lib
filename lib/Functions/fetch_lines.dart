import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:stop_app/Tools/config.dart';
import 'package:stop_app/Classes/line.dart';

Future<List<Line>> fetchStopPlaceLines(String id, double distance) async {
  try {
    final response = await http.get(
        Uri.parse('https://api.kolumbus.no/api/stopplaces/$id/departures'));
    if (response.statusCode == 200) {
      var jsonLines =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));
      List<Line> allLines = [];
      for (var i = 0; i < jsonLines.length; i++) {
        if (jsonLines[i]['schedule_departure_time'] != null) {
          var newLine = Line.fromJson(jsonLines[i]);
          if (_validLine(newLine, distance)) {
            allLines.add(newLine);
          }
        }
      }

      return allLines;
    }
    if (response.statusCode == 204) {
      List<Line> test = [];
      return test;
    } else {
      throw Exception('Failed to load lines');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}

bool _validLine(Line line, double distance) {
  if ((line.transportSubMode != "airportLinkBus") &&
      line.boarding &&
      DateTime.parse(line.scheduleDepartureTime.toString())
          .isBefore(DateTime.now().add(const Duration(minutes: TIME_LIMIT)))) {
    if (DateTime.parse(line.scheduleDepartureTime.toString()).isAfter(
        DateTime.now().add(Duration(seconds: distance ~/ WALKING_SPEED)))) {
      return true;
    }
  }
  return false;
}
