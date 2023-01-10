import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:trip_planner/models/specific_line.dart';

class PositionProvider with ChangeNotifier {
  DetailsResult? _startPosition;
  DetailsResult? _endPosition;
  int _recorridoSelected = 0;
  List<SpecificLine> micros = [];
  List<double> distances = [];

  DetailsResult? get startPosition {
    return _startPosition;
  }

  DetailsResult? get endPosition {
    return _endPosition;
  }

  int get recorridoSelected {
    return _recorridoSelected;
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
}
