// backend_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:async/async.dart';

import '../models/location.dart';

class BackendService {
  //final String _baseUrl = 'http://10.0.2.2:3000/api'; // emulador
  final String _baseUrl = 'http://192.168.1.8:3000/api';   // fisico
  final http.Client _httpClient = http.Client();

  Future<bool> sendDataRegister(
      String name,
      String email,
      String password,
      String document,
      String rol,
      File? face,
      ) async {
    final Uri uri = Uri.parse('$_baseUrl/register');

    try {
      final request = http.MultipartRequest('POST', uri);
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password_hash'] = password;
      request.fields['document'] = document;
      request.fields['rol'] = rol;

      if (face != null) {
        final stream = http.ByteStream(DelegatingStream.typed(face.openRead()));
        final length = await face.length();
        final multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: 'face.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Registro exitoso: $responseBody');
        return true;
      } else {
        print('Error en el registro. Código: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${await response.stream.bytesToString()}');
        return false;
      }
    } catch (error) {
      print('Error de conexión durante el registro: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>?> sendDataLogin(String email, String password) async {
    final Uri uri = Uri.parse('$_baseUrl/access-list');

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

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Inicio de sesión exitoso: $responseData');
        return responseData;
      } else if (response.statusCode == 401) {
        print('Error de inicio de sesión. Credenciales inválidas.');
        return null;
      } else {
        print('Error en el inicio de sesión. Código: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error de conexión durante el inicio de sesión: $error');
      return null;
    }
  }

  Future<bool> validateAccess(File image, String locationId) async {
    final Uri uri = Uri.parse('$_baseUrl/validate-access');

    try {
      var request = http.MultipartRequest('POST', uri);


      request.files.add(await http.MultipartFile.fromPath('image', image.path));


      request.fields['ubicacion_id'] = locationId;

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image and location sent successfully. Access granted.');
        return true;
      } else {

        final responseBody = await response.stream.bytesToString();
        print('Error sending image: ${response.statusCode}');
        print('Response body: $responseBody'); // Log the error detail
        return false;
      }
    } catch (e) {
      print('Connection error: $e');
      return false;
    }
  }

  Future<bool> addLocation(Map<String, dynamic> locationData) async {
    final Uri uri = Uri.parse('$_baseUrl/create-location');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(locationData),
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        print('Creación exitosa de la ubicación: $responseBody');
        return true;
      } else {
        print('Error en la creación de ubicación: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error de conexión durante creación de ubicación: $error');
      return false;
    }
  }

  Future<List<Location>> getLocations() async {
    final Uri uri = Uri.parse('$_baseUrl/all-locations');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        List<dynamic> jsonList = responseBody['locations'] as List<dynamic>? ?? [];
        return jsonList.map((json) => Location.fromJson(json)).toList();
      } else {
        print('Error al obtener ubicaciones: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error de conexión al obtener ubicaciones: $error');
      return [];
    }
  }

}