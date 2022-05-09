import 'package:flutter/material.dart';
import 'package:stop_app/Classes/line.dart';

class LineButton extends StatelessWidget {
  final Line line;
  final Function onLineSelect;
  final Line? selectedLine;
  final bool isStopped;

  const LineButton(this.line, this.onLineSelect, this.selectedLine, this.isStopped, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Column(
        children: [
          Text(
            line.expectedDepartureTime != null
                ? '${line.lineName} mot ${line.destination}\nAvgang: ${line.formattedTime(line.expectedDepartureTime.toString())}'
                : '${line.lineName} mot ${line.destination}\nAvgang: ${line.formattedTime(line.scheduleDepartureTime.toString())}',
            textAlign: TextAlign.center,
            maxLines: 3,
            style: TextStyle(
                fontSize: 15.0,
                color: isStopped == true ? Colors.grey: line.expectedDepartureTime != null
                    ? Colors.green
                    : Colors.black),
          ),
        ],
      ),
      onPressed: isStopped ? null : () {
        onLineSelect(line);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
        primary:
            line.id == selectedLine?.id ? Colors.blueGrey[200] : Colors.white,
      ),
    );
  }
}
