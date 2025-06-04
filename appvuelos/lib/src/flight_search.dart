import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FlightSearch extends StatefulWidget {
  const FlightSearch({super.key});

  @override
  _FlightSearchState createState() => _FlightSearchState();
}

class _FlightSearchState extends State<FlightSearch> {
  TextEditingController flightNumberController = TextEditingController();
  List<dynamic> searchResults = [];

  Future<void> searchFlights() async {
    String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/search_flights.php"; 
    try {
      var response = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "flight_number": flightNumberController.text,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success'] == true) {
          setState(() {
            searchResults = jsonResponse['data']; 
          });
        } else {
          _showSnackBar("Error: ${jsonResponse['error']}");
        }
      } else {
        _showSnackBar("Error al buscar vuelos.");
      }
    } catch (e) {
      print("Error fetching flights: $e");
      _showSnackBar("Error al buscar vuelos: $e");
    }
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
        title: Text("Buscar Vuelos"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: flightNumberController,
                decoration: InputDecoration(labelText: 'Número de Vuelo'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: searchFlights,
                child: Text("Buscar Vuelos"),
              ),
              SizedBox(height: 20),
              
              if (searchResults.isNotEmpty) ...[
                Text("Resultados de la búsqueda:", style: TextStyle(fontSize: 18)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    var flight = searchResults[index];
                    return ListTile(
                      title: Text("Vuelo: ${flight['flight_number']}"),
                      subtitle: Text("Salida: ${flight['departure_time']}, Llegada: ${flight['arrival_time']}"),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}