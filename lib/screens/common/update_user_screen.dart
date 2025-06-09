import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_recognitionapp/providers/user_provider.dart';
import '../../services/service.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final BackendService _backendService = BackendService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.currentUser != null) {
      _nameController.text = userProvider.currentUser!.name ?? '';
      _emailController.text = userProvider.currentUser!.email ?? '';
    }
  }


  void _handleUpdateUser() async {
    // Get user ID from the provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.currentUser?.id;

    if (userId == null) {
      setState(() {
        _errorMessage = 'Error: User ID not found. Please log in again.';
      });
      return;
    }

    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();

    // Basic validation
    if (newName.isEmpty || newEmail.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill all fields.';
      });
      return;
    }

    // You might want more robust email validation here
    if (!newEmail.contains('@')) {
      setState(() {
        _errorMessage = 'Please enter a valid email address.';
      });
      return;
    }


    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {

      final Map<String, dynamic> updateData = {
        'name': newName,
        'email': newEmail,

      };


      final response = await _backendService.updateUser(userId, updateData);

      setState(() {
        _successMessage = response['message'] ?? 'User data updated successfully!';
      });


      final updatedUser = userProvider.currentUser!.copyWith(
        name: newName,
        email: newEmail,

      );
      userProvider.setUser(updatedUser.toJson());


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_successMessage!), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().contains('Exception: ')
            ? e.toString().replaceFirst('Exception: ', '')
            : 'An unexpected error occurred. Please try again.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red),
      );
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
        title: const Text('Editar Perfil'),
        backgroundColor: const Color(0xFF899DD9),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Actualiza tu información personal.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _handleUpdateUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF899DD9),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Guardar Cambios',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}