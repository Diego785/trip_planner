// To parse this JSON data, do
//
//     final puntosModel = puntosModelFromJson(jsonString);

import 'dart:convert';

List<PuntosModel> puntosModelFromJson(String str) => List<PuntosModel>.from(json.decode(str).map((x) => PuntosModel.fromJson(x)));

String puntosModelToJson(List<PuntosModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PuntosModel {
    PuntosModel({
        required this.id,
        required this.longi,
        required this.lati,
        required this.recorridoId,
        required this.lineaId,
        required this.color,
    });

    int id;
    String longi;
    String lati; 
    int recorridoId;
    int lineaId;
    String color;

    factory PuntosModel.fromJson(Map<String, dynamic> json) => PuntosModel(
        id: json["id"],
        longi: json["longi"],
        lati: json["lati"],
        recorridoId: json["recorrido_id"],
        lineaId: json["linea_id"],
        color: json["color"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "longi": longi,
        "lati": lati,
        "recorrido_id": recorridoId,
        "linea_id": lineaId,
        "color": color,
    };
}
