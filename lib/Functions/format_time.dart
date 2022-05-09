import 'package:intl/intl.dart';

String formatTime(String time, String format) {
  DateTime parseDate;
  try {
    parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss+02:00'").parse(time);
  } on FormatException {
    parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.S+02:00'").parse(time);
  }
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat(format);
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}
