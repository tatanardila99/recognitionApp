import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/service.dart'; // Asegúrate de que esta ruta sea correcta

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

      if (edificio == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor selecciona un edificio')),
        );
        return;
      }
      if (horaEntrada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor selecciona una hora de entrada')),
        );
        return;
      }
      if (horaSalida == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor selecciona una hora de salida')),
        );
        return;
      }
      if (salon == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor ingresa un número de salón válido'),
          ),
        );
        return;
      }

      bool res = await _backendService.addLocation(context, {
        'name': locationName,
        'edificio': edificio,
        'salon': salon,
        'hora_entrada':
            '${horaEntrada.hour.toString().padLeft(2, '0')}:${horaEntrada.minute.toString().padLeft(2, '0')}:00',
        'hora_salida':
            '${horaSalida.hour.toString().padLeft(2, '0')}:${horaSalida.minute.toString().padLeft(2, '0')}:00',
        'responsible_id': responsibleId,
      });

      if (res) {
        Navigator.of(context).pop(locationName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar la ubicación. Intenta de nuevo.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Ubicación')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _locationNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Ubicación',
                  hintText: 'Ej: Laboratorio de Física',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre para la ubicación';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _selectedEdificio,
                decoration: InputDecoration(
                  labelText: 'Edificio',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                hint: Text('Selecciona un edificio'),
                items:
                    _edificioOptions.entries.map((
                      MapEntry<String, String> entry,
                    ) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedEdificio = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona un edificio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: _salonController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Salón',
                  hintText: 'Ej: 101, 205',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.meeting_room),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el número del salón';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              GestureDetector(
                onTap: () => _selectTime(context, isEntrada: true),
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text:
                          _selectedHoraEntrada == null
                              ? ''
                              : _selectedHoraEntrada!.format(context),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Hora de Entrada',
                      hintText: 'Selecciona la hora de entrada',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    validator: (value) {
                      if (_selectedHoraEntrada == null) {
                        return 'Por favor selecciona la hora de entrada';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              GestureDetector(
                onTap: () => _selectTime(context, isEntrada: false),
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text:
                          _selectedHoraSalida == null
                              ? ''
                              : _selectedHoraSalida!.format(context),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Hora de Salida',
                      hintText: 'Selecciona la hora de salida',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    validator: (value) {
                      if (_selectedHoraSalida == null) {
                        return 'Por favor selecciona la hora de salida';
                      }

                      if (_selectedHoraEntrada != null &&
                          _selectedHoraSalida != null) {
                        final entradaMinutes =
                            _selectedHoraEntrada!.hour * 60 +
                            _selectedHoraEntrada!.minute;
                        final salidaMinutes =
                            _selectedHoraSalida!.hour * 60 +
                            _selectedHoraSalida!.minute;
                        if (salidaMinutes <= entradaMinutes) {
                          return 'La hora de salida debe ser posterior a la de entrada';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),


              ElevatedButton.icon(
                onPressed: _saveLocation,
                icon: Icon(Icons.save_outlined),
                label: Text('Guardar Ubicación'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF899DD9),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
