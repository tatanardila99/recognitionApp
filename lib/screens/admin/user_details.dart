import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/models/user_data.dart'; // Make sure this path is correct

import '../../services/service.dart'; // Import your BackendService

class UserDetailsPage extends StatefulWidget {
  final UserData user;

  const UserDetailsPage({super.key, required this.user});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late UserData _currentUser;
  final BackendService _backendService = BackendService();
  bool _isUpdating = false;
  bool _didUpdateUser = false;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  bool _isActive(int status) {
    return status == 1;
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Activo';
      case 0:
        return 'Inactivo';
      default:
        return 'Desconocido';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.green[700]!;
      case 0:
        return Colors.red[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                color: valueColor ?? Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleUserStatus() async {
    setState(() {
      _isUpdating = true;
    });

    final newStatus = _isActive(_currentUser.status) ? 0 : 1;
    final updatedData = {'status': newStatus};

    try {
      final response = await _backendService.updateUser(
        context,
        _currentUser.id,
        updatedData,
      );

      if (response['success'] == true) {
        setState(() {
          _currentUser = _currentUser.copyWith(status: newStatus);
          _didUpdateUser = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Usuario ${_currentUser.name} ha sido ${newStatus == 1 ? 'activado' : 'desactivado'}.',
            ),
          ),
        );
        //Navigator.of(context).pop(_didUpdateUser);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al cambiar el estado: ${response['message'] ?? 'Error desconocido'}.',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión o servidor: $e')),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  Future<void> _confirmDeleteUser() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text(
            '¿Estás seguro de que quieres eliminar a ${_currentUser.name}? Esta acción es irreversible.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      _deleteUser();
    }
  }

  Future<void> _deleteUser() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      bool success = true;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Usuario ${_currentUser.name} eliminado exitosamente.',
            ),
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el usuario.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión o servidor al eliminar: $e')),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop(_didUpdateUser);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentUser.name),
          backgroundColor: Color(0xFF899DD9),
          foregroundColor: Colors.white,
        ),
        body:
            _isUpdating
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Color(
                                0xFF899DD9,
                              ).withOpacity(0.7),
                              backgroundImage:
                                  _currentUser.profileImageUrl != null &&
                                          _currentUser
                                              .profileImageUrl!
                                              .isNotEmpty
                                      ? NetworkImage(
                                        _currentUser.profileImageUrl!,
                                      )
                                      : null,
                              child:
                                  _currentUser.profileImageUrl == null ||
                                          _currentUser.profileImageUrl!.isEmpty
                                      ? Text(
                                        _currentUser.name.isNotEmpty
                                            ? _currentUser.name[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                        ),
                                      )
                                      : null,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _currentUser.name,
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),

                      _buildDetailRow('ID:', _currentUser.id.toString()),
                      _buildDetailRow('Email:', _currentUser.email),
                      _buildDetailRow('Rol:', _currentUser.rol),
                      _buildDetailRow(
                        'Estado:',
                        _getStatusText(_currentUser.status),
                        valueColor: _getStatusColor(_currentUser.status),
                      ),

                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 20),

                      Text(
                        'Acciones Administrativas',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      const SizedBox(height: 15),

                      ElevatedButton.icon(
                        onPressed: _isUpdating ? null : _toggleUserStatus,
                        icon: Icon(
                          _isActive(_currentUser.status)
                              ? Icons.lock_open
                              : Icons.lock,
                        ),
                        label: Text(
                          _isActive(_currentUser.status)
                              ? 'Desactivar Usuario'
                              : 'Activar Usuario',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isActive(_currentUser.status)
                                  ? Colors.orange[700]
                                  : Colors.green[700],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: _isUpdating ? null : _confirmDeleteUser,
                        icon: const Icon(Icons.delete_forever),
                        label: const Text('Eliminar Usuario'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[800],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
