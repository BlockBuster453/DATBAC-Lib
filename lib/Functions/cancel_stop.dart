import 'package:http/http.dart' as http;
import 'package:stop_app/Classes/line.dart';
import 'package:stop_app/Classes/stop_response.dart';
import 'package:stop_app/Functions/format_time.dart';
import 'package:stop_app/Tools/config.dart';

Future<bool> cancelStop(Line line) async {
  try {
    var activeDate = formatTime(line.scheduleDepartureTime, 'yyyy-MM-dd');
    var tripId = line.tripId;
    var stopSequence = line.order;
    final response = await http.delete(Uri.parse(
        'https://sanntidng-public-apim-test.azure-api.net/V1-2/digital-stop/$activeDate/$tripId/$stopSequence'),
        headers: <String,String>{
          'Ocp-Apim-Subscription-Key': API_KEY
        });
    bool validCancel;

    response.statusCode == 200 ? validCancel = true : validCancel = false;
    return validCancel;
  } on Error {
    throw Exception();
  }
}
