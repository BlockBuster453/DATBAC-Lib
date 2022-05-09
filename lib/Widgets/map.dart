import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stop_app/Classes/stop_place.dart';

class Map extends StatefulWidget {
  final Position location;
  final List<StopPlace> closeStops;
  final Set<Marker> markers;
  final Function onMarkerTap;

  const Map(this.location, this.closeStops, this.onMarkerTap, this.markers,
      {Key? key})
      : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();

  _MapState();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.location.latitude, widget.location.longitude),
        zoom: 15,
      ),
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        controller.setMapStyle(
            '[{"featureType": "poi","stylers": [{"visibility": "off"}]}]');
        _controller.complete(controller);
      },
      mapType: MapType.normal,
      markers: widget.markers,
    );
  }

}
