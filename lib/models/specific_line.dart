// To parse this JSON data, do
//
//     final specificLine = specificLineFromJson(jsonString);

import 'dart:convert';

List<SpecificLine> specificLineFromJson(String str) => List<SpecificLine>.from(
    json.decode(str).map((x) => SpecificLine.fromJson(x)));

String specificLineToJson(List<SpecificLine> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpecificLine {
  SpecificLine({
    required this.id,
    required this.code,
    required this.velocidad,
    required this.descripcionMicro,
    required this.descripcionLinea,
    required this.foto,
    required this.telefono,
  });

  int id;
  String code;
  int velocidad;
  String descripcionMicro;
  String descripcionLinea;
  String foto;
  String telefono;

  factory SpecificLine.fromJson(Map<String, dynamic> json) => SpecificLine(
        id: json["id"],
        code: json["code"],
        velocidad: json["velocidad"],
        descripcionMicro: json["descripcion_micro"],
        descripcionLinea: json["descripcion_linea"],
        foto: json["foto"],
        telefono: json["telefono"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "velocidad": velocidad,
        "descripcion_micro": descripcionMicro,
        "descripcion_linea": descripcionLinea,
        "foto": foto,
        "telefono": telefono,
      };
}
