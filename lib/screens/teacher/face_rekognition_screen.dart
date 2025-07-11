import 'dart:io';
import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:uts_recognitionapp/services/service.dart';
import 'dialog.dart';

class FaceCameraScreen extends StatefulWidget {
  final int locationId;

  const FaceCameraScreen({super.key, required this.locationId});

  @override
  _FaceCameraScreenState createState() => _FaceCameraScreenState();
}

class _FaceCameraScreenState extends State<FaceCameraScreen> {
  bool _isSending = false;
  final BackendService _backendService = BackendService();
  late FaceCameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FaceCameraController(
      autoCapture: true,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) async {
        if (image != null && mounted) {
          _sendImageToServer(image);
        } else if (image == null && mounted) {
          showToastMessage(
            context: context,
            message: 'No se pudo capturar la imagen. Intenta de nuevo.',
            isError: true,
          );
        }
      },
    );
  }

  Future<void> _sendImageToServer(File image) async {
    if (!mounted || _isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      Map<String, dynamic>? res = await _backendService.validateAccess(
        image,
        widget.locationId.toString(),
      );

      if (res?['access'] == 'granted') {
        Map<String, dynamic>? location = await _backendService.getLocationBYId(
          context,
          widget.locationId,
        );
        showSuccessDialog(
          context: context,
          userName: res?['username'],
          confidence: res?['similarity'],
          locationName: location?['location_name'],
          onOkPressed: () => Navigator.pop(context),
        );
      } else {
        showToastMessage(
          context: context,
          message: res?['message'],
          isError: true,
        );
      }
    } catch (e) {
      showToastMessage(
        context: context,
        message: "Error inesperado",
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Control Live\nFace Detection',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      SmartFaceCamera(
                        controller: _controller,
                        showControls: true,
                        showCameraLensControl: false,
                        showCaptureControl: false,
                      ),
                      if (_isSending)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                SizedBox(height: 10),
                                Text(
                                  'Procesando verificación...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                onPressed: _isSending ? null : _controller.captureImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF899DD9),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Start Test',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

