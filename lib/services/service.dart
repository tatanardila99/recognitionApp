// backend_service.dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:async/async.dart';

class BackendService {
  final String _baseUrl = 'http://localhost:3000/api';

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
        return true; // Indica éxito
      } else {
        print('Error en el registro. Código: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${await response.stream.bytesToString()}'); // Imprime el cuerpo del error para depuración
        return false; // Indica fallo
      }
    } catch (error) {
      print('Error de conexión durante el registro: $error');
      return false;
    }
  }

// Puedes agregar otras funciones para diferentes endpoints de tu backend aquí
// Por ejemplo, para el inicio de sesión, la obtención de datos de perfil, etc.
}