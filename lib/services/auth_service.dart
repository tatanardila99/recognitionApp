import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uts_recognitionapp/providers/user_provider.dart';

import '../config/constants.dart';

class AuthService {
  final String _authBaseUrl = kBaseUrl;

  String? _authToken;

  AuthService._privateConstructor();
  static final AuthService _instance = AuthService._privateConstructor();

  factory AuthService() {
    return _instance;
  }

  String? get authToken {
    return _authToken;
  }
  bool get isAuthenticated => _authToken != null;

  Future<void> _saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    final Uri uri = Uri.parse('$_authBaseUrl/sign-in');

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
          await _saveAuthToken(_authToken!);

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

  void logout(BuildContext context) async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Provider.of<UserProvider>(context, listen: false).clearUser();
  }
}
