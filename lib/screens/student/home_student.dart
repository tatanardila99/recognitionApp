import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/models/user_access_entry.dart';
import 'package:uts_recognitionapp/screens/student/bottom_bar_navigation_student.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uts_recognitionapp/providers/user_provider.dart';
import 'package:uts_recognitionapp/models/user_data.dart';
import 'package:uts_recognitionapp/models/admin_access_entry.dart';
import 'package:uts_recognitionapp/services/service.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final BackendService _backendService = BackendService();
  Future<List<UserAccessEntry>>? _accessHistoryFuture;

  @override
  void initState() {
    super.initState();
    _fetchAccessHistory();
  }

  Future<void> _fetchAccessHistory() async {
    setState(() {
      _accessHistoryFuture = _backendService.getAccessById(context);
    });
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      print('Error al formatear fecha "$dateString": $e');
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final UserData? currentUser = userProvider.currentUser;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16.0,
              bottom: 16.0,
            ),
            decoration: const BoxDecoration(color: Color(0xFF899DD9)),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: const Center(
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  currentUser?.name ?? "Usuario",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Historial de Accesos:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blueAccent,
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<UserAccessEntry>>(
              future: _accessHistoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('ERROR FutureBuilder: ${snapshot.error}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Error al cargar el historial: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        ElevatedButton(
                          onPressed: _fetchAccessHistory,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay registros de acceso disponibles.'),
                  );
                } else {
                  final List<UserAccessEntry> accessHistory = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Ubicación')),
                          DataColumn(label: Text('Fecha y Hora')),
                          DataColumn(label: Text('Resultado')),
                          DataColumn(label: Text('Confianza')),
                        ],
                        rows:
                            accessHistory.map<DataRow>((access) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(access.locationName ?? 'N/A')),
                                  DataCell(Text(_formatDate(access.dateEntry))),
                                  DataCell(Text(access.result ?? 'N/A')),
                                  DataCell(
                                    Text(
                                      '${access.confidence?.toStringAsFixed(2) ?? 'N/A'}%',
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBarNavigationStudent(),
    );
  }
}
