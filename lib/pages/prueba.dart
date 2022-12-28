import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_planner/services/rutas_services.dart';

import '../models/models.dart';

class Prueba extends StatefulWidget {
  final LatLng puntoOrigen;
  final LatLng puntoDestino;
  Prueba({Key? key, required this.puntoOrigen, required this.puntoDestino})
      : super(key: key);

  @override
  State<Prueba> createState() =>
      _PruebaState(puntoOrigen: puntoOrigen, puntoDestino: puntoDestino);
}

class _PruebaState extends State<Prueba> {
  final LatLng puntoOrigen;
  final LatLng puntoDestino;
  _PruebaState({required this.puntoOrigen, required this.puntoDestino});

  List<RutaModel>? rutas;

  @override
  void initState() {
    super.initState();
    loadData2(puntoOrigen, puntoDestino);
  }

  loadData2(origen, destino) async {
    rutas = await getRuta();
    final circuloOrigenLatitud = puntoOrigen.latitude;
    final circuloOrigenLongitud = puntoOrigen.longitude;

    final circuloDestinoLatitud = puntoDestino.latitude;
    final circuloDestinoLongitud = puntoDestino.longitude;

    late List<RutaModel> puntoCercaOrigen = [];
    late List<RutaModel> puntoCercaDestino = [];

    //recorre toda la base de datos stop_int_2
    for (var i = 0; i < rutas!.length; i++) {
      //distancia que hay entre un punto y el origen seleccionado
      var distanciaOrigen = await Geolocator.distanceBetween(
          circuloOrigenLatitud,
          circuloOrigenLongitud,
          double.parse(rutas![i].lati),
          double.parse(rutas![i].longi));
      //distancia que hay entre un punto y el destino seleccionado
      var distanciaDestino = await Geolocator.distanceBetween(
          circuloDestinoLatitud,
          circuloDestinoLongitud,
          double.parse(rutas![i].lati),
          double.parse(rutas![i].longi));

      //si el punto se encuentra a menos de 200 metros del origen
      if (distanciaOrigen <= 200) {
        //si la lista esta vacia agrego el punto a puntoCercaOrigen
        if (puntoCercaOrigen.isEmpty) {
          puntoCercaOrigen.add(rutas![i]);
        } else {
          //si no esta vacia que busque si ya hay un code de esa linea
          int existe = puntoCercaOrigen
              .indexWhere((item) => item.recorridoId == rutas![i].recorridoId);
          if (existe == -1) {
            //si no existe code agrego el nuevo punto
            puntoCercaOrigen.add(rutas![i]);
          } else {
            //si existe code, obtengo el objeto ruta al que pertenece ese code
            RutaModel rutaExistente = puntoCercaOrigen.firstWhere(
                (item) => item.recorridoId == rutas![i].recorridoId);
            //calculo la distancia de ese code repetido
            var newDistanceOrigen = await Geolocator.distanceBetween(
                circuloOrigenLatitud,
                circuloOrigenLongitud,
                double.parse(rutaExistente.lati),
                double.parse(rutaExistente.longi));
            //si la distancia del nuevo punto es menor
            if (distanciaOrigen < newDistanceOrigen) {
              //elimino el code que tiene mayor distancia
              puntoCercaOrigen.removeWhere(
                  (item) => item.recorridoId == rutas![i].recorridoId);
              //agrego el mismo code pero con distancia mas cercana al origen
              puntoCercaOrigen.add(rutas![i]);
            }
          }
        }
      }
      //si el punto se encuentra a menos de 200 metros del destino
      if (distanciaDestino <= 200) {
        //si la lista esta vacia agrego el punto a puntoCercaDestino
        if (puntoCercaDestino.length == 0) {
          puntoCercaDestino.add(rutas![i]);
        } else {
          //si no esta vacia que busque si ya hay un code de esa linea
          int existe = puntoCercaDestino
              .indexWhere((item) => item.recorridoId == rutas![i].recorridoId);
          if (existe == -1) {
            //si no existe code agrego el nuevo punto
            puntoCercaDestino.add(rutas![i]);
          } else {
            //si existe code, obtengo el objeto ruta al que pertenece ese code
            RutaModel rutaExistente = puntoCercaDestino.firstWhere(
                (item) => item.recorridoId == rutas![i].recorridoId);
            //calculo la distancia de ese code repetido
            var newDistanceOrigen = await Geolocator.distanceBetween(
                circuloOrigenLatitud,
                circuloOrigenLongitud,
                double.parse(rutaExistente.lati),
                double.parse(rutaExistente.longi));
            //si la distancia del nuevo punto es menor
            if (distanciaOrigen < newDistanceOrigen) {
              //elimino el code que tiene mayor distancia
              puntoCercaDestino.removeWhere(
                  (item) => item.recorridoId == rutas![i].recorridoId);
              //agrego el mismo code pero con distancia mas cercana al origen
              puntoCercaDestino.add(rutas![i]);
            }
          }
        }
      }
    }
    //en este punto tendre una lista con todos los puntos a menos de 200 metros del origen en la lista puntoCercaOrigen
    //en este punto tendre una lista con todos los puntos a menos de 200 metros del destino en la lista puntoCercaDestino
    final List<RutaModel> resultadosDirectos = [];

    for (var i = 0; i < puntoCercaOrigen.length; i++) {
      for (var j = 0; j < puntoCercaDestino.length; j++) {
        if (puntoCercaOrigen[i].recorridoId ==
            puntoCercaDestino[j].recorridoId) {
          resultadosDirectos.add(puntoCercaDestino[j]);
          //print('punto: ' + puntoCercaDestino[i].code);
        }
      }
    }
    print(puntoCercaOrigen.length.toString());
    for (var i = 0; i < puntoCercaOrigen.length; i++) {
      print('punto origen:${puntoCercaOrigen[i].recorridoId}');
    }

    for (var i = 0; i < puntoCercaDestino.length; i++) {
      print('punto destino:${puntoCercaDestino[i].recorridoId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
