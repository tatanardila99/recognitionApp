class Location {
  final int id;
  final String name;
  final int? status;
  final String edificio;
  final int salon;
  final String horaEntrada;
  final String horaSalida;
  final int? responsibleId;

  Location({
    required this.id,
    required this.name,
    this.status,
    required this.edificio,
    required this.salon,
    required this.horaEntrada,
    required this.horaSalida,
    this.responsibleId,
  });

  factory Location.fromJson(Map<String, dynamic> json) {


    return Location(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as int?,
      edificio: json['edificio'] as String,
      salon: json['salon'] as int,
      horaEntrada: (json['hour_start'] as String?)?.substring(0, 5) ?? 'N/A',
      horaSalida: (json['hour_end'] as String?)?.substring(0, 5) ?? 'N/A',
      responsibleId: json['user_id'] as int?,
    );
  }
}
