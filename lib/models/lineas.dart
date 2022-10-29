class Lineas {
  String id;
  String name;

  Lineas({
    required this.id,
    required this.name,
  });

  factory Lineas.fromMap(Map<String, dynamic> obj) =>
      Lineas(id: obj['id'], name: obj['name']);
}

List<Lineas> lineas = [
  Lineas(id: '1', name: 'Linea 11'),
  Lineas(id: '2', name: 'Linea 12'),
  Lineas(id: '3', name: 'Linea 13'),
  Lineas(id: '4', name: 'Linea 14'),
];
