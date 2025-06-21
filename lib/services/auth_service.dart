import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart'; // Import Provider
import 'package:flutter/material.dart'; // For BuildContext

import 'package:uts_recognitionapp/providers/user_provider.dart';

class AuthService {
  final String _authBaseUrl =
      'http://192.168.1.6:3000/api'; // Your API base URL

  String? _authToken;

  AuthService._privateConstructor();
  static final AuthService _instance = AuthService._privateConstructor();

  factory AuthService() {
    return _instance;
  }

  String? get authToken => _authToken;
  bool get isAuthenticated => _authToken != null;

  /*
  Future<void> initializeAuth(BuildContext context) async {

  } */

  Future<Map<String, dynamic>> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    final Uri uri = Uri.parse('$_authBaseUrl/access-list');

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['token'] != null && responseData['user'] != null) {
          _authToken = responseData['token'] as String;

          Provider.of<UserProvider>(
            context,
            listen: false,
          ).setUser(responseData['user'] as Map<String, dynamic>);

          return {'success': true, 'message': 'Inicio de sesión exitoso.'};
        } else {
          logout(context);
          return {
            'success': false,
            'message':
                'Respuesta de inicio de sesión incompleta (falta token o datos de usuario).',
          };
        }
      } else if (response.statusCode == 401) {
        logout(context);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Credenciales inválidas.',
        };
      } else {
        logout(context); // Clear state on unexpected error
        return {
          'success': false,
          'message':
              responseData['message'] ?? 'Error desconocido al iniciar sesión.',
        };
      }
    } catch (e) {
      logout(context);
      return {
        'success': false,
        'message': 'Error de conexión durante el inicio de sesión: $e',
      };
    }
  }

  void logout(BuildContext context) {
    _authToken = null;

    Provider.of<UserProvider>(context, listen: false).clearUser();
  }
}
