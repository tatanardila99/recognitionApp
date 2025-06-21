import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/screens/admin/home_admin.dart';
import 'package:uts_recognitionapp/screens/face_id_sign_in.dart';
import 'package:uts_recognitionapp/screens/face_id_sign_up.dart';
import 'package:uts_recognitionapp/screens/student/home_student.dart';
import 'package:uts_recognitionapp/screens/teacher/home_professor.dart';
import 'screens/face_id_intro_screen.dart';
import 'screens/face_id_scanning_screen.dart';
import 'screens/face_id_success_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:uts_recognitionapp/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FaceCamera.initialize();
  await initializeDateFormatting('es_ES', null);

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const FaceIdIntroScreen(),
        '/sign': (context) => const LoginPage(),
        '/sign_up': (context) => const FaceIdSignUp(),
        //'/scan': (context) => const FaceIdScanningScreen(),
        '/success': (context) => const FaceIdSuccessScreen(),
        '/student/home': (context) => const StudentHomeScreen(),
        '/professor/home': (context) => const HomeProfessor(),
        '/admin/home': (context) => const AdminHomeScreen(),
      },
    );
  }
}
