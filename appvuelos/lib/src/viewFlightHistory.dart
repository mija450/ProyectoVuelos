import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class View_Flight_History extends StatefulWidget {
  const View_Flight_History({super.key});

  @override
  State<View_Flight_History> createState() => _View_Flight_HistoryState();
}

class _View_Flight_HistoryState extends State<View_Flight_History> {
  List<dynamic> flightHistoryData = [];

  Future<void> getFlightHistory() async {
    String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/view_flight_history.php"; 
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
      String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/delete_flight_history.php"; 
      var res = await http.post(Uri.parse(uri), headers: {"Content-Type": "application/json"}, body: jsonEncode({"id": id}));
      var response = jsonDecode(res.body);
      if (response["success"] == true) {
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
                String flightCode = flightHistoryData[index]["codigo_vuelo"];
                String status = flightHistoryData[index]["estado"];
                String changeTime = flightHistoryData[index]["cambio_hora"];
                String reason = flightHistoryData[index]["razon"];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Código de Vuelo: $flightCode"),
                    subtitle: Text(
                      "Estado: $status\nCambio de Hora: $changeTime\nRazón: $reason",
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        confirmDelete(flightId, index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}