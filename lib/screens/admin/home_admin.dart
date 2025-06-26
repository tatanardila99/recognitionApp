import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_recognitionapp/models/user_role.dart';
import 'package:uts_recognitionapp/screens/admin/handle_users/user_managment.dart';

import '../../providers/user_provider.dart';
import '../common/profile_screen.dart';
import 'access/access_list.dart';
import 'handle_locations/all_locations.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreen();
}

class _AdminHomeScreen extends State<AdminHomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null &&
        !Provider.of<UserProvider>(context, listen: false).currentUserLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        List<dynamic>? accessInfoRaw = args['accessInfo'];
        Map<String, dynamic>? userDataRaw = args['userData'];

        if (userDataRaw != null) {
          userProvider.setUser(userDataRaw);
        }
        if (accessInfoRaw != null) {
          userProvider.setAccessInfo(accessInfoRaw);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildInfoBanner(context),
                const SizedBox(height: 30),
                Text(
                  'Feature',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _buildFeatureGrid(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'Administrador',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
            ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                size: 30,
                color: Colors.black54,
              ),
              onPressed: () {
                print('Notificaciones');
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                child: const Text(
                  '0',
                  style: TextStyle(color: Colors.white, fontSize: 8),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset('assets/shield.jpg', height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 1,
      mainAxisSpacing: 10,
      children: [
        _buildFeatureCard(
          context,
          'Usuarios',
          "assets/users-image.png",
          Color(0xFF54787D),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserManagementScreen()),
            );
          },
        ),
        _buildFeatureCard(
          context,
          'Ubicaciones',
          "assets/location-image.png",
          Color(0xFFF39C12),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LocationsScreen()),
            );
          },
        ),
        _buildFeatureCard(
          context,
          'Accesos',
          "assets/responsibles-image.png",
          Color(0xFFFD6084),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminAccessListScreen()),
            );
          },
        ),

      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String imagePath,
    Color bgColor,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: bgColor.withOpacity(0.8),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Image.asset(imagePath, height: 60, width: 60),
            ),
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.apps, color: Colors.blue),
            onPressed: () {},
          ),

          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
