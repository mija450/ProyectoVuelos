import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'viewFlights3.dart'; 

void main() {
  runApp(Vuelos_Registration());
}

class Vuelos_Registration extends StatelessWidget {
  const Vuelos_Registration({super.key});

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
  List<dynamic> flightsData = [];
  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController departureAirportIdController = TextEditingController();
  final TextEditingController arrivalAirportIdController = TextEditingController();
  final TextEditingController departureTimeController = TextEditingController();
  final TextEditingController arrivalTimeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController seatsAvailableController = TextEditingController();
  final TextEditingController airlineIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getFlights();
  }

  Future<void> getFlights() async {
    const String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/view_flights.php"; 
    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        setState(() {
          flightsData = jsonDecode(response.body);
        });
      } else {
        _showSnackBar("Error al cargar los vuelos.");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> insertFlight() async {
    if (_areFieldsValid()) {
      try {
        DateTime.parse(departureTimeController.text);
        DateTime.parse(arrivalTimeController.text);
      } catch (e) {
        _showSnackBar("Las fechas deben estar en formato YYYY-MM-DDTHH:MM:SS.");
        return;
      }

      const String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_flight.php";
      try {
        var res = await http.post(
          Uri.parse(uri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "flight_number": flightNumberController.text,
            "departure_airport_id": int.parse(departureAirportIdController.text),
            "arrival_airport_id": int.parse(arrivalAirportIdController.text),
            "departure_time": departureTimeController.text,
            "arrival_time": arrivalTimeController.text,
            "price": double.parse(priceController.text),
            "seats_available": int.parse(seatsAvailableController.text),
            "airline_id": int.parse(airlineIdController.text),
          }),
        );

        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          _showSnackBar("Vuelo insertado correctamente");
          _clearFields();
          getFlights(); 
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
    return flightNumberController.text.isNotEmpty &&
           departureAirportIdController.text.isNotEmpty &&
           arrivalAirportIdController.text.isNotEmpty &&
           departureTimeController.text.isNotEmpty &&
           arrivalTimeController.text.isNotEmpty &&
           priceController.text.isNotEmpty &&
           seatsAvailableController.text.isNotEmpty &&
           airlineIdController.text.isNotEmpty &&
           double.tryParse(priceController.text) != null &&
           int.tryParse(seatsAvailableController.text) != null;
  }

  void _clearFields() {
    flightNumberController.clear();
    departureAirportIdController.clear();
    arrivalAirportIdController.clear();
    departureTimeController.clear();
    arrivalTimeController.clear();
    priceController.clear();
    seatsAvailableController.clear();
    airlineIdController.clear();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro y Visualización de Vuelos"),
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/vuelo.png'), 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: flightNumberController,
                decoration: InputDecoration(labelText: 'Ingrese el Número de Vuelo'),
              ),
              TextField(
                controller: departureAirportIdController,
                decoration: InputDecoration(labelText: 'Ingrese el ID del Aeropuerto de Salida'),
              ),
              TextField(
                controller: arrivalAirportIdController,
                decoration: InputDecoration(labelText: 'Ingrese el ID del Aeropuerto de Llegada'),
              ),
              TextField(
                controller: departureTimeController,
                decoration: InputDecoration(
                  labelText: 'Hora de Salida (YYYY-MM-DDTHH:MM:SS)',
                ),
              ),
              TextField(
                controller: arrivalTimeController,
                decoration: InputDecoration(
                  labelText: 'Hora de Llegada (YYYY-MM-DDTHH:MM:SS)',
                ),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Ingrese el Precio'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: seatsAvailableController,
                decoration: InputDecoration(labelText: 'Ingrese Asientos Disponibles'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: airlineIdController,
                decoration: InputDecoration(labelText: 'ID Aerolínea'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: insertFlight,
                child: Text("Insertar"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewFlightHistory()), 
                  );
                },
                child: Text('Mostrar Vuelos'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}