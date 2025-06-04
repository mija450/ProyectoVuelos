import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewReservations extends StatefulWidget {
  const ViewReservations({super.key});

  @override
  State<ViewReservations> createState() => _ViewReservationsState();
}

class _ViewReservationsState extends State<ViewReservations> {
  List<dynamic> reservationsData = [];

  Future<void> getReservations() async {
    String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/view_Reservations.php"; 
    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        setState(() {
          reservationsData = jsonDecode(response.body);
        });
      } else {
        throw Exception("Error en la carga de datos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar las reservas")),
      );
    }
  }

  Future<void> delReservationRecord(String id, int index) async {
    try {
      String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/delete_reservation.php"; 
      var res = await http.post(Uri.parse(uri), body: {"id": id});
      var response = jsonDecode(res.body);
      if (response["success"] == "true") {
        setState(() {
          reservationsData.removeAt(index); 
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Reserva eliminada correctamente")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar la reserva")),
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
          content: Text("¿Estás seguro de que deseas eliminar esta reserva?"),
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
                delReservationRecord(id, index); 
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
    getReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reservas")),
      body: reservationsData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: reservationsData.length,
              itemBuilder: (context, index) {
                String bookingId = reservationsData[index]["id"].toString();
                String flightId = reservationsData[index]["flight_id"].toString();
                String status = reservationsData[index]["status"];
                String bookingDate = reservationsData[index]["booking_date"];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: status == 'confirmed' ? Colors.green : Colors.red,
                      child: Text(
                        status.isNotEmpty ? status[0].toUpperCase() : "?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    title: Text("Reservación $bookingId"),
                    subtitle: Text("Vuelo: $flightId\nFecha: $bookingDate\nEstado: $status"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        confirmDelete(bookingId, index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}