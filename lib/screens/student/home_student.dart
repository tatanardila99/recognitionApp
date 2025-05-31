import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/screens/student/bottom_bar_navigation.dart';
import 'package:intl/intl.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  List<dynamic>? _accessInfo;
  Map<String, dynamic>? _userData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {

      setState(() {
        _accessInfo = args['accessInfo'];
        _userData = args['userData'];
      });
      print('Accesos recibidos: $_accessInfo');
      print('Datos de usuario recibidos: $_userData');
    }
  }


  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);

      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      print('Error al formatear fecha: $e');
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  _userData?['name'] ?? "Usuario", // Muestra el nombre del usuario
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
            child: _accessInfo == null || _accessInfo!.isEmpty
                ? const Center(child: Text('No hay registros de acceso disponibles.'))
                : SingleChildScrollView( // Permite hacer scroll si hay muchas filas
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView( // Permite hacer scroll horizontal si la tabla es ancha
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Ubicación')),
                    DataColumn(label: Text('Fecha y Hora')),
                    DataColumn(label: Text('Resultado')),
                    DataColumn(label: Text('Confianza')),
                  ],
                  rows: _accessInfo!.map<DataRow>((access) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(access['location_name'] ?? '')),
                        DataCell(Text(_formatDate(access['date_entry'] ?? ''))),
                        DataCell(Text(access['result'] ?? '')),
                        DataCell(Text('${double.tryParse(access['confidence'].toString())?.toStringAsFixed(2) ?? 'N/A'}%')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBarNavigation(),
    );
  }
}