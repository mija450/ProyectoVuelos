import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(Insert_Flight_History());
}

class Insert_Flight_History extends StatelessWidget {
  const Insert_Flight_History({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro y Visualización de Vuelos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FlightManagement(),
    );
  }
}

class FlightManagement extends StatefulWidget {
  const FlightManagement({super.key});

  @override
  _FlightManagementState createState() => _FlightManagementState();
}

class _FlightManagementState extends State<FlightManagement> {
  final TextEditingController flightCodeController = TextEditingController();
  final TextEditingController flightStateController = TextEditingController();
  final TextEditingController changeTimeController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  Future<void> insertFlightHistory() async {
    if (_areFieldsValid()) {
      const String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_flight_history.php";
      try {
        var res = await http.post(
          Uri.parse(uri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "codigo_vuelo": flightCodeController.text,
            "estado": flightStateController.text,
            "cambio_hora": changeTimeController.text,
            "razon": reasonController.text,
          }),
        );

        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          _showSnackBar("Historial de vuelo insertado correctamente");
          _clearFields();
        } else {
          _showSnackBar("Error: ${response['error']}");
        }
      } catch (e) {
        _showSnackBar("Error: $e");
      }
    } else {
      _showSnackBar("Por favor, llene todos los campos.");
    }
  }

  bool _areFieldsValid() {
    return flightCodeController.text.isNotEmpty &&
           flightStateController.text.isNotEmpty &&
           changeTimeController.text.isNotEmpty &&
           reasonController.text.isNotEmpty;
  }

  void _clearFields() {
    flightCodeController.clear();
    flightStateController.clear();
    changeTimeController.clear();
    reasonController.clear();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _selectDateTime(TextEditingController controller) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (pickedTime != null) {
        setState(() {
          controller.text = "${pickedDate.toIso8601String().substring(0, 10)}T${pickedTime.hour}:${pickedTime.minute}:00";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Historial de Vuelo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: flightCodeController,
                decoration: InputDecoration(labelText: 'Ingrese el código de vuelo'),
              ),
              TextField(
                controller: flightStateController,
                decoration: InputDecoration(labelText: 'Ingrese el estado'),
              ),
              TextField(
                controller: changeTimeController,
                decoration: InputDecoration(
                  labelText: 'Ingrese el cambio de hora (YYYY-MM-DDTHH:MM:SS)',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDateTime(changeTimeController),
                  ),
                ),
                readOnly: true,
              ),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(labelText: 'Ingrese la razón'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: insertFlightHistory,
                child: Text("Insertar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}