class Recorrido {
  String id;
  String code;
  String tiempo;
  String distancia;
  String velocidad;
  String color;
  String grosor;
  String descripcion;
  String linea_id;

  Recorrido({
    required this.id,
    required this.code,
    required this.tiempo,
    required this.distancia,
    required this.velocidad,
    required this.color,
    required this.grosor,
    required this.descripcion,
    required this.linea_id,
  });

  factory Recorrido.fromJson(Map<dynamic, dynamic> json) {
    return Recorrido(
      id: json['id'],
      code: json['code'],
      tiempo: json['tiempo'],
      distancia: json['distancia'],
      velocidad: json['velocidad'],
      color: json['color'],
      grosor: json['grosor'],
      descripcion: json['descripcion'],
      linea_id: json['linea_id'],
    );
  }
}
