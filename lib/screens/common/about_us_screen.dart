
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de Nosotros'),
        backgroundColor: const Color(0xFF899DD9),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo_uts.png',
              height: 120,
              width: 400,
            ),
            const SizedBox(height: 20),

            const Text(
              'UTS Recognition App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF899DD9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Versión 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),


            const Text(
              'Nuestra misión es revolucionar la forma en que las instituciones educativas gestionan el acceso y la asistencia, utilizando tecnología de reconocimiento facial de vanguardia. Ofrecemos una solución segura, eficiente y fácil de usar para estudiantes y profesores, garantizando un entorno académico organizado y protegido.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),

            const Text(
              'Quiénes Somos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF899DD9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Somos un equipo de desarrolladores apasionados por la innovación y la seguridad. Creemos firmemente en el poder de la tecnología para transformar la educación y crear experiencias más fluidas para la comunidad universitaria. Desarrollamos esta aplicación como parte de nuestro proyecto final en las Unidades Tecnológicas de Santander (UTS).',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),

            const Divider(),
            const SizedBox(height: 20),
            const Text(
              '© 2025 UTS Recognition App. Todos los derechos reservados.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
              },
              child: const Text(
                'Política de Privacidad',
                style: TextStyle(fontSize: 12, color: Color(0xFF899DD9), decoration: TextDecoration.underline),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}