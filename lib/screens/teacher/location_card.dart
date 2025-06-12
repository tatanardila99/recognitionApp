import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/location.dart';

class LocationDisplayCard extends StatelessWidget {
  final String locationName;
  final String edificio;
  final int salon;
  final String startTime;
  final String endTime;
  final Location locationData;
  final Function(Location location) onTap;

  const LocationDisplayCard({
    super.key,
    required this.locationName,
    required this.edificio,
    required this.salon,
    required this.startTime,
    required this.endTime,
    required this.locationData,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () => onTap(locationData),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 15.0,
                decoration: const BoxDecoration(
                  color: Color(0xFF2C3E50),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Text(
                        '$locationName - ${edificio.toUpperCase()}$salon',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4.0),

                      const SizedBox(height: 8.0),

                      Text(
                        '$startTime - $endTime',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )

    );
  }
}

