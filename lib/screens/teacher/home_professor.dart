import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_recognitionapp/screens/teacher/bottom_bar_navigation_professor.dart';
import '../../models/location.dart';
import '../../providers/user_provider.dart';
import '../../services/service.dart';
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
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId =
        Provider.of<UserProvider>(context, listen: false).currentUser?.id;
    if (_currentUserId != null) {
      _fetchLocations();
    } else {
      print("no esta llegando el id");
    }
  }
  /*
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
  }*/

  Future<void> _fetchLocations() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedLocations = await _backendService.getLocationsByResponsible(
        context,
      );
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
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Color(0xFF86D3FF), Color(0xFF0075FF)],
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
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  Image.asset('assets/shield.jpg', height: 100),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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

      bottomNavigationBar: const BottomBarNavigationProfessor(),
    );
  }
}
