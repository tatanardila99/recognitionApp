import 'package:flutter/material.dart';
import '../../services/service.dart';

class AddLocationScreen extends StatefulWidget {
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
    'E': 'Edificio E',
  };

  @override
  void dispose() {
    _locationNameController.dispose();
    _salonController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(
    BuildContext context, {
    required bool isEntrada,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          isEntrada
              ? (_selectedHoraEntrada ?? TimeOfDay.now())
              : (_selectedHoraSalida ?? TimeOfDay.now()),
      builder: (context, child) {
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
    if (_formKey.currentState!.validate()) {
      final locationName = _locationNameController.text;
      final edificio = _selectedEdificio;
      final salon = int.tryParse(_salonController.text);
      final horaEntrada = _selectedHoraEntrada;
      final horaSalida = _selectedHoraSalida;

      if (edificio == null ||
          horaEntrada == null ||
          horaSalida == null ||
          salon == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor completa todos los campos')),
        );
        return;
      }

      final res = await _backendService.addLocation({
        'name': locationName,
        'edificio': edificio,
        'salon': salon,
        'hora_entrada':
            '${horaEntrada.hour.toString().padLeft(2, '0')}:${horaEntrada.minute.toString().padLeft(2, '0')}:00',
        'hora_salida':
            '${horaSalida.hour.toString().padLeft(2, '0')}:${horaSalida.minute.toString().padLeft(2, '0')}:00',
      });

      if (res) {
        Navigator.of(context).pop(locationName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la ubicación')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration =
        (String label, IconData icon) => InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.grey[100],
          prefixIcon: Icon(icon),
        );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header
                Column(
                  children: [
                    Text(
                      'Agregar Ubicación',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completa los datos para registrar un aula o laboratorio.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _locationNameController,
                  decoration: inputDecoration(
                    'Nombre de la Ubicación',
                    Icons.location_on,
                  ),
                  validator:
                      (value) => value!.isEmpty ? 'Ingresa un nombre' : null,
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: _selectedEdificio,
                  decoration: inputDecoration('Edificio', Icons.business),
                  items:
                      _edificioOptions.entries
                          .map(
                            (entry) => DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value),
                            ),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => _selectedEdificio = val),
                  validator:
                      (value) =>
                          value == null ? 'Selecciona un edificio' : null,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _salonController,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration(
                    'Número de Salón',
                    Icons.meeting_room,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Ingresa el número del salón';
                    if (int.tryParse(value) == null)
                      return 'Debe ser un número válido';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => _selectTime(context, isEntrada: true),
                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: true,
                      decoration: inputDecoration(
                        'Hora de Entrada',
                        Icons.access_time,
                      ).copyWith(
                        hintText:
                            _selectedHoraEntrada?.format(context) ??
                            'Selecciona la hora',
                      ),
                      validator:
                          (value) =>
                              _selectedHoraEntrada == null
                                  ? 'Selecciona la hora de entrada'
                                  : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => _selectTime(context, isEntrada: false),
                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: true,
                      decoration: inputDecoration(
                        'Hora de Salida',
                        Icons.access_time,
                      ).copyWith(
                        hintText:
                            _selectedHoraSalida?.format(context) ??
                            'Selecciona la hora',
                      ),
                      validator: (value) {
                        if (_selectedHoraSalida == null)
                          return 'Selecciona la hora de salida';
                        if (_selectedHoraEntrada != null) {
                          final entrada = _selectedHoraEntrada!;
                          final salida = _selectedHoraSalida!;
                          final entradaMin = entrada.hour * 60 + entrada.minute;
                          final salidaMin = salida.hour * 60 + salida.minute;
                          if (salidaMin <= entradaMin) {
                            return 'La salida debe ser posterior a la entrada';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _saveLocation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 40.0,
                    ),
                    child: Text(
                      'Guardar Ubicación',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
