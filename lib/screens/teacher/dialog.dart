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
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/success_icon.png', // Asegúrate de que el ícono exista
                  width: 64,
                  height: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Success',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    children: [
                      const TextSpan(
                        text: 'User: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: userName),
                      const TextSpan(text: '\n'),
                      const TextSpan(
                        text: 'Confidence: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '${confidence.toStringAsFixed(1)}%'),
                      const TextSpan(text: '\n'),
                      const TextSpan(
                        text: 'Location: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: locationName),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    onOkPressed();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8EE28A),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );


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

  
}
