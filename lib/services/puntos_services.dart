import 'dart:convert';
import 'package:trip_planner/models/models.dart';
import 'package:trip_planner/providers/providers.dart';
import 'package:http/http.dart' as http;

class PuntosService {
  static Future<List<PuntosModel>> getPuntos(int recorrido, int par) async {
    var params = {"recorrido": recorrido.toString(), "par": par.toString()};
    final urlPrincipal = ServerProvider().url;
    final url = Uri.parse('$urlPrincipal/api/punto');
    // final url =  Uri.parse("http://10.0.2.2/trip_planner_bd/public/api/punto");
    final urlP = url.replace(queryParameters: params);
    final response = await http.get(urlP, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      // print('aeea');
      final List<PuntosModel> puntos =
          puntosModelFromJson(jsonEncode(respuesta['data']));
      return puntos;
    } else {
      return List.empty();
    }
  }
}
