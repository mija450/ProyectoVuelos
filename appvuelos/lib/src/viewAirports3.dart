import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:appvuelos/src/update_airport.dart';
import 'package:http/http.dart' as http;

class ViewAirports extends StatefulWidget {
  const ViewAirports({super.key});

  @override
  State<ViewAirports> createState() => _ViewAirportsState();
}

class _ViewAirportsState extends State<ViewAirports> {
  List<dynamic> airportsData = [];

  Future<void> getAirports() async {
    String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/view_Airports.php"; 
    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        setState(() {
          airportsData = jsonDecode(response.body);
        });
      } else {
        throw Exception("Error en la carga de datos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar los aeropuertos")),
      );
    }
  }

  Future<void> delAirportRecord(String id, int index) async {
    try {
      String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/delete_airports.php"; 
      var res = await http.post(Uri.parse(uri), body: {"id": id});
      var response = jsonDecode(res.body);
      if (response["success"] == "true") {
        setState(() {
          airportsData.removeAt(index); 
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Aeropuerto eliminado correctamente")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar el aeropuerto")),
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
          content: Text("¿Estás seguro de que deseas eliminar este aeropuerto?"),
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
                delAirportRecord(id, index); 
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
    getAirports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AEROPUERTOS REGISTRADOS")),
      body: airportsData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: airportsData.length,
              itemBuilder: (context, index) {
                String airportId = airportsData[index]["id"].toString();
                String airportName = airportsData[index]["name"];
                String city = airportsData[index]["city"];
                String country = airportsData[index]["country"];
                String code = airportsData[index]["code"] ?? "N/A";

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blue,
                      child: Text(
                        airportName.isNotEmpty ? airportName[0].toUpperCase() : "?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    title: Text(airportName),
                    subtitle: Text("Ciudad: $city\nPaís: $country\nCódigo: $code"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateAirport(
                                  id: airportId,
                                  name: airportName,
                                  city: city,
                                  country: country,
                                  code: code,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            confirmDelete(airportId, index);
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