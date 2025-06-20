import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:async/async.dart';
import 'package:provider/provider.dart';
import 'package:uts_recognitionapp/providers/user_provider.dart';
import 'package:uts_recognitionapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../models/location.dart';
import '../models/user_data.dart';

class BackendService {
  //final String _baseUrl = 'http://10.0.2.2:3000/api'; // emulador
  final String _baseUrl = 'http://192.168.1.6:3000/api';   // fisico
  final http.Client _httpClient = http.Client();

  BackendService._privateConstructor();
  static final BackendService _instance = BackendService._privateConstructor();

  factory BackendService() {
    return _instance;
  }


  Map<String, String> _getAuthHeaders() {
    final String? token = AuthService().authToken;
    return {
      'content-type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  void _handleUnauthorized(BuildContext context) {
    AuthService().logout(context);
  }

  Future<Map<String, dynamic>> _put(BuildContext context, String endpoint, Map<String, dynamic> data) async {
    final response = await _httpClient.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _getAuthHeaders(),
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      _handleUnauthorized(context);
      throw Exception('Unauthorized: Session expired or invalid token.');
    } else {
      final errorBody = json.decode(response.body);
      throw Exception('Failed to update data: ${response.statusCode} - ${errorBody['message'] ?? response.body}');
    }
  }

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
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }



  Future<Map<String, dynamic>?> validateAccess(File image, String locationId) async {
    final Uri uri = Uri.parse('$_baseUrl/validate-access');

    try {
      var request = http.MultipartRequest('POST', uri);
      
      request.headers.addAll(_getAuthHeaders());
      request.files.add(await http.MultipartFile.fromPath('image', image.path));


      request.fields['ubicacion_id'] = locationId;

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> data = json.decode(responseBody);
        String? userName = data['user'];
        double? similarity = data['similarity'];
        return {'username': userName, 'similarity': similarity };
      } else {
        final responseBody = await response.stream.bytesToString();
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> addLocation(BuildContext context, Map<String, dynamic> locationData) async {
    final Uri uri = Uri.parse('$_baseUrl/create-location');

    try {
      final response = await http.post(
        uri,
        headers: _getAuthHeaders(),
        body: jsonEncode(locationData),
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        return true;
      } else if (response.statusCode == 401) {
        _handleUnauthorized(context);
        return false;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<List<Location>> getLocations(BuildContext context) async {
    final Uri uri = Uri.parse('$_baseUrl/all-locations');
    try {
      final response = await http.get(
          uri,
          headers: _getAuthHeaders()
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        List<dynamic> jsonList = responseBody['locations'] as List<dynamic>? ?? [];
        return jsonList.map((json) => Location.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        _handleUnauthorized(context);
        return [];
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }


  Future<Map<String, dynamic>?> getLocationBYId(BuildContext context, int id) async {
    final Uri uri = Uri.parse('$_baseUrl/get-location-by-id/$id');

    try {
      final response = await http.get(
          uri,
          headers: _getAuthHeaders()
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        Map<String, dynamic> location = responseBody['location'];
        return {'location_name': location['name']};
      } else if (response.statusCode == 401) {
        _handleUnauthorized(context);
        return null;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<Map<String, dynamic>> updateUser(
      BuildContext context,
      int userId,
      Map<String, dynamic> updateData,
      ) async {
    final Uri uri = Uri.parse('$_baseUrl/update-user/$userId');

    try {
      final response = await _httpClient.put(
        uri,
        headers: _getAuthHeaders(),
        body: json.encode(updateData),
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (userId == Provider.of<UserProvider>(context, listen: false).currentUser?.id) {
          Provider.of<UserProvider>(context, listen: false).setUser(responseBody);
        }
        return responseBody;
      } else if (response.statusCode == 401) {
        _handleUnauthorized(context);
        throw Exception('Unauthorized: Session expired or invalid token.');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Failed to update user: ${response.statusCode} - ${errorBody['message'] ?? response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updatePassword(
      BuildContext context,
      int userId,
      String currentPassword,
      String newPassword,
      ) async {

    final String endpoint = 'update-user/$userId';
    final Map<String, dynamic> data = {
      'currentPassword': currentPassword,
      'password_hash': newPassword,
    };

    try {
      final response = await _put(context, endpoint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserData>> getAllUsers(BuildContext context) async {
    final Uri uri = Uri.parse('$_baseUrl/users');
    try {
      final response = await _httpClient.get(
          uri,
          headers: _getAuthHeaders()
      );

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = jsonDecode(response.body);
        return usersJson.map((json) => UserData.fromJson(json as Map<String, dynamic>)).toList();
      } else if (response.statusCode == 401) {
        _handleUnauthorized(context);
        return [];
      } else {
        return [];
      }
    } catch (e) {
      return []; 
    }
  }

  Future<bool> deleteUser(BuildContext context, int userId) async {
    final Uri uri = Uri.parse('$_baseUrl/delete-user/$userId');

    try {
      final response = await _httpClient.delete(
        uri,
        headers: _getAuthHeaders()
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 401) {
        _handleUnauthorized(context);
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<Location>> getLocationsByResponsible(BuildContext context) async {
    final Uri uri = Uri.parse('$_baseUrl/my-locations');

    try {
      final response = await _httpClient.get(
        uri,
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        List<dynamic> jsonList = responseBody['locations'] as List<dynamic>? ?? [];
        return jsonList.map((json) => Location.fromJson(json)).toList();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        
        _handleUnauthorized(context);
        final errorBody = json.decode(response.body);
        return [];
      } else {
        final errorBody = json.decode(response.body);
        return [];
      }
    } catch (e) {
      return [];
    }
  }

}