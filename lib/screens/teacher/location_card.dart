import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../models/location.dart';

class LocationDisplayCard extends StatelessWidget {
  final String locationName;
  final String edificio;
  final int salon;
  final int? day;
  final String startTime;
  final String endTime;
  final Location locationData;
  final Function(Location location) onCameraPressed;
  final Color cardColor;

  static final List<Color> _cardColors = [
    Colors.blue.shade900,
    Colors.lightBlue.shade400,
    Colors.pinkAccent.shade100,
    Colors.cyan.shade400,
  ];

  LocationDisplayCard({
    super.key,
    required this.locationName,
    required this.edificio,
    required this.salon,
    this.day,
    required this.startTime,
    required this.endTime,
    required this.locationData,
    required this.onCameraPressed,
    Color? cardColor,
  }) : cardColor = cardColor ?? _cardColors[Random().nextInt(_cardColors.length)];

  String _formatTime(String dateString, int dayInt) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('HH:mm EEEE, dd MMMM yyyy', 'es_ES').format(dateTime);
    } on FormatException {
      final parts = dateString.split(':');
      if (parts.length == 2 && int.tryParse(parts[0]) != null && int.tryParse(parts[1]) != null) {
        final now = DateTime.now();
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final dateTimeWithCurrentDate = DateTime(now.year, now.month, dayInt - 1, hour, minute);
        return DateFormat('HH:mm EEEE, d MMMM', 'es_ES').format(dateTimeWithCurrentDate);
      }
      return "Fecha inválida";
    } catch (e) {
      return "Error de formato";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      // La tarjeta ya no está envuelta en InkWell directamente
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 12.0, 12.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      locationName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Ubicacion Registrada",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      _formatTime(startTime, day as int),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Edificio: $edificio, Salón: $salon',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      onCameraPressed(locationData);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.camera_alt, size: 24, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}