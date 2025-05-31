import 'package:flutter/material.dart';
import '../../models/location.dart';
import '../../services/service.dart';
import 'add_location_screen.dart';
import 'face_rekognition_screen.dart';
import 'location_card.dart';


class HomeProfessor extends StatefulWidget {
  const HomeProfessor({super.key});

  @override
  _HomeProfessor createState() => _HomeProfessor();
}

class _HomeProfessor extends State<HomeProfessor> {
  int _selectedIndex = 0;
  final BackendService _backendService = BackendService();
  List<Location> _locations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }


  Future<void> _fetchLocations() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedLocations = await _backendService.getLocations();
      setState(() {
        _locations = fetchedLocations;
      });
    } catch (e) {
      print('Error al cargar ubicaciones: $e');

    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startFaceCamera(BuildContext context, int locationId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FaceCameraScreen(locationId: locationId)),
    );
  }


  void _addLocation(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddLocationScreen()),
    );

    if (result != null) {
      _fetchLocations();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _addLocation(context);
      } else {
        print("Item seleccionado : $index");
      }
    });
  }

  void _onLocationCardTapped(Location location) {
    print('Tarjeta clickeada: ${location.name} (ID: ${location.id})');
    print('Iniciando cámara facial para ${location.name}...');


    _startFaceCamera(context, location.id);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),

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
                    'assets/shield.jpg',
                    height: 100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'Lista de Cursos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _locations.isEmpty
                ? const Center(
              child: Text(
                'No hay espacios registrados.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3.0,
                ),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  final location = _locations[index];

                  return LocationDisplayCard(
                    locationName: location.name,
                    edificio: location.edificio,
                    salon: location.salon,
                    startTime: location.horaEntrada,
                    endTime: location.horaSalida,
                    locationData: location,
                    onTap: _onLocationCardTapped,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined, color: Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Colors.grey),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}


