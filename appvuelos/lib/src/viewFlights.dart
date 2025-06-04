import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewFlightHistory extends StatefulWidget {
  const ViewFlightHistory({super.key});

  @override
  State<ViewFlightHistory> createState() => _ViewFlightHistoryState();
}

class _ViewFlightHistoryState extends State<ViewFlightHistory> {
  List<dynamic> flightHistoryData = [];

  Future<void> getFlightHistory() async {
    String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/view_Flights.php"; 
    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        setState(() {
          flightHistoryData = jsonDecode(response.body);
        });
      } else {
        throw Exception("Error en la carga de datos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar los vuelos")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getFlightHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historial de Vuelos")),
      body: flightHistoryData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: flightHistoryData.length,
              itemBuilder: (context, index) {
                String flightId = flightHistoryData[index]["id"].toString();
                String flightNumber = flightHistoryData[index]["flight_number"];
                String departureTime = flightHistoryData[index]["departure_time"];
                String arrivalTime = flightHistoryData[index]["arrival_time"];
                String price = flightHistoryData[index]["price"].toString();

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blue,
                      child: Text(
                        flightNumber.isNotEmpty ? flightNumber[0].toUpperCase() : "?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    title: Text("Vuelo: $flightNumber"),
                    subtitle: Text(
                      "ID: $flightId\nSalida: $departureTime\nLlegada: $arrivalTime\nPrecio: \$$price",
                    ),
                  ),
                );
              },
            ),
    );
  }
}