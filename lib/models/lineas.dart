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
  Lineas(id: '1', name: 'Linea 1'),
  Lineas(id: '2', name: 'Linea 2'),
  Lineas(id: '3', name: 'Linea 3'),
  Lineas(id: '4', name: 'Linea 4'),
  Lineas(id: '5', name: 'Linea 5'),
  Lineas(id: '6', name: 'Linea 6'),
  Lineas(id: '7', name: 'Linea 7'),
  Lineas(id: '8', name: 'Linea 8'),
  Lineas(id: '9', name: 'Linea 9'),
  Lineas(id: '10', name: 'Linea 10'),
  Lineas(id: '11', name: 'Linea 11'),
  Lineas(id: '12', name: 'Linea 12'),
  Lineas(id: '13', name: 'Linea 13'),
  Lineas(id: '14', name: 'Linea 14'),
  Lineas(id: '15', name: 'Linea 15'),
  Lineas(id: '16', name: 'Linea 16'),
  Lineas(id: '17', name: 'Linea 17'),
  Lineas(id: '18', name: 'Linea 18'),
  Lineas(id: '19', name: 'Linea 19'),
  Lineas(id: '20', name: 'Linea 20'),
  Lineas(id: '21', name: 'Linea 21'),
  Lineas(id: '22', name: 'Linea 22'),
];

List<Lineas> lineas2 = lineas;

