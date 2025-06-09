// student_home_screen.dart
import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/screens/student/bottom_bar_navigation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uts_recognitionapp/providers/user_provider.dart';
import 'package:uts_recognitionapp/models/user_data.dart';
import 'package:uts_recognitionapp/models/access_info.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && !Provider.of<UserProvider>(context, listen: false).currentUserLoaded) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      List<dynamic>? accessInfoRaw = args['accessInfo'];
      Map<String, dynamic>? userDataRaw = args['userData'];

      if (userDataRaw != null) {
        userProvider.setUser(userDataRaw);
      }
      if (accessInfoRaw != null) {
        userProvider.setAccessInfo(accessInfoRaw);
      }
      print('Datos guardados en el Provider.');
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
    final userProvider = Provider.of<UserProvider>(context);
    final UserData? currentUser = userProvider.currentUser;
    final List<AccessEntry>? currentAccessInfo = userProvider.currentAccessInfo;


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
            child: currentAccessInfo == null || currentAccessInfo.isEmpty
                ? const Center(child: Text('No hay registros de acceso disponibles.'))
                : SingleChildScrollView(
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
                  rows: currentAccessInfo.map<DataRow>((access) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(access.locationName ?? '')),
                        DataCell(Text(_formatDate(access.dateEntry ?? ''))),
                        DataCell(Text(access.result ?? '')),
                        DataCell(Text('${access.confidence?.toStringAsFixed(2) ?? 'N/A'}%')),
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