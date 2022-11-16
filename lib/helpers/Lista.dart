import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/models.dart';

List<LatLng> listaLatLng(List<PuntosModel> points) {
  List<LatLng> lista = [];
  for (int i = 0; i < points.length; i++) {
    lista.add(LatLng(double.parse(points[i].lati), double.parse(points[i].longi)));
  }
  return lista;
}
