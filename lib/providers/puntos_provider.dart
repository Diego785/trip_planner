import 'package:flutter/material.dart';
import 'package:trip_planner/models/models.dart';
import 'package:trip_planner/services/services.dart';

class PuntosProvider extends ChangeNotifier {
  List<PuntosModel>? punto = null;

  setPunto(int recorrido, int par) async {
    punto = null;
    punto = await PuntosService.getPuntos(recorrido, par);
    notifyListeners();
  }
}
