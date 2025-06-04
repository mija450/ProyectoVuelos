import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class flight_history extends StatefulWidget {
  final int userId;

  const flight_history({super.key, required this.userId});

  @override
  _flight_historyState createState() => _flight_historyState();
}

class _flight_historyState extends State<flight_history> {
  List flights = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchflight_history();
  }

  void fetchflight_history() async {
    try {
      var url = Uri.parse("http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_historial_vuelo.php");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          flights = json.decode(response.body);
          isLoading = false;
        }); 
      } else {
        throw Exception("Error al obtener el historial de vuelos");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar el historial: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Vuelos"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : flights.isEmpty
              ? const Center(child: Text("No hay vuelos en el historial."))
              : ListView.builder(
                  itemCount: flights.length,
                  itemBuilder: (context, index) {
                    var flight = flights[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text("Vuelo: ${flight["flight_history"]}"),
                        subtitle: Text("Origen: ${flight["departure_airport"]} - Destino: ${flight["arrival_airport"]}"),
                        trailing: Text("Fecha: ${flight["date"]}"),
                      ),
                    );
                  },
                ),
    );
  }
}