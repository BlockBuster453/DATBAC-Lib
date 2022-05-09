import 'package:stop_app/Widgets/stop_button.dart';

class StopResponse {
  final bool success;
  final String? message;

  StopResponse({
    required this.success,
    required this.message,
  });

  factory StopResponse.fromJson(Map<String, dynamic> json) {
    return StopResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}
