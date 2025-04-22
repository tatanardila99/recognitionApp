import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/screens/face_id_sign.dart';
import 'package:uts_recognitionapp/screens/face_id_sign_up.dart';
import 'screens/face_id_intro_screen.dart';
import 'screens/face_id_scanning_screen.dart';
import 'screens/face_id_success_screen.dart';

void main() {
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
        '/sign': (context) => FaceIdSign(),
        '/sign_up': (context) => FaceIdSignUp(),
        '/scan': (context) => FaceIdScanningScreen(),
        '/success': (context) => FaceIdSuccessScreen(),
      },
    );
  }
}
