import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'viewflights3.dart'; 

class UpdateFlight extends StatefulWidget {
  final String id;
  final String flightNumber;
  final String departureTime;
  final String arrivalTime;
  final String price;

  const UpdateFlight({super.key, 
    required this.id,
    required this.flightNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
  });

  @override
  State<UpdateFlight> createState() => _UpdateFlightState();
}

class _UpdateFlightState extends State<UpdateFlight> {
  TextEditingController flightNumberController = TextEditingController();
  TextEditingController departureTimeController = TextEditingController();
  TextEditingController arrivalTimeController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  Future<void> updateRecord() async {
    try {
      String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/update_flight.php";

      var res = await http.post(Uri.parse(uri), body: {
        "id": widget.id,
        "flight_number": flightNumberController.text,
        "departure_time": departureTimeController.text,
        "arrival_time": arrivalTimeController.text,
        "price": priceController.text,
      });

      var response = jsonDecode(res.body);

      if (response["success"] == "true") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registro actualizado correctamente")),
        );

        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewFlightHistory()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al actualizar el registro")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en la conexión con el servidor")),
      );
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

  @override
  void initState() {
    super.initState();
    flightNumberController.text = widget.flightNumber;
    departureTimeController.text = widget.departureTime;
    arrivalTimeController.text = widget.arrivalTime;
    priceController.text = widget.price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actualizar Vuelo')),
      body: Column(children: [
        Container(
          margin: EdgeInsets.all(10),
          child: TextFormField(
            controller: flightNumberController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingrese el número de vuelo',
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: TextFormField(
            controller: departureTimeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingrese la hora de salida',
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: TextFormField(
            controller: arrivalTimeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingrese la hora de llegada',
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingrese el precio',
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: confirmUpdate,
            child: Text('Actualizar'),
          ),
        ),
      ]),
    );
  }
}