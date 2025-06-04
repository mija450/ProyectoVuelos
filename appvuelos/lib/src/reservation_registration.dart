import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'viewReservations3.dart'; 

void main() {
  runApp(Reservas_Registration());
}

class Reservas_Registration extends StatelessWidget {
  const Reservas_Registration({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Reservas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ReservationRegistration(),
    );
  }
}

class ReservationRegistration extends StatefulWidget {
  const ReservationRegistration({super.key});

  @override
  _ReservationRegistrationState createState() => _ReservationRegistrationState();
}

class _ReservationRegistrationState extends State<ReservationRegistration> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController flightIdController = TextEditingController();
  TextEditingController bookingDateController = TextEditingController();
  String? status;

  Future<void> insertReservation() async {
    if (userIdController.text.isEmpty || 
        flightIdController.text.isEmpty || 
        bookingDateController.text.isEmpty || 
        status == null) {
      _showSnackBar("Por favor, llene todos los campos.");
      return;
    }

    try {
      String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_reservation.php";
      var res = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": int.parse(userIdController.text),
          "flight_id": int.parse(flightIdController.text),
          "booking_date": bookingDateController.text,
          "status": status,
        }),
      );

      var response = jsonDecode(res.body);

      if (response["success"] == true) {
        _showSnackBar("Reserva insertada correctamente.");
        userIdController.clear();
        flightIdController.clear();
        bookingDateController.clear();
        setState(() {
          status = null;
        });
      } else {
        _showSnackBar("Error: ${response['error']}");
      }
    } catch (e) {
      _showSnackBar("Error de conexión: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _selectBookingDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        bookingDateController.text = pickedDate.toIso8601String().substring(0, 10); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro de Reserva")),
      body: SingleChildScrollView( 
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/reserva.png'), 
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: userIdController,
                decoration: InputDecoration(labelText: 'ID del Usuario'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: flightIdController,
                decoration: InputDecoration(labelText: 'ID del Vuelo'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: bookingDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Reserva',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectBookingDate(context),
                  ),
                ),
                readOnly: true,
              ),
              DropdownButtonFormField<String>(
                value: status,
                onChanged: (String? newValue) {
                  setState(() {
                    status = newValue;
                  });
                },
                items: ['confirmed', 'cancelled'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                hint: Text('Seleccione el Estado'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: insertReservation,
                child: Text("Insertar Reserva"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewReservations()), 
                  );
                },
                child: Text("Mostrar Reservas"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}