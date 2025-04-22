import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FaceIdSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Formulario(),
    );
  }
}

class Formulario extends StatefulWidget {
  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _imagen;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imagen = File(pickedFile.path);
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 150),
            Text("Bienvenido", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18), textAlign: TextAlign.center,),
            SizedBox(height: 50),
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                labelText: 'Nombre',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
                return null;
              },
            ),
            SizedBox(height: 40),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ), labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu email';
                }
                return null;
              },
            ),
            SizedBox(height: 40),
            TextFormField(
              controller: _telefonoController,
              decoration: InputDecoration(border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ), labelText: 'Teléfono'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu teléfono';
                }
                return null;
              },
            ),
            SizedBox(height: 40),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ), labelText: 'Contraseña'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu contraseña';
                }
                return null;
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(onPressed: getImage, child: Text('Tomar Foto')),
            if (_imagen != null)
              Image.file(
                _imagen!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF899DD9),
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print('Nombre: ${_nombreController.text}');
                  print('Email: ${_emailController.text}');
                  print('Teléfono: ${_telefonoController.text}');
                  print('Contraseña: ${_passwordController.text}');
                }
              },
              child: Text('Enviar', style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ya estas registrado?   '),
                InkWell(
                  child: Text(
                    'Ingresar',
                    style: TextStyle(color: Colors.deepPurpleAccent[400]),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/sign');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}