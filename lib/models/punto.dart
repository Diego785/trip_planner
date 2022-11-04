class Punto {
  String id = "";
  String shape;
  String fid_stops2;
  String longi = "";
  String lati = "";
  String punto;
  String tipo;
  String orden = "";
  String puntoD;
  String longiD = "";
  String latiD = "";
  String recorrido_id = "";


  Punto(
    id,
    this.shape,
    this.fid_stops2,
    longi,
    lati,
    this.punto,
    this.tipo,
    orden,
    this.puntoD,
    longiD,
    latiD,
    recorrido_id,
  ) {
    this.id = id.toString();
    this.longi = longi.toString();
    this.lati = lati.toString();
    this.orden = orden.toString();
    this.longiD = longiD.toString();
    this.latiD = latiD.toString();
    this.recorrido_id = recorrido_id.toString();
  }

factory Punto.fromJson(Map<dynamic, dynamic> json) {
    return Punto(
      json['id'],
      json['Shape'],
      json['FID_stops2'],
      json['Longi'],
      json['Lati'],
      json['Punto'],
      json['Tipo'],
      json['orden'],
      json['PuntoD'],
      json['PongiD'],
      json['LatiD'],
      json['recorrido_id'],

    );
  }


}
