import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_data.dart';
import '../../models/user_role.dart';
import '../../providers/user_provider.dart';
import 'about_us_screen.dart';
import 'change_password_screen.dart';
import 'contact_us_screen.dart';
import 'update_user_screen.dart';

class ProfileScreen extends StatefulWidget {

  final UserRole userRole;
  final Widget? customBottomNavigationBar;

  const ProfileScreen({
    super.key,
    required this.userRole,
    this.customBottomNavigationBar,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final UserData? currentUser = userProvider.currentUser;

    String profileImagePath =
        currentUser?.profileImageUrl ?? 'assets/profile_default.jpg';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(profileImagePath),
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: Text(
                currentUser!.name as String,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 50),

            ProfileOption(title: 'Mi perfil', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateUserScreen())
              );
            }),
            const SizedBox(height: 16),
            ProfileOption(title: 'Cambiar clave', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
              );
            }),

            const SizedBox(height: 16),
            ProfileOption(title: 'Notificacion', onTap: () {

            }),
            const SizedBox(height: 16),
            ProfileOption(title: 'Acerda de', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            }),
            const SizedBox(height: 16),
            ProfileOption(title: 'Contactenos', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUsScreen()),
              );
            }),
            const SizedBox(height: 60),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  userProvider.clearUser();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (Route<dynamic> route) =>
                        false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Cerrar Sesion',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.customBottomNavigationBar,
    );
  }
}

class ProfileOption extends StatelessWidget {
  const ProfileOption({super.key, required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: const TextStyle(fontSize: 16)),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
