import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stop_app/Classes/line.dart';
import 'package:stop_app/Classes/stop_response.dart';
import 'package:stop_app/Functions/format_time.dart';
import 'package:stop_app/Tools/config.dart';

Future<StopResponse> sendStop(Line line) async {
  try {
    final response = await http.post(
        Uri.parse(
            'https://sanntidng-public-apim-test.azure-api.net/V1-2/digital-stop'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Ocp-Apim-Subscription-Key': API_KEY,
        },
        body: jsonEncode({
          'tripId': line.tripId,
          'stopSequence': line.order,
          'activeDate': formatTime(line.scheduleDepartureTime, 'yyyy-MM-dd'),
        }));
    return StopResponse.fromJson(
        Map<String, dynamic>.from(jsonDecode(response.body)));
  } on Error {
    throw Exception();
  }
}
