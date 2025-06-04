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
    String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/view_Reservations.php"; // Cambia esta URL si es necesario
    try {
      var response = await http.get(Uri.parse(uri));
      setState(() {
        reservationsData = jsonDecode(response.body);
      });
    } catch (e) {
      print(e);
    }
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
      body: ListView.builder(
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
            ),
          );
        },
      ),
    );
  }
}
