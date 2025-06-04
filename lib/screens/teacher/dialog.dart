// lib/utils/dialog_utils.dart

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';


void showSuccessDialog({
  required BuildContext context,
  required String userName,
  required double confidence,
  required String locationName,
  required VoidCallback onOkPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Image.asset(
                'assets/success_icon.png',
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Verificación exitosa',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Usuario: $userName',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              Text(
                'Similitud: ${confidence.toStringAsFixed(1)}%',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              Text(
                'Ubicación: $locationName',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Color del botón de éxito
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Cierra el diálogo
                  onOkPressed(); // Ejecuta el callback que se pasa
                },
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


void showToastMessage({
  required BuildContext context,
  required String message,
  bool isError = true,
}) {
  showToast(
    message,
    context: context,
    animation: StyledToastAnimation.slideFromTop,
    reverseAnimation: StyledToastAnimation.slideToTop,
    position: StyledToastPosition.top,
    duration: const Duration(seconds: 4),
    animDuration: const Duration(milliseconds: 300),
    backgroundColor: isError ? Colors.redAccent : Colors.blueAccent,
    textStyle: const TextStyle(color: Colors.white),
  );
}