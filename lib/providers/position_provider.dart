import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:trip_planner/models/specific_line.dart';

class PositionProvider with ChangeNotifier {
  DetailsResult? _startPosition;
  DetailsResult? _endPosition;
  int _recorridoSelected = 0;
  bool _recorridosShowed = false;
  List<SpecificLine> micros = [];
  List<double> distances = [];

  double _startPositionLati = 0;
  double _startPositionLongi = 0;
  double _endPositionLati = 0;
  double _endPositionLongi = 0;

  DetailsResult? get startPosition {
    return _startPosition;
  }

  DetailsResult? get endPosition {
    return _endPosition;
  }

  int get recorridoSelected {
    return _recorridoSelected;
  }

   bool get recorridosShowed {
    return _recorridosShowed;
  }

  double get startPositionLati{
    return _startPositionLati;
  }

  double get startPositionLongi{
    return _startPositionLongi;
  }
  double get endPositionLati{
    return _endPositionLati;
  }
  double get endPositionLongi{
    return _endPositionLongi;
  }

  set startPosition(DetailsResult? start) {
    this._startPosition = start;
    //notifyListeners();
  }

  set endPosition(DetailsResult? end) {
    this._endPosition = end;
    //notifyListeners();
  }

  set recorridoSelected(int recorrido) {
    this._recorridoSelected = recorrido;
    //notifyListeners();
  }

  set recorridosShowed(bool showed) {
    this._recorridosShowed = showed;
    //notifyListeners();
  }

  set startPositionLati(double startPositionLat) {
    this._startPositionLati = startPositionLat;
    //notifyListeners();
  }
  set startPositionLongi(double startPositionLon){
    this._startPositionLongi = startPositionLon;
    //notifyListeners();
  }
  set endPositionLati(double endPositionLat) {
    this._endPositionLati = endPositionLat;
    //notifyListeners();
  }
  set endPositionLongi(double endPositionLon) {
    this._endPositionLongi = endPositionLon;
    //notifyListeners();
  }
}
