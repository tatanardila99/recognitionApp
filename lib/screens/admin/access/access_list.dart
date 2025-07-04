import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/services/service.dart';
import 'package:intl/intl.dart';

import '../../../models/admin_access_entry.dart';

class AdminAccessListScreen extends StatefulWidget {
  const AdminAccessListScreen({super.key});

  @override
  State<AdminAccessListScreen> createState() => _AdminAccessListScreenState();
}

class _AdminAccessListScreenState extends State<AdminAccessListScreen> {
  late Future<List<AdminAccessEntry>> _accessListFuture;
  final BackendService _backendService = BackendService();

  @override
  void initState() {
    super.initState();
    _refreshAccessList();
  }

  Future<void> _refreshAccessList() async {
    setState(() {
      _accessListFuture = _backendService.getAllAccess(context);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Accesos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF899DD9),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAccessList,
        color: Colors.blueGrey[800],
        child: FutureBuilder<List<AdminAccessEntry>>(
          future: _accessListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.blueGrey));
            } else if (snapshot.hasError) {
              print('Error loading access data: ${snapshot.error}');
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 50, color: Colors.red[400]),
                      const SizedBox(height: 10),
                      Text(
                        'Error al cargar los accesos: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red[400], fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _refreshAccessList,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 15),
                      Text(
                        'No se encontraron registros de accesos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              final accessEntries = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: accessEntries.length,
                itemBuilder: (context, index) {
                  final entry = accessEntries[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Acceso ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blueGrey[700],
                                ),
                              ),

                              _buildResultBadge(entry.result),
                            ],
                          ),
                          const Divider(height: 20, thickness: 1, color: Colors.blueGrey),
                          _buildInfoRow(Icons.person_outline, 'Usuario:', entry.userName, color: Colors.black87),
                          _buildInfoRow(Icons.location_on_outlined, 'Ubicación:', entry.locationName, color: Colors.black87),
                          _buildInfoRow(Icons.calendar_today_outlined, 'Fecha/Hora:', _formatDate(entry.dateEntry), color: Colors.black87),
                          if (entry.confidence != null)
                            _buildInfoRow(Icons.percent, 'Confianza:', '${entry.confidence!.toStringAsFixed(2)}%', color: Colors.black87),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }


  Widget _buildInfoRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey[600]),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                  TextSpan(
                    text: ' $value',
                    style: TextStyle(
                      fontSize: 15,
                      color: color ?? Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildResultBadge(String result) {
    Color textColor = Colors.white;
    Color badgeColor = Colors.grey;
    String displayText = result;

    switch (result) {
      case 'Authorized':
        badgeColor = Colors.green[600]!;
        displayText = 'Autorizado';
        break;
      case 'Unauthorized':
        badgeColor = Colors.red[600]!;
        displayText = 'Denegado';
        break;
      default:
        badgeColor = Colors.grey[600]!;
        displayText = result;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}