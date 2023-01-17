import 'dart:convert';
import 'package:trip_planner/models/models.dart';
import 'package:trip_planner/providers/providers.dart';
import 'package:http/http.dart' as http;


Future<List<RutaModel>> getRuta() async {
  final urlPrincipal = ServerProvider().url;
  final url = Uri.parse('$urlPrincipal/api/ruta');
  final response = await http.get(url, headers: {
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