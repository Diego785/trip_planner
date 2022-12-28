import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_planner/models/punto.dart';
import '../models/models.dart';

List<LatLng> listaLatLng(List<PuntosModel> points) {
  List<LatLng> lista = [];
  //List<double> distances = [];
  for (int i = 0; i < points.length; i++) {
    lista.add(
        LatLng(double.parse(points[i].lati), double.parse(points[i].longi)));
    // distances.add(Geolocator.distanceBetween(
    //     double.parse(points[i].lati),
    //     double.parse(points[i].longi),
    //     double.parse(points[i + 1].lati),
    //     double.parse(points[i + 1].longi)));
  }

  // distances.forEach((element) {
  //   print(element);
  // });
  return lista;
}

List<LatLng> listaLatLng2(List<RutaModel> points) {
  List<LatLng> lista = [];
  //List<double> distances = [];
  for (int i = 0; i < points.length; i++) {
    lista.add(
        LatLng(double.parse(points[i].lati), double.parse(points[i].longi)));
    // distances.add(Geolocator.distanceBetween(
    //     double.parse(points[i].lati),
    //     double.parse(points[i].longi),
    //     double.parse(points[i + 1].lati),
    //     double.parse(points[i + 1].longi)));
  }

  // distances.forEach((element) {
  //   print(element);
  // });
  return lista;
}

double listaLatLngDistance(List<PuntosModel> points) {
  double distance = 0;
  for (int i = 0; i < points.length - 1; i++) {
    distance = distance +
        Geolocator.distanceBetween(
            double.parse(points[i].lati),
            double.parse(points[i].longi),
            double.parse(points[i + 1].lati),
            double.parse(points[i + 1].longi));
  }
  return distance;
}

List<LatLng> listaLatLngPuntos(List<Punto> points) {
  List<LatLng> lista = [];
  //List<double> distances = [];
  for (int i = 0; i < points.length - 1; i++) {
    lista.add(
        LatLng(double.parse(points[i].lati), double.parse(points[i].longi)));
    // distances.add(Geolocator.distanceBetween(
    //     double.parse(points[i].lati),
    //     double.parse(points[i].longi),
    //     double.parse(points[i + 1].lati),
    //     double.parse(points[i + 1].longi)));
  }

  // distances.forEach((element) {
  //   print(element);
  // });
  return lista;
}
