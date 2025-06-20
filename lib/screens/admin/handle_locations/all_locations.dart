
import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/models/location.dart';
import 'package:uts_recognitionapp/services/service.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {

  late Future<List<Location>> _locationsFuture;

  @override
  void initState() {
    super.initState();
    _locationsFuture = BackendService().getLocations(context);
  }

  Future<void> _refreshLocations() async {
    setState(() {
      _locationsFuture = BackendService().getLocations(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Ubicaciones'),
        backgroundColor: Color(0xFF899DD9),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshLocations,
        child: FutureBuilder<List<Location>>(
          future: _locationsFuture,
          builder: (context, snapshot) {

            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final List<Location> locations = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final location = locations[index];


                  Color statusColor = Colors.grey;
                  IconData statusIcon = Icons.info_outline;
                  String statusText = 'Desconocido';

                  if (location.status == 1) {
                    statusColor = Colors.green;
                    statusIcon = Icons.check_circle;
                    statusText = 'Activo';
                  } else if (location.status == 0) {
                    statusColor = Colors.red;
                    statusIcon = Icons.cancel;
                    statusText = 'Inactivo';
                  } else {
                    statusText = 'Estado ${location.status}';
                  }


                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: InkWell(
                      onTap: () {

                      },
                      borderRadius: BorderRadius.circular(15.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    location.name,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[850],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(statusIcon, color: statusColor, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      statusText,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 20, thickness: 1),

                            _buildInfoRow(Icons.business, 'Edificio', location.edificio),
                            _buildInfoRow(Icons.meeting_room, 'Salón', location.salon.toString()),
                            _buildInfoRow(Icons.timer_outlined, 'Entrada', location.horaEntrada),
                            _buildInfoRow(Icons.timer_off_outlined, 'Salida', location.horaSalida),


                            if (location.responsibleId != null)
                              _buildInfoRow(Icons.person, 'ID Responsable', location.responsibleId.toString()),

                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_off, color: Colors.grey, size: 40),
                    const SizedBox(height: 10),
                    const Text(
                      'No hay ubicaciones disponibles.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
