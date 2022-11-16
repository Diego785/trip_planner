import 'package:flutter/material.dart';
import 'dart:math' as math;

class Responsive {
  late double _width, _height, _diagonal;
  late bool _istablet;

  // como los valores son privados, defino nlos gets para obtener esos valores
  double get width => _width;
  double get height => _height;
  double get diagonal => _diagonal;
  bool get istablet => _istablet;

  //una funcion estatica que retorne una istancia de la clase responive
  static Responsive of(BuildContext context) => Responsive(context);

  Responsive(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    this._width = size.width;
    this._height = size.height;
    // c2 +a2 +b2 = c = srt(a2+b2)
    this._diagonal = math.sqrt(math.pow(_width, 2) + math.pow(_height, 2));

    //para saber si mi dispositovo es una table o no
    this._istablet = size.shortestSide >= 600;
  }

  //funciones para crear porcentajes
  double wp(double percent) => _width * percent / 100;
  double hp(double percent) => _height * percent / 100;
  double dp(double percent) => _diagonal * percent / 100;
}
