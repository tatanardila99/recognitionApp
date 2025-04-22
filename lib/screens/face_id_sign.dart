import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class FaceIdSign extends StatefulWidget {
  @override
  _FaceIdSignState createState() => _FaceIdSignState();
}

class _FaceIdSignState extends State<FaceIdSign> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    _initializeCameraAndTakePicture();
  }

  Future<void> _initializeCameraAndTakePicture() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(_cameras.first, ResolutionPreset.medium);
      try {
        await _cameraController!.initialize();
        if (!mounted) {
          return;
        }
        setState(() {}); // Actualiza la UI para mostrar la cámara

        // Espera un breve momento para que la cámara se inicie
        await Future.delayed(const Duration(seconds: 1));

        // Toma la foto automáticamente
        await _takePicture();
      } catch (e) {
        print('Error initializing camera: $e');
      }
    } else {
      print('No cameras available.');
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile file = await _cameraController!.takePicture();
        print('Foto tomada automáticamente en: ${file.path}');
        // Aquí puedes hacer algo con la ruta de la imagen (file.path)
        // Por ejemplo, mostrarla o guardarla.
      } catch (e) {
        print('Error al tomar la foto: $e');
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Live Face Detection",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 50),
              Container(
                width: 340,
                height: 400,
                decoration: BoxDecoration(
                  color: Color(0xFFD6DBDF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    _cameraController == null || !_cameraController!.value.isInitialized
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: kIsWeb
                          ? const Center(child: Text('Camera not supported on Web'))
                          : CameraPreview(_cameraController!),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF899DD9),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Puedes agregar alguna acción al presionar el botón si es necesario
                  print('Botón Ingresar presionado');
                },
                child: Text('Ingresar', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No tienes cuenta?   '),
                  InkWell(
                    child: Text(
                      'Registrarse',
                      style: TextStyle(color: Colors.deepPurpleAccent[400]),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/sign_up');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}