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
        required this.recorridosId,
        required this.lineaId,
    });

    int id;
    String longi;
    String lati; 
    int recorridosId;
    int lineaId;

    factory PuntosModel.fromJson(Map<String, dynamic> json) => PuntosModel(
        id: json["id"],
        longi: json["longi"],
        lati: json["lati"],
        recorridosId: json["recorridos_id"],
        lineaId: json["linea_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "longi": longi,
        "lati": lati,
        "recorridos_id": recorridosId,
        "linea_id": lineaId,
    };
}
