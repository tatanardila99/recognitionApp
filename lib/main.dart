import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/screens/face_id_sign_in.dart';
import 'package:uts_recognitionapp/screens/face_id_sign_up.dart';
import 'package:uts_recognitionapp/screens/student/dashboard.dart';
import 'package:uts_recognitionapp/screens/student/profile.dart';
import 'package:uts_recognitionapp/screens/teacher/home_proffesor.dart';
import 'screens/face_id_intro_screen.dart';
import 'screens/face_id_scanning_screen.dart';
import 'screens/face_id_success_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FaceCamera.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => FaceIdIntroScreen(),
        '/sign': (context) => LoginPage(),
        '/sign_up': (context) => FaceIdSignUp(),
        '/scan': (context) => FaceIdScanningScreen(),
        '/success': (context) => FaceIdSuccessScreen(),
        '/student/dashboard': (context) => Dashboard(),
        '/student/profile': (context) => ProfileScreen(),
        '/proffesor/home': (context) => HomeScreen(),
      },
    );
  }
}
