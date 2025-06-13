import 'dart:io';
import 'package:flutter/material.dart';

class ReviewPhotoPage extends StatelessWidget {
  final File image;
  const ReviewPhotoPage({required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(
      0xFFB8C2F8,
    ); // Azul lavanda como el del botón
    final black = Colors.black87;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Confirmar Captura',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              '¿Deseas usar esta foto?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                image,
                width: double.infinity,
                height: 320,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.refresh, color: Colors.black),
                  label: const Text(
                    "Repetir",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
