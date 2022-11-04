class Linea {
  String id;
  String code;
  String direccion;
  String telefono;
  String email;
  String foto;
  String descripcion;

  Linea({
    required this.id,
    required this.code,
    required this.direccion,
    required this.telefono,
    required this.email,
    required this.foto,
    required this.descripcion,
  });

  factory Linea.fromJson(Map<dynamic, dynamic> json) {
    return Linea(
      id: json['id'].toString(),
      code: json['code'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      email: json['email'],
      foto: json['foto'],
      descripcion: json['descripcion'],
    );
  }
}
