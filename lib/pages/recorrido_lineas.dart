import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class RecorridoLineas extends StatefulWidget {
  const RecorridoLineas({super.key});

  @override
  State<RecorridoLineas> createState() => _RecorridoLineasState();
}

class _RecorridoLineasState extends State<RecorridoLineas> {
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kLake,
      ),
    );
  }
}
