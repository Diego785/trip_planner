// To parse this JSON data, do
//
//     final Punto = puntoFromJson(jsonString);

import 'dart:convert';

List<Punto> puntoFromJson(String str) => List<Punto>.from(
    json.decode(str).map((x) => Punto.fromJson(x)));

String puntoToJson(List<Punto> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Punto {
  Punto({
    required this.id,
    required this.punto,
    required this.puntoD,
    required this.orden,
    required this.longi,
    required this.lati,
    required this.longiD,
    required this.latiD,
    required this.recorridoId,
  });

  int id;
  int orden;
  int punto;
  int puntoD;
  String longi;
  String lati;
  String longiD;
  String latiD;
  int recorridoId;


  factory Punto.fromJson(Map<String, dynamic> json) => Punto(
        id: json["id"],
        orden: json["orden"],
        punto: json["Punto"],
        puntoD: json["PuntoD"],
        longi: json["longi"],
        lati: json["lati"],
        longiD: json["LongiD"],
        latiD: json["LatiD"],
        recorridoId: json["recorrido_id"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        // "orden": id,
        // "punto": id,
        // "PuntoD": id,
        // "longi": longi,
        // "lati": lati,
        // "LongiD": longiD,
        // "LatiD": latiD,
        // "recorrido_id": recorridoId,

      };
}
