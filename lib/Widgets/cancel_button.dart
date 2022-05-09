import 'package:flutter/material.dart';
import 'package:stop_app/Classes/line.dart';
import 'package:stop_app/Functions/cancel_stop.dart';

class Cancel extends StatelessWidget {
  final Line? line;
  final Function onCancel;

  const Cancel(this.line, this.onCancel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: const Text('Avbryt'),
        onPressed: () async {
          var response = await cancelStop(line!);
          onCancel(response);
        });
  }
}
