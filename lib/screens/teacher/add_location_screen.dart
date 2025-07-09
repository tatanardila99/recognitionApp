import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/service.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final BackendService _backendService = BackendService();

  final _locationNameController = TextEditingController();
  final _salonController = TextEditingController();

  String? _selectedEdificio;
  TimeOfDay? _selectedHoraEntrada;
  TimeOfDay? _selectedHoraSalida;

  final Map<String, String> _edificioOptions = {
    'A': 'Edificio A',
    'B': 'Edificio B',
    'C': 'Edificio C',
    'D': 'Edificio D',
  };

  @override
  void dispose() {
    _locationNameController.dispose();
    _salonController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, {required bool isEntrada}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isEntrada ? (_selectedHoraEntrada ?? TimeOfDay.now()) : (_selectedHoraSalida ?? TimeOfDay.now()),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isEntrada) {
          _selectedHoraEntrada = picked;
        } else {
          _selectedHoraSalida = picked;
        }
      });
    }
  }

  void _saveLocation() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? responsibleId = userProvider.currentUser?.id;

    if (_formKey.currentState!.validate()) {
      final locationName = _locationNameController.text;
      final edificio = _selectedEdificio;
      final salon = int.tryParse(_salonController.text);
      final horaEntrada = _selectedHoraEntrada;
      final horaSalida = _selectedHoraSalida;

      if (edificio == null || horaEntrada == null || horaSalida == null || salon == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor completa todos los campos correctamente.')),
        );
        return;
      }

      bool res = await _backendService.addLocation(context, {
        'name': locationName,
        'edificio': edificio,
        'salon': salon,
        'hora_entrada': '${horaEntrada.hour.toString().padLeft(2, '0')}:${horaEntrada.minute.toString().padLeft(2, '0')}:00',
        'hora_salida': '${horaSalida.hour.toString().padLeft(2, '0')}:${horaSalida.minute.toString().padLeft(2, '0')}:00',
        'responsible_id': responsibleId,
      });

      if (res) {
        Navigator.of(context).pop(locationName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la ubicación. Intenta de nuevo.')),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon, [String? hint]) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Agregar Ubicación',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _locationNameController,
                decoration: _inputDecoration('Nombre de la Ubicación', Icons.location_on, 'Ej: Laboratorio de Física'),
                validator: (value) => value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedEdificio,
                decoration: _inputDecoration('Edificio', Icons.business),
                hint: const Text('Selecciona un edificio'),
                items: _edificioOptions.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedEdificio = value),
                validator: (value) => value == null ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _salonController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Salón', Icons.meeting_room, 'Ej: 101, 205'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Este campo es obligatorio';
                  if (int.tryParse(value) == null) return 'Debe ser un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectTime(context, isEntrada: true),
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedHoraEntrada?.format(context) ?? '',
                    ),
                    decoration: _inputDecoration('Hora de Entrada', Icons.access_time),
                    validator: (_) => _selectedHoraEntrada == null ? 'Este campo es obligatorio' : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectTime(context, isEntrada: false),
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedHoraSalida?.format(context) ?? '',
                    ),
                    decoration: _inputDecoration('Hora de Salida', Icons.access_time),
                    validator: (_) {
                      if (_selectedHoraSalida == null) return 'Este campo es obligatorio';
                      if (_selectedHoraEntrada != null && _selectedHoraSalida != null) {
                        final entradaMinutes = _selectedHoraEntrada!.hour * 60 + _selectedHoraEntrada!.minute;
                        final salidaMinutes = _selectedHoraSalida!.hour * 60 + _selectedHoraSalida!.minute;
                        if (salidaMinutes <= entradaMinutes) {
                          return 'Debe ser posterior a la hora de entrada';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _saveLocation,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Guardar Ubicación'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF899DD9),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
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
