import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_recognitionapp/screens/common/profile_screen.dart';
import 'package:uts_recognitionapp/screens/teacher/bottom_bar_navigation_professor.dart';
import '../../models/location.dart';
import '../../providers/user_provider.dart';
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
  final BackendService _backendService = BackendService();
  List<Location> _locations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

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

      if (userDataRaw != null) {
        userProvider.setUser(userDataRaw);
      }
      if (accessInfoRaw != null) {
        userProvider.setAccessInfo(accessInfoRaw);
      }

      print('Datos guardados en el Provider.');
    }
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
      MaterialPageRoute(
        builder: (context) => FaceCameraScreen(locationId: locationId),
      ),
    );
  }

  void _onLocationCardTapped(Location location) {
    print('Tarjeta clickeada: ${location.name} (ID: ${location.id})');
    _startFaceCamera(context, location.id);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con avatar y saludo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bienvenido",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            "${user?.name ?? 'Profesor'}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Tarjeta de Control de Acceso
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0075FF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Control de Acceso",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Accede con mayor seguridad.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/shield.jpg',
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Título cursos
              const Text(
                "Tus Cursos",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // Lista de cursos (tarjetas verticales)
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _locations.isEmpty
                  ? const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text(
                        'No hay espacios registrados.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                  : ListView.builder(
                    itemCount: _locations.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final location = _locations[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: LocationDisplayCard(
                          locationName: location.name,
                          edificio: location.edificio,
                          salon: location.salon,
                          startTime: location.horaEntrada,
                          endTime: location.horaSalida,
                          locationData: location,
                          onTap: _onLocationCardTapped,
                        ),
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBarNavigationProfessor(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLocationScreen()),
          );
        },
        backgroundColor: const Color(0xFF0075FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
