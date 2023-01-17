import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:trip_planner/models/specific_line.dart';
import 'package:trip_planner/providers/providers.dart';

import '../providers/providers.dart';

class LineServices {
  static Future<List<SpecificLine>> getMicro(int recorrido) async {
    List<SpecificLine> micro = [];
    var params = {"recorrido": recorrido.toString()};
    final urlPrincipal = ServerProvider().url;
    final url = Uri.parse('$urlPrincipal/api/recorridoLinea');
    final urlP = url.replace(queryParameters: params);
    final response = await http.get(urlP, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      micro = specificLineFromJson(jsonEncode(respuesta));
      return micro;
    } else {
      return List.empty();
    }
  }
}
