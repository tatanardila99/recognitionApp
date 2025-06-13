import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/screens/student/bottom_bar_navigation_student.dart';
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

    if (args != null &&
        !Provider.of<UserProvider>(context, listen: false).currentUserLoaded) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      List<dynamic>? accessInfoRaw = args['accessInfo'];
      Map<String, dynamic>? userDataRaw = args['userData'];

      if (userDataRaw != null) userProvider.setUser(userDataRaw);
      if (accessInfoRaw != null) userProvider.setAccessInfo(accessInfoRaw);
    }
  }

  String _formatTime(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('HH:mm EEEE, d MMMM yyyy', 'es_ES').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  final List<Color> cardColors = [
    Colors.blue.shade900,
    Colors.lightBlue.shade400,
    Colors.pinkAccent.shade100,
    Colors.cyan.shade400,
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final UserData? currentUser = userProvider.currentUser;
    final List<AccessEntry>? currentAccessInfo = userProvider.currentAccessInfo;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 220,
            decoration: const BoxDecoration(
              color: Color(0xFF899DD9),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 20,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Color(0xFF899DD9)),
                ),
                const SizedBox(height: 10),
                Text(
                  "Bienvenido, ${currentUser?.name ?? 'Estudiante'}",
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Historial de ingresos",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child:
                currentAccessInfo == null || currentAccessInfo.isEmpty
                    ? const Center(child: Text("No access records available."))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: currentAccessInfo.length,
                      itemBuilder: (context, index) {
                        final access = currentAccessInfo[index];
                        final cardColor = cardColors[index % cardColors.length];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
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
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 8,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            title: Text(
                              access.locationName ?? 'No data',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                const Text("ClassRoom Register"),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTime(access.dateEntry ?? ''),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
