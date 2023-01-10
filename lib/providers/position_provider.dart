import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class PositionProvider with ChangeNotifier {
  DetailsResult? _startPosition;
  DetailsResult? _endPosition;

  DetailsResult? get startPosition {
    return _startPosition;
  }

  DetailsResult? get endPosition {
    return _endPosition;
  }

  set startPosition(DetailsResult? start) {
    this._startPosition = start;
    //notifyListeners();
  }

  set endPosition(DetailsResult? start) {
    this._startPosition = start;
    //notifyListeners();
  }
}
