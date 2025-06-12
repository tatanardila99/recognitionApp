import 'dart:io';
import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:uts_recognitionapp/services/service.dart';

class FaceIdSignUp extends StatelessWidget {
  const FaceIdSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: MyForm());
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
      onCapture: (File? image) {
        setState(() {
          _capturedFace = image;
          _isCameraActive = false;
          _cameraMessage = 'Rostro capturado!';
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              _cameraMessage = 'Tomar foto';
            });
          });
        });
      },
      onFaceDetected: (Face? face) {},
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
    });
    if (_cameraController != null) {
      _cameraController!.startImageStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          width: 150,
          height: 150,
          child: Image.asset('assets/shape.png', fit: BoxFit.contain),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 70),
                Text(
                  "Bienvenido a bordo!",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "Te ayudamos a gestionar un acceso seguro",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xFFF6F6F6),
                    labelText: 'Ingrese su nombre',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xFFF6F6F6),
                    labelText: 'Ingrese su correo institucional',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xFFF6F6F6),
                    labelText: 'Rol',
                  ),
                  value: _selectedRol,
                  items:
                      _roles.map((String rol) {
                        return DropdownMenuItem<String>(
                          value: rol,
                          child: Text(rol),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRol = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona un rol';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xFFF6F6F6),
                    labelText: 'Ingrese una contraseña',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: _startCamera,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/camera.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _cameraMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                if (_capturedFace != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Image.file(
                      _capturedFace!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF899DD9),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _capturedFace != null) {
                      final String name = _nameController.text;
                      final String email = _emailController.text;
                      final String password = _passwordController.text;

                      bool success = await _backendService.sendDataRegister(
                        name,
                        email,
                        password,
                        "6434222225", // de momento esta quemado
                        _selectedRol!,
                        _capturedFace,
                      );

                      if (success) {
                        print('Registro exitoso!');
                      } else {
                        print('Error al registrar');
                      }
                    }
                  },
                  child: const Text(
                    'Registrate',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿Ya tiene una cuenta?  '),
                    InkWell(
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(color: Color(0xFF50C2C9)),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/sign');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_isCameraActive && _cameraController != null)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: SmartFaceCamera(
              controller: _cameraController!,
              message: "Centra tu rostro en el recuadro",
            ),
          ),
      ],
    );
  }
}
