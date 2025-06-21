import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
//import 'package:google_ml_kit/google_ml_kit.dart';
import '../theme/theme.dart';

class FaceIdScanningScreen extends StatefulWidget {
  const FaceIdScanningScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FaceIdScanningScreenState createState() => _FaceIdScanningScreenState();
}

class _FaceIdScanningScreenState extends State {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  double _detectionProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(enableContours: true, enableClassification: true),
    );
  }

  Future _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(camera, ResolutionPreset.medium);
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});

    _startFaceDetection();
  }

  void _startFaceDetection() {
    _cameraController!.startImageStream((CameraImage image) async {
      if (_isDetecting) return;
      _isDetecting = true;

      try {
        final InputImageRotation imageRotation =
            InputImageRotation.rotation0deg;
        final InputImageFormat inputImageFormat = InputImageFormat.nv21;

        final inputImage = InputImage.fromBytes(
          bytes: image.planes[0].bytes,
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation: imageRotation,
            format: inputImageFormat,
            bytesPerRow: image.planes[0].bytesPerRow,
          ),
        );

        final faces = await _faceDetector.processImage(inputImage);
        setState(() {
          _detectionProgress = faces.isNotEmpty ? 1.0 : 0.0;
        });
      } catch (e) {
        print("Error detectando rostro: $e");
      }

      _isDetecting = false;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _cameraController != null && _cameraController!.value.isInitialized
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CameraPreview(_cameraController!),
                )
                : const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              "${(_detectionProgress * 100).toInt()}%",
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: AppColors.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LinearProgressIndicator(
                value: _detectionProgress,
                backgroundColor: Colors.white24,
                color: AppColors.primary,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _detectionProgress > 0 ? "Rostro detectado" : "Escaneando...",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
