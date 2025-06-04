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
      /*onFaceDetected: (Face? face) async {

        if (face != null) {

          try {

            await _controller.takePicture();
          } catch (e) {
            print('Error al intentar tomar la foto: $e');
            showToastMessage(
                context: context,
                message: 'Error de cámara al tomar la foto.',
                isError: true);

          }
        }
      },*/
      onCapture: (File? image) async {
        if (image != null && mounted) {
          _sendImageToServer(image);
        } else if (image == null && mounted) {
          print('Error en onCapture: La imagen capturada es null.');
          showToastMessage(
              context: context,
              message: 'No se pudo capturar la imagen. Intenta de nuevo.',
              isError: true);

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

      if (res != null) {
        Map<String, dynamic>? location = await _backendService.getLocationBYId(widget.locationId);
        showSuccessDialog(context: context, userName: res['username'], confidence: res['similarity'], locationName: location?['location_name'], onOkPressed: () => {print("ok")});
      } else {
        showToastMessage(context: context, message: "El usuario no se encuentra registrado", isError: true);
      }
    } catch (e) {
      print('Error al validar el acceso: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });

      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Verificación Facial'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // Widget de la cámara facial
          SmartFaceCamera(
            controller: _controller,
            showControls: true,
            showCameraLensControl: true,
            showCaptureControl: false,

          ),

          if ( _isSending)
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
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

          if (!_isSending)
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Por favor, mira directamente a la cámara',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}