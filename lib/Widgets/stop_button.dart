import 'package:flutter/material.dart';
import 'package:stop_app/Classes/line.dart';
import 'package:stop_app/Functions/send_stop.dart';
import 'package:stop_app/Classes/stop_response.dart';

class Stop extends StatelessWidget {
  final Line? line;
  final Function onStop;
  const Stop(this.line, this.onStop, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (line != null) {
      return ElevatedButton(
          child: const Text('Stopp'),
          onPressed: () async {
            var response = await sendStop(line!);
            onStop(response.success);
          });
    } else {
      return const ElevatedButton(child: Text('Stopp'), onPressed: null);
    }
  }
}
