import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'viewAirports3.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Aeropuertos',
      home: AirportRegistration(),
    );
  }
}

class AirportRegistration extends StatefulWidget {
  const AirportRegistration({super.key});

  @override
  State<AirportRegistration> createState() => _AirportRegistrationState();
}

class _AirportRegistrationState extends State<AirportRegistration> {
  TextEditingController airportNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  Future<void> insertAirport() async {
    if (airportNameController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        countryController.text.isNotEmpty &&
        codeController.text.isNotEmpty) {
      try {
        String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_airport.php"; 
        var res = await http.post(
          Uri.parse(uri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": airportNameController.text,
            "city": cityController.text,
            "country": countryController.text,
            "code": codeController.text,
          }),
        );

        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registro insertado con éxito")),
          );
          
          airportNameController.clear();
          cityController.clear();
          countryController.clear();
          codeController.clear();
        } else {
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ocurrió un problema al insertar el registro: ${response['error']}")),
          );
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error en la conexión con el servidor")),
        );
      }
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, llene todos los campos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('REGISTRO DE AEROPUERTOS'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/aeropuerto.png',
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: airportNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ingrese el nombre del aeropuerto",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ingrese la ciudad",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: countryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ingrese el país",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: codeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ingrese el código IATA/ICAO",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: insertAirport,
                child: Text("Insertar"),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewAirports()), // Asegúrate de que esta clase exista
                  );
                },
                child: Text('Mostrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}