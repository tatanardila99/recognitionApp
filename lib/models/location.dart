class Location {
  final int id;
  final String name;
  final int? status;
  final String edificio;
  final int salon;
  final int? day;
  final String horaEntrada;
  final String horaSalida;
  final int? responsibleId;

  Location({
    required this.id,
    required this.name,
    this.status,
    required this.edificio,
    required this.salon,
    this.day,
    required this.horaEntrada,
    required this.horaSalida,
    this.responsibleId,
  });




  factory Location.fromJson(Map<String, dynamic> json) {
    /*final int? dayOfWeekInt = json['day_of_week'] as int;
    String? dayString;
    if (dayOfWeekInt != null) {
      switch (dayOfWeekInt) {
        case 1:
          dayString = 'Lunes';
          break;
        case 2:
          dayString = 'Martes';
          break;
        case 3:
          dayString = 'Miércoles';
          break;
        case 4:
          dayString = 'Jueves';
          break;
        case 5:
          dayString = 'Viernes';
          break;
        case 6:
          dayString = 'Sábado';
          break;
        case 7:
          dayString = 'Domingo';
          break;
        default:
          dayString = null;
          break;
      }
    }*/

    return Location(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as int?,
      edificio: json['edificio'] as String,
      salon: json['salon'] as int,
      day: json['day_of_week'] as int?,
      horaEntrada: (json['hour_start'] as String?)?.substring(0, 5) ?? 'N/A',
      horaSalida: (json['hour_end'] as String?)?.substring(0, 5) ?? 'N/A',
      responsibleId: json['user_id'] as int?,
    );
  }
}
