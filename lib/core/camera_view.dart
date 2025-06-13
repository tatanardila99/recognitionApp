
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraView extends StatefulWidget {
  final Function(String?) onPictureTaken;

  const CameraView({Key? key, required this.onPictureTaken}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(_cameras.first, ResolutionPreset.medium);
      try {
        await _cameraController!.initialize();
        if (!mounted) {
          return;
        }
        setState(() {});
      } catch (e) {
        print('Error initializing camera: $e');
      }
    } else {
      print('No cameras available.');
    }
  }

  Future<void> takePicture() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile file = await _cameraController!.takePicture();
        print('Foto tomada en: ${file.path}');
        widget.onPictureTaken(file.path);
      } catch (e) {
        print('Error al tomar la foto: $e');
        widget.onPictureTaken(null);
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: kIsWeb ? const Text('Camera not supported on Web') : CameraPreview(_cameraController!),
    );
  }
}