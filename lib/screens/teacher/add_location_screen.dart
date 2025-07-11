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
  final _roomController = TextEditingController();

  int? _selectedDay;
  String? _selectedBuilding;
  TimeOfDay? _selectedEntryTime;
  TimeOfDay? _selectedDepartureTime;

  final Map<String, String> _buildingOptions = {
    'A': 'Edificio A',
    'B': 'Edificio B',
    'C': 'Edificio C',
    'D': 'Edificio D',
  };

  final Map<int, String> _dayOptions = {
    1: 'Lunes',
    2: 'Martes',
    3: 'Miércoles',
    4: 'Jueves',
    5: 'Viernes',
    6: 'Sabado',
  };

  @override
  void dispose() {
    _locationNameController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, {required bool isEntry}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isEntry ? (_selectedEntryTime ?? TimeOfDay.now()) : (_selectedDepartureTime ?? TimeOfDay.now()),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isEntry) {
          _selectedEntryTime = picked;
        } else {
        _selectedDepartureTime = picked;
        }
      });
    }
  }

  void _saveLocation() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? responsibleId = userProvider.currentUser?.id;

    if (_formKey.currentState!.validate()) {
      final locationName = _locationNameController.text;
      final building = _selectedBuilding;
      final room = int.tryParse(_roomController.text);
      final day = _selectedDay;
      final entryTime = _selectedEntryTime;
      final departureTime = _selectedDepartureTime;

      if (building == null || entryTime== null || departureTime == null || room == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor completa todos los campos correctamente.')),
        );
        return;
      }

      bool res = await _backendService.addLocation(context, {
        'name': locationName,
        'edificio': building,
        'salon': room,
        'day': day,
        'hora_entrada': '${entryTime.hour.toString().padLeft(2, '0')}:${entryTime.minute.toString().padLeft(2, '0')}:00',
        'hora_salida': '${departureTime.hour.toString().padLeft(2, '0')}:${departureTime.minute.toString().padLeft(2, '0')}:00',
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
                value: _selectedBuilding,
                decoration: _inputDecoration('Edificio', Icons.business),
                hint: const Text('Selecciona un edificio'),
                items: _buildingOptions.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedBuilding = value),
                validator: (value) => value == null ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _roomController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Salón', Icons.meeting_room, 'Ej: 101, 205'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Este campo es obligatorio';
                  if (int.tryParse(value) == null) return 'Debe ser un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _selectedDay,
                decoration: _inputDecoration('Dia', Icons.calendar_month),
                hint: const Text('Selecciona un dia'),
                items: _dayOptions.entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedDay = value),
                validator: (value) => value == null ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectTime(context, isEntry: true),
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedEntryTime?.format(context) ?? '',
                    ),
                    decoration: _inputDecoration('Hora de Entrada', Icons.access_time),
                    validator: (_) => _selectedEntryTime == null ? 'Este campo es obligatorio' : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectTime(context, isEntry: false),
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedDepartureTime?.format(context) ?? '',
                    ),
                    decoration: _inputDecoration('Hora de Salida', Icons.access_time),
                    validator: (_) {
                      if (_selectedDepartureTime == null) return 'Este campo es obligatorio';
                      if (_selectedEntryTime != null && _selectedDepartureTime != null) {
                        final entryMinutes = _selectedEntryTime!.hour * 60 + _selectedEntryTime!.minute;
                        final departureMinutes = _selectedDepartureTime!.hour * 60 + _selectedDepartureTime!.minute;
                        if (departureMinutes <= entryMinutes) {
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
