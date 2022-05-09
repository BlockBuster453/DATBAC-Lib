import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:stop_app/Tools/config.dart';
import 'package:stop_app/Classes/stop_place.dart';

Future<List<StopPlace>> fetchAllStopPlaces() async {
  try {
    final response = await http.get(
        Uri.parse('https://api.kolumbus.no/api/stopplaces?transportMode=bus'));
    if (response.statusCode == 200) {
      var jsonStopPlaces =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));
      List<StopPlace> stopPlaces = [];
      for (var i = 0; i < jsonStopPlaces.length; i++) {
        var newStopPlace = StopPlace.fromJson(jsonStopPlaces[i]);
        if (newStopPlace.modification != 'delete') {
          stopPlaces.add(newStopPlace);
        }
      }
      return stopPlaces;
    } else {
      throw Exception('Failed to load stop places');
    }
  } on Error {
    throw Exception('No location data yet');
  }
}

List<StopPlace> getCloseStopPlaces(
    Position userLocation, List<StopPlace> stopPlaces) {
  List<StopPlace> closeStops = [];
  for (var i = 0; i < stopPlaces.length; i++) {
    if (stopPlaces[i].distanceTo(userLocation) <= DISTANCE) {
      if (stopPlaces[i].type == 'onstreetBus') {
        closeStops.add(stopPlaces[i]);
      }
     
    }
  }
  closeStops.sort((a, b) =>
      a.distanceTo(userLocation).compareTo(b.distanceTo(userLocation)));
  return closeStops;
}
