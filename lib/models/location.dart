class Location {
  final int id;
  final String name;
  final String edificio;
  final int salon;
  final String horaEntrada;
  final String horaSalida;

  Location({
    required this.id,
    required this.name,
    required this.edificio,
    required this.salon,
    required this.horaEntrada,
    required this.horaSalida,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int,
      name: json['name'] as String,
      edificio: json['edificio'] as String,
      salon: json['salon'] as int,
      horaEntrada: json['hora_entrada'] as String,
      horaSalida: json['hora_salida'] as String,
    );
  }
}