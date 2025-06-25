
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/service.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isLoading = false;
  String? _formMessage;


  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace.'), backgroundColor: Colors.red),
      );
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'iojedav@uts.edu.co jiperez@uts.edu.co',
      queryParameters: {
        'subject': 'Consulta desde la App UTS Recognition',
        'body': 'Nombre: ${_nameController.text}\nEmail: ${_emailController.text}\nMensaje:\n${_messageController.text}',
      },
    );
    await _launchUrl(emailLaunchUri.toString());
  }

  Future<void> _makePhoneCall() async {
    await _launchUrl('tel:(607)6917700');
  }


  void _submitForm() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _messageController.text.isEmpty) {
      setState(() {
        _formMessage = 'Por favor, completa todos los campos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _formMessage = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _formMessage = '¡Mensaje enviado con éxito! Te contactaremos pronto.';
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_formMessage!), backgroundColor: Colors.green),
      );
    } catch (e) {
      setState(() {
        _formMessage = 'Error al enviar el mensaje: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_formMessage!), backgroundColor: Colors.red),
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
        title: const Text('Contáctenos'),
        backgroundColor: const Color(0xFF899DD9),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            const Text(
              '¿Necesitas ayuda? Contáctanos a través de los siguientes medios:',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.email, color: Color(0xFF899DD9)),
                title: const Text('Correo Electrónico'),
                subtitle: const Text('iojedav@uts.edu.co jiperez@uts.edu.co'),
                onTap: _sendEmail,
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Color(0xFF899DD9)),
                title: const Text('Teléfono'),
                subtitle: const Text('(607)6917700'),
                onTap: _makePhoneCall,
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Color(0xFF899DD9)),
                title: const Text('Dirección'),
                subtitle: const Text('Av. Los Estudiantes #9-82, Bucaramanga, Santander'),
                onTap: () {

                  _launchUrl('https://www.google.com/maps/search/Av. Los Estudiantes+9+82+Bucaramanga');
                },
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.web, color: Color(0xFF899DD9)),
                title: const Text('Sitio Web'),
                subtitle: const Text('www.uts.edu.co'),
                onTap: () {
                  _launchUrl('https://www.uts.edu.co/');
                },
              ),
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 30),


            const Text(
              'O envíanos un mensaje directamente:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF899DD9)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tu Nombre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Tu Correo Electrónico',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Tu Mensaje',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.message),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              minLines: 3,
            ),
            const SizedBox(height: 20),

            if (_formMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _formMessage!,
                  style: TextStyle(
                    color: _formMessage!.contains('éxito') ? Colors.green : Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF899DD9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Enviar Mensaje',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}