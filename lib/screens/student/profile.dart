import 'package:flutter/material.dart';

import 'bottom_bar_navigation.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();

}

class _ProfileScreen extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50,),
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
              ),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text(
                'User',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),

            ProfileOption(
                title: 'My Profile',
                onTap: () {}),
            const SizedBox(height: 16),
            ProfileOption(
                title: 'Change Password',
                onTap: () {}),

            const SizedBox(height: 16),
            ProfileOption(
                title: 'Notification',
                onTap: () {}),
            const SizedBox(height: 16),
            ProfileOption(title: 'About Us', onTap: () {}),
            const SizedBox(height: 16),
            ProfileOption(title: 'Contact Us', onTap: () {}),
            const SizedBox(height: 60),

            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
       bottomNavigationBar:  BottomBarNavigation(),
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
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.grey)
        ],
      ),
    );
  }
}
