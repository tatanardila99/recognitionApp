import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_recognitionapp/providers/user_provider.dart';
import 'package:uts_recognitionapp/services/auth_service.dart';

import '../services/service.dart'; // Asegúrate de que este import sea correcto

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: 0,
              width: 210,
              height: 210,
              child: Image.asset('assets/shape.png', fit: BoxFit.contain),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 100),
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
                          Image.asset('assets/image_login.png', height: 500),
                          Positioned(
                            right: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 20,
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
                    const SizedBox(height: 50),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Ingrese el correo',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 20.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 20.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                    const SizedBox(height: 5.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          // Lógica para "Olvido la clave"
                        },
                        child: const Text(
                          'Olvido la clave',
                          style: TextStyle(
                            color: Color.fromARGB(255, 125, 135, 135),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60.0),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            String email = _emailController.text;
                            String password = _passwordController.text;

                            try {
                              final Map<String, dynamic> result =
                              await AuthService().login(
                                context,
                                email,
                                password,
                              );

                              if (result['success'] == true) {
                                _showMessage(result['message']);

                                if (!mounted) return;
                                final userProvider =
                                Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                );
                                final String? userRole =
                                    userProvider.currentUser?.rol;
                                print('rol ==> $userRole');
                                switch (userRole) {
                                  case 'estudiante':
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/student/home',
                                    );
                                    break;
                                  case 'profesor':
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/professor/home',
                                    );
                                    break;
                                  case 'admin':
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/admin/home',
                                    );
                                    break;
                                  default:
                                    _showMessage(
                                      'Rol de usuario desconocido o no asignado.',
                                      isError: true,
                                    );
                                    break;
                                }
                              } else {
                                _showMessage(
                                  result['message'],
                                  isError: true,
                                );
                              }
                            } catch (e) {
                              _showMessage(
                                "Error de conexión o servidor: $e",
                                isError: true,
                              );
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF899DD9),
                            padding: const EdgeInsets.symmetric(
                              vertical: 11.0,
                              horizontal: 80.0,
                            ),
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
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "¿No tienes cuenta?",
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/sign_up');
                          },
                          child: const Text(
                            'Registrate',
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
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
