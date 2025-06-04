import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'viewreservations3.dart'; 

class UpdateReservation extends StatefulWidget {
  final String id;
  final String flightId;
  final String status;
  final String bookingDate;

  const UpdateReservation({super.key, 
    required this.id,
    required this.flightId,
    required this.status,
    required this.bookingDate,
  });

  @override
  State<UpdateReservation> createState() => _UpdateReservationState();
}

class _UpdateReservationState extends State<UpdateReservation> {
  TextEditingController flightIdController = TextEditingController();
  TextEditingController bookingDateController = TextEditingController();
  String? status; // Variable para el estado

  @override
  void initState() {
    super.initState();
    flightIdController.text = widget.flightId;
    status = widget.status; // Inicializa el estado
    bookingDateController.text = widget.bookingDate;
  }

  Future<void> updateRecord() async {
    if (flightIdController.text.isEmpty || 
        status == null || // Verifica si el estado está seleccionado
        bookingDateController.text.isEmpty) {
      _showSnackBar("Por favor, llene todos los campos.");
      return;
    }

    try {
      String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/update_reservation.php";

      var res = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": widget.id,
          "flight_id": int.parse(flightIdController.text),
          "status": status,
          "booking_date": bookingDateController.text,
        }),
      );

      var response = jsonDecode(res.body);

      if (response["success"] == "true") {
        _showSnackBar("Registro actualizado correctamente");
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewReservations()),
        );
      } else {
        _showSnackBar("Error al actualizar el registro: ${response['error']}");
      }
    } catch (e) {
      print("Error: $e");
      _showSnackBar("Error en la conexión con el servidor");
    }
  }

  void confirmUpdate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Actualización"),
          content: Text("¿Está seguro de que desea actualizar el registro?"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: Text("Confirmar"),
              onPressed: () {
                Navigator.of(context).pop(); 
                updateRecord();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actualizar Reserva')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: flightIdController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ingrese el ID del Vuelo',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: status,
              onChanged: (String? newValue) {
                setState(() {
                  status = newValue; // Actualiza el estado seleccionado
                });
              },
              items: ['confirmed', 'cancelled'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Seleccione el estado',
              ),
              hint: Text('Seleccione el Estado'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: bookingDateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ingrese la fecha de reserva (YYYY-MM-DD HH:MM:SS)',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: confirmUpdate, 
              child: Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}