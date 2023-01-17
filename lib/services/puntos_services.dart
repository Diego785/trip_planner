import 'dart:convert';
import 'package:trip_planner/models/models.dart';
import 'package:trip_planner/models/punto.dart';
import 'package:trip_planner/providers/providers.dart';
import 'package:http/http.dart' as http;

class PuntosService {
  static Future<List<PuntosModel>> getPuntos(int recorrido, int par) async {
    var params = {"recorrido": recorrido.toString(), "par": par.toString()};
    final urlPrincipal = ServerProvider().url;
    final url = Uri.parse('$urlPrincipal/api/punto');
    //final url =  Uri.parse("http://10.0.2.2/trip_planner_bd/public/api/punto");
    final urlP = url.replace(queryParameters: params);
    final response = await http.get(urlP, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      final List<PuntosModel> puntos =
          puntosModelFromJson(jsonEncode(respuesta['data']));
      return puntos;
    } else {
      return List.empty();
    }
  }

  static Future<List<RutaModel>> transbordo(int fid1, int fid2) async {
    var params = {"fidorigen": fid1.toString(), "fiddestino": fid2.toString()};
    final urlPrincipal = ServerProvider().url;
    final url = Uri.parse('$urlPrincipal/api/transbordo');
    //final url =  Uri.parse("http://10.0.2.2/trip_planner_bd/public/api/punto");
    final urlP = url.replace(queryParameters: params);
    final response = await http.get(urlP, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      final List<RutaModel> puntos =
          rutaModelFromJson(jsonEncode(respuesta['data']));
      return puntos;
    } else {
      return List.empty();
    }
  }

  static Future<List<Punto>> getAllPuntos() async {
    //var params = {"recorrido": recorrido.toString(), "par": par.toString()};
    final urlPrincipal = ServerProvider().url;
    final url = Uri.parse('$urlPrincipal/api/allpoints');
    // final url =
    //     Uri.parse("http://10.0.2.2/trip_planner_bd/public/api/allpoints");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      final List<Punto> puntos = puntoFromJson(jsonEncode(respuesta));
      return puntos;
    } else {
      return List.empty();
    }
  }
}
