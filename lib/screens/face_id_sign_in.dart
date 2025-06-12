import 'package:flutter/material.dart';

import '../services/service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final BackendService _backendService = BackendService();
  bool _isLoading = false;

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : Colors.green)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: 200,
            height: 200,
            child: Image.asset(
              'assets/shape.png',
              fit: BoxFit.contain,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 180),
                  const Text(
                    'Inicio de Sesion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/image_login.png',
                          height: 100,
                        ),
                        Positioned(
                          right: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 70,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 60,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Ingrese el correo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Ingrese la clave',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {

                      },
                      child: const Text(
                        'Olvido la clave',
                        style: TextStyle(color: Color(0xFF50C2C9)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        :  () async {
                      setState(() {
                        _isLoading = true;
                      });
                      String email = _emailController.text;
                      String password = _passwordController.text;

                      final loginResult = await _backendService.sendDataLogin(email, password);

                      setState(() {
                        _isLoading = false;
                      });

                      if (loginResult != null && loginResult['success'] == true) {
                        _showMessage("Inicio de sesión exitoso");

                        final List<dynamic>? accessInfo = loginResult['access_info'];

                        final Map<String, dynamic>? userData = loginResult['user_data'];

                        if (loginResult['message'] == 1) {
                          Navigator.pushReplacementNamed(
                            context,
                            '/student/home',
                            arguments: {
                              'accessInfo': accessInfo,
                              'userData': userData,
                            },
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, '/professor/home', arguments: {'userData': userData});
                        }
                      } else {
                        _showMessage("Error al iniciar sesion, verifica tus credenciales.", isError: true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF899DD9),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Ingresar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "No tiene cuenta? ",
                        style: TextStyle(color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign_up');
                        },
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(
                            color: Color(0xFF50C2C9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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