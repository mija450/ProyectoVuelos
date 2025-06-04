import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class flightbookingpage extends StatefulWidget {
  final int userid;

  const flightbookingpage({super.key, required this.userid});

  @override
  _flightbookingpageState createState() => _flightbookingpageState();
}

class _flightbookingpageState extends State<flightbookingpage> {
  List flights = [];

  @override
  void initState() {
    super.initState();
    fetchflights();
  }

  void fetchflights() async {
    var url = Uri.parse("http://127.0.0.1/ProyectoVuelos/flights.php");
    var response = await http.get(url);

    try {
      setState(() {
        flights = json.decode(response.body);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar vuelos: $e")),
      );
    }
  }

  void reserveflight(int flightid) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación de Reserva"),
          content: Text("¿Estás seguro de que deseas reservar este vuelo?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cierra el diálogo

                var url = Uri.parse("http://127.0.0.1/ProyectoVuelos/reserve.php");
                var response = await http.post(url, body: {
                  "user_id": widget.userid.toString(),
                  "flight_id": flightid.toString(),
                });

                try {
                  var data = json.decode(response.body);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(data["message"])),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error al reservar vuelo: $e")),
                  );
                }
              },
              child: Text("Reservar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vuelos disponibles",
          style: TextStyle(
            color: Colors.yellow,
          ),
        ),
        backgroundColor: Color(0xFF212121),
        iconTheme: IconThemeData(
          color: Colors.yellow,
        ),
      ),
      backgroundColor: Color(0xFF212121),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: flights.length,
          itemBuilder: (context, index) {
            var flight = flights[index];

            // Convertir el campo "id" a int para asegurarse de que no genere error
            int flightid = int.tryParse(flight["id"].toString()) ?? 0;

            return Card(
              color: Color(0xFF424242),
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  Icons.airplanemode_active,
                  color: Colors.white,
                ),
                title: Text(
                  "Vuelo: ${flight["flight_number"]}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  "Origen: ${flight["departure_airport"]} → Destino: ${flight["arrival_airport"]}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () => reserveflight(flightid),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    "Reservar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
      ),
    );
  }
}