import 'dart:io';
import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:uts_recognitionapp/screens/face_id_sign_in.dart';
import 'package:uts_recognitionapp/screens/reviewPhotoPage.dart';
import 'package:uts_recognitionapp/services/service.dart';
import 'package:path/path.dart' as path;

class FaceIdSignUp extends StatelessWidget {
  const FaceIdSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white, body: MyForm());
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _documentController = TextEditingController();
  final BackendService _backendService = BackendService();

  String? _selectedRol;
  final List<String> _roles = ['estudiante', 'profesor'];

  File? _capturedFace;
  FaceCameraController? _cameraController;
  bool _isCameraActive = false;
  String _cameraMessage = 'Tomar foto';

  @override
  void initState() {
    super.initState();
    _cameraController = FaceCameraController(
      autoCapture: true,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) async {
        if (image != null) {
          _cameraController?.stopImageStream();

          final confirm = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => ReviewPhotoPage(image: image)),
          );

          if (confirm == true) {
            setState(() {
              _capturedFace = image;
              _isCameraActive = false;
              _cameraMessage = 'Rostro capturado: ${path.basename(_capturedFace!.path)}';
            });
          } else {
            setState(() {
              _capturedFace = null;
              _isCameraActive = false;
              _cameraMessage = 'Toca para tomar una foto';
            });
          }
        } else {
          setState(() {
            _isCameraActive = false;
            _cameraMessage = 'Error al capturar rostro. Toca para reintentar.';
          });
        }
      },
      onFaceDetected: (Face? face) {
        if (_isCameraActive) {
          setState(() {
            _cameraMessage = face == null ? 'Centra tu rostro en el recuadro' : 'Rostro detectado!';
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _startCamera() {
    setState(() {
      _isCameraActive = true;
      _capturedFace = null;
    });
    if (_cameraController != null) {
      _cameraController!.startImageStream();
      _showCameraDialog();
    }
  }

  void _showCameraDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: SmartFaceCamera(
                      controller: _cameraController!,
                      message: "Centra tu rostro en el recuadro",
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.redAccent),
                    onPressed: () {
                      _cameraController?.stopImageStream();
                      Navigator.of(ctx).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: 0,
            width: 200,
            height: 200,
            child: Image.asset('assets/shape.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 48),
                  const Text(
                    "Bienvenido a bordo!",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Te ayudamos a gestionar un acceso seguro",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      labelText: 'Ingrese su nombre',
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Por favor ingresa tu nombre' : null,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      labelText: 'Ingrese su correo institucional',
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Por favor ingresa tu email' : null,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _documentController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      labelText: 'Ingrese su numero de documento',
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Por favor ingresa tu documento de identidad' : null,
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Rol',
                      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color.fromARGB(255, 98, 94, 104)),
                    borderRadius: BorderRadius.circular(20),
                    value: _selectedRol,
                    items: _roles.map((String rol) {
                      return DropdownMenuItem<String>(
                        value: rol,
                        child: Text(
                          rol[0].toUpperCase() + rol.substring(1),
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) => setState(() => _selectedRol = newValue),
                    validator: (value) => value == null || value.isEmpty ? 'Por favor selecciona un rol' : null,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      labelText: 'Ingrese una contraseña',
                    ),
                    obscureText: true,
                    validator: (value) => value == null || value.isEmpty ? 'Por favor ingresa tu contraseña' : null,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _startCamera,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: AssetImage('assets/camera.png'),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _cameraMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF899DD9),
                          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 100.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate() && _capturedFace != null) {
                            final String name = _nameController.text;
                            final String email = _emailController.text;
                            final String password = _passwordController.text;
                            final String document = _documentController.text;

                            bool success = await _backendService.sendDataRegister(
                              name, email, password, document, _selectedRol!, _capturedFace,
                            );

                            if (success) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                            } else {
                              // mostrar error si es necesario
                            }
                          }
                        },
                        child: const Text(
                          'Registrate',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿Ya tiene una cuenta?  '),
                      InkWell(
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(color: Color(0xFF50C2C9), fontWeight: FontWeight.bold),
                        ),
                        onTap: () => Navigator.pushNamed(context, '/sign'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
