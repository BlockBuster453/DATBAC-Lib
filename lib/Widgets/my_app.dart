import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stop_app/Classes/line.dart';
import 'package:stop_app/Classes/stop_place.dart';
import 'package:stop_app/Functions/fetch_stops.dart';
import 'package:stop_app/Functions/location_access.dart';
import 'package:stop_app/Widgets/drawer.dart';
import 'package:stop_app/Widgets/map.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppState() {
    fetchAllStopPlaces().then((stopPlaces) {
      _getLastPosition();
      _updateLocation();
      setState(() {
        allStops = stopPlaces;
      });
    });
  }

  var hasLocation = false;
  List<StopPlace> allStops = [];
  List<StopPlace> closeStops = [];
  List<Line> stopPlaceLines = [];
  String pressedId = '';
  bool autoFetch = false;
  Set<Marker> markers = {};

  late Position _currentLocation;
  var accuracy = 'None';

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Stopp bussen'),
          backgroundColor: const Color.fromRGBO(60, 180, 84, 1),
        ),
        body: hasLocation
            ? Map(_currentLocation, closeStops, onMarkerTap, markers)
            : null,
        drawer: hasLocation
            ? Drawer(
                child: AppDrawer(
                    _updateLocation,
                    _currentLocation,
                    closeStops,
                    accuracy,
                    stopPlaceLines,
                    pressedId,
                    autoFetch,
                    autoDrawerResponse),
              )
            : null,
      ),
    );
  }

  Future _updateLocation() async {
    hasLocation = false;
    for (var i = 0; i < 5; i += 2) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.values[i])
          .then((Position position) {
        setState(() {
          hasLocation = true;
          _currentLocation = position;
          pressedId = '';
          accuracy = LocationAccuracy.values[i]
              .toString()
              .replaceAll('LocationAccuracy.', '');
          closeStops = getCloseStopPlaces(_currentLocation, allStops);
        });
      });
    }
    markers.clear();
    setMarkers(closeStops);
  }

  Future _getLastPosition() async {
    await determinePosition().then((bool canGetPosition) async {
      if (canGetPosition) {
        await Geolocator.getLastKnownPosition()
            .then((Position? position) async {
          if (position != null) {
            setState(() {
              hasLocation = true;
              _currentLocation = position;
              accuracy = 'last known';
              closeStops = getCloseStopPlaces(_currentLocation, allStops);
            });
          }
        });
      }
    });
  }

  void onMarkerTap(String id) {
    setState(() {
      pressedId = id;
      autoFetch = true;
    });
    scaffoldKey.currentState?.openDrawer();
  }

  void autoDrawerResponse() {
    setState(() {
      pressedId = '';
      autoFetch = false;
    });
  }

  void setMarkers(List<StopPlace> closeStops) {
    for (var i = 0; i < closeStops.length; i++) {
      markers.add(Marker(
        onTap: () {
          onMarkerTap(closeStops[i].id.toString());
        },
        //add second marker
        markerId: MarkerId(i.toString()),
        position: LatLng(closeStops[i].latitude,
            closeStops[i].longitude), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: closeStops[i].name,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue), //Icon for Marker
      ));
    }
  }
}
