// To parse this JSON data, do
//
//     final rutaModel = rutaModelFromJson(jsonString);

import 'dart:convert';

List<RutaModel> rutaModelFromJson(String str) => List<RutaModel>.from(json.decode(str).map((x) => RutaModel.fromJson(x)));

String rutaModelToJson(List<RutaModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RutaModel {
    RutaModel({
        required this.id,
        required this.shape,
        required this.fidStops2,
        required this.longi,
        required this.lati,
        required this.punto,
        required this.tipo,
        required this.orden,
        required this.puntoD,
        required this.longiD,
        required this.latiD,
        required this.recorridoId,
    });

    int id;
    String shape;
    String fidStops2;
    String longi;
    String lati;
    String punto;
    String tipo;
    int orden;
    String puntoD;
    String longiD;
    String latiD;
    int recorridoId;

    factory RutaModel.fromJson(Map<String, dynamic> json) => RutaModel(
        id: json["id"],
        shape: json["Shape"],
        fidStops2: json["FID_stops2"],
        longi: json["longi"],
        lati: json["lati"],
        punto: json["Punto"],
        tipo: json["Tipo"],
        orden: json["orden"],
        puntoD: json["PuntoD"],
        longiD: json["LongiD"],
        latiD: json["LatiD"],
        recorridoId: json["recorrido_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "Shape": shape,
        "FID_stops2": fidStops2,
        "longi": longi,
        "lati": lati,
        "Punto": punto,
        "Tipo": tipo,
        "orden": orden,
        "PuntoD": puntoD,
        "LongiD": longiD,
        "LatiD": latiD,
        "recorrido_id": recorridoId,
    };
}
