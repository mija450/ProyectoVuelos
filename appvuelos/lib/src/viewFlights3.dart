import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:appvuelos/src/update_flight.dart';
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

  Future<void> delFlightRecord(String id, int index) async {
    try {
      String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/delete_flights.php"; 
      var res = await http.post(Uri.parse(uri), body: {"id": id});
      var response = jsonDecode(res.body);
      if (response["success"] == "true") {
        setState(() {
          flightHistoryData.removeAt(index); 
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Vuelo eliminado correctamente")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar el vuelo")),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en la conexión con el servidor")),
      );
    }
  }

  void confirmDelete(String id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text("¿Estás seguro de que deseas eliminar este vuelo?"),
          actions: [
            TextButton(
              child: Text("No", style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: Text("Sí", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                delFlightRecord(id, index); 
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateFlight(
                                  id: flightId,
                                  flightNumber: flightNumber,
                                  departureTime: departureTime,
                                  arrivalTime: arrivalTime,
                                  price: price,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            confirmDelete(flightId, index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}