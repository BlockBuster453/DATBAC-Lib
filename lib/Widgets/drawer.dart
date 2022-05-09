import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stop_app/Functions/format_time.dart';
import 'package:stop_app/Widgets/cancel_button.dart';
import 'package:stop_app/Widgets/drawer_button.dart';
import 'package:stop_app/Functions/fetch_lines.dart';
import 'package:stop_app/Classes/stop_place.dart';
import 'package:stop_app/Classes/line.dart';
import 'package:stop_app/Widgets/refresh.dart';
import 'package:stop_app/Widgets/stop_button.dart';

import '../Functions/fetch_lines.dart';

class AppDrawer extends StatefulWidget {
  final VoidCallback updateLocation;
  final Position position;
  final List<StopPlace> stopPlaces;
  final List<Line> stopPlaceLines;
  String pressedId = '';
  bool autoFetch = false;
  final VoidCallback autoDrawerResponse;

  final String accuracy;
  AppDrawer(
      this.updateLocation,
      this.position,
      this.stopPlaces,
      this.accuracy,
      this.stopPlaceLines,
      this.pressedId,
      this.autoFetch,
      this.autoDrawerResponse,
      {Key? key})
      : super(key: key);

  @override
  State<AppDrawer> createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {
  List<Line> lines = [];
  String message = '';
  StopPlace? selectedStopPlace;
  Line? selectedLine;
  bool isStopped = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 240.0,
            child: DrawerHeader(
              child: Column(
                children: [
                  const Text('Finn holdeplass'),
                  Text('Presisjon: ${widget.accuracy}'),
                  Refresh(onRefresh, isStopped),
                  if (!isStopped) Stop(selectedLine, onStop),
                  if (isStopped) Cancel(selectedLine, onCancel),
                  if (message != '') Text(message)
                ],
              ),
            ),
          ),
          if (widget.stopPlaces.isEmpty) const CircularProgressIndicator(),
          ...widget.stopPlaces.map((stopPlace) {
            if (widget.autoFetch && stopPlace.id == widget.pressedId) {
              fetchLines(
                  stopPlace.id.toString(),
                  stopPlace.distanceTo(widget.position),
                  stopPlace.name.toString());
            }
            return DrawerButton(
                stopPlace,
                lines,
                widget.position,
                onStopPlaceClick,
                widget.pressedId,
                onLinePressed,
                selectedLine,
                isStopped);
          })
        ],
      ),
    );
  }

  void onStopPlaceClick(String id, double distance, String name) async {
    if (widget.pressedId != id) {
      await fetchLines(id, distance, name);
    } else {
      setState(() {
        lines = [];
        widget.pressedId = '';
        message = '';
      });
      widget.autoDrawerResponse();
    }
  }

  Future fetchLines(String id, double distance, String name) async {
    setState(() {
      lines = [];
      widget.pressedId = id;
      message = '';
      widget.autoFetch = false;
    });
    await fetchStopPlaceLines(id, distance).then((l) {
      setState(() {
        if (l.isNotEmpty) {
          lines = l;
        } else {
          widget.pressedId = '';
          message = 'Ingen aktuelle busser fra $name';
        }
      });
    });
  }

  void onRefresh() {
    widget.updateLocation();
    setState(() {
      message = '';
      selectedLine = null;
      selectedStopPlace = null;
    });
  }

  void onLinePressed(stopPlace, line) {
    setState(() {
      selectedStopPlace = stopPlace;
      selectedLine = line;
    });
  }

  void onStop(bool validStop) {
    setState(() {
      if (validStop) {
        isStopped = true;
        message =
            '${selectedLine!.lineName} stopper på ${selectedStopPlace!.name} kl. ${formatTime(selectedLine!.scheduleDepartureTime, 'HH:mm')}';
      } else {
        isStopped = false;
        message = 'Noe gikk galt, prøv å stoppe på nytt';
      }
    });
  }

  void onCancel(bool validCancel) {
    setState(() {
      if (validCancel) {
        isStopped = false;
        message = 'Bestilling om stopp er avbrutt';
      }
    });
  }
}
