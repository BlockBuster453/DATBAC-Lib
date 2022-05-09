import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../Classes/stop_place.dart';
import '../Classes/line.dart';
import 'line_button.dart';

class DrawerButton extends StatelessWidget {
  final StopPlace stopPlace;
  final List<Line> lines;
  final Position position;
  final Function onStopPlaceClick;
  final String pressedId;
  final Function onLinePressed;
  final Line? selectedLine;
  final bool isStopped;

  const DrawerButton(
      this.stopPlace,
      this.lines,
      this.position,
      this.onStopPlaceClick,
      this.pressedId,
      this.onLinePressed,
      this.selectedLine,
      this.isStopped,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: Text(
              '${stopPlace.name}: ${stopPlace.distanceToAsString(position)}m'),
          onPressed: isStopped ? null : () async {
            await onStopPlaceClick(stopPlace.externalId,
                stopPlace.distanceTo(position), stopPlace.name);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
            primary: const Color.fromRGBO(60, 180, 84, 1),
          ), 

        ),
        Visibility(
          child: lines.isNotEmpty
              ? Column(
                  children: [
                    ...lines.map((line) {
                      return LineButton(line, onLineSelect, selectedLine, isStopped);
                    }),
                  ],
                )
              : const CircularProgressIndicator(),
          visible: pressedId == stopPlace.externalId,
        ),
      ],
    );
  }

  void onLineSelect(Line line) {
    onLinePressed(stopPlace, line);
  }
}
