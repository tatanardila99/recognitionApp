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
      return DateFormat('HH:mm EEEE, dd MMMM yyyy', 'es_ES').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final UserData? currentUser = userProvider.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16.0,
              bottom: 16.0,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF899DD9),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: const AssetImage('assets/profile_default.jpg'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bienvenido, ${currentUser?.name ?? 'User'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'HIstorial de Accesos:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
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
                  return const Center(child: Text('Error al cargar historial'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay registros.'));
                }

                final List<UserAccessEntry> accessHistory = snapshot.data!;
                final List<Color> cardColors = [
                  Colors.blueGrey.shade900,
                  Colors.lightBlue.shade300,
                  Colors.pinkAccent.shade200,
                  Colors.cyan.shade400,
                ];

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: accessHistory.length,
                  itemBuilder: (context, index) {
                    final access = accessHistory[index];
                    final color = cardColors[index % cardColors.length];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(2, 4),
                          )
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8,
                            height: 100,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    access.locationName ?? 'Ubicación Desconocida',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF0B2849),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Ubicacion Registrada',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _formatDate(access.dateEntry),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBarNavigationStudent(),
    );
  }
}
