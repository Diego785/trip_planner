import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:trip_planner/models/specific_line.dart';

class LineServices {
  static Future<List<SpecificLine>> getMicro(int recorrido) async {
    List<SpecificLine> micro = [];
    var params = {"recorrido": recorrido.toString()};
    //final urlPrincipal = ServerProvider().url;
    //final url = Uri.parse('$urlPrincipal/api/punto');
    final url =
        Uri.parse("http://10.0.2.2/trip_planner_bd/public/api/recorridoLinea");
    final urlP = url.replace(queryParameters: params);
    final response = await http.get(urlP, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      // print('aeea');
      micro = specificLineFromJson(jsonEncode(respuesta));
      return micro;
    } else {
      return List.empty();
    }
  }
}
