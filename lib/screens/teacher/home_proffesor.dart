import 'package:flutter/material.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30), // Espacio superior

            // Fila de Saludo y Notificación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Hola, Profesor!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.black),
                  onPressed: () {

                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Contenedor de la Tarjeta de Acceso
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF86D3FF),
                    Color(0xFF0075FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Control de Acceso',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Accede con mayor seguridad.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/security_image.jpg',
                    height: 100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Texto de la Lista de Cursos
            const Text(
              'Lista de Cursos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                _buildCourseContainer(
                  context,
                  'Programación',
                  const Color(0xFFE0E0E0),
                  'assets/programing_imgage.png',
                ),
                _buildCourseContainer(
                  context,
                  'Bases de Datos',
                  const Color(0xFFE0E0E0),
                  'assets/image_database.png',
                ),
                _buildCourseContainer(
                  context,
                  'Servidores',
                  const Color(0xFFE0E0E0),
                  'assets/server_image.png',
                ),
                _buildCourseContainer(
                  context,
                  'Inglés',
                  const Color(0xFFE0E0E0),
                  'assets/book_image.png', // Reemplazar
                ),
              ],
            ),
          ],
        ),
      ),
      // Barra de Navegación Inferior
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined, color: Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_export_outlined, color: Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Colors.grey),
            label: '',
          ),
        ],
        currentIndex: 0, // El índice del elemento seleccionado
        onTap: (int index) {
          // TODO: Lógica para cambiar de página
        },
      ),
    );
  }

  // Método para construir los Contenedores de los Cursos
  Widget _buildCourseContainer(
      BuildContext context,
      String courseName,
      Color containerColor,
      String imagePath,
      ) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            height: 50,
          ),
          const SizedBox(height: 8),
          Text(
            courseName,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

