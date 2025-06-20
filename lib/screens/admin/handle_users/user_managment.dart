import 'package:flutter/material.dart';

import 'package:uts_recognitionapp/models/user_data.dart';
import 'package:uts_recognitionapp/screens/admin/handle_users/user_card.dart';
import 'package:uts_recognitionapp/services/service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final BackendService _backendService = BackendService();
  List<UserData> _users = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetchedUsers = await _backendService.getAllUsers(context);

      setState(() {
        _users = fetchedUsers;
        _users.sort((a, b) => a.name.compareTo(b.name));
      });
    } catch (e) {
      _errorMessage = 'Error al cargar usuarios: $e';
      print('Error en _loadUsers: $_errorMessage');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: Color(0xFF899DD9),
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_errorMessage!),
                    ElevatedButton(
                      onPressed: _loadUsers,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
              : _users.isEmpty
              ? const Center(child: Text('No hay usuarios registrados.'))
              : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return UserCard(
                    user: user,
                    onUserUpdated: () {
                      _loadUsers();
                    },
                  );
                },
              ),
    );
  }
}
