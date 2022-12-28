import 'package:flutter/material.dart';

class ServerProvider extends ChangeNotifier {
  //final String _url = 'http://35.198.5.59';
  //final String _url = 'http://192.168.0.7:8000';
  final String _url = 'http://10.0.2.2/trip_planner_bd/public';


  String get url {
    return _url;
  }
}
