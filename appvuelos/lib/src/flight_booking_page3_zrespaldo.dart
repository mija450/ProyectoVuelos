import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlightBookingPage extends StatefulWidget {
  final int userId;

  const FlightBookingPage({super.key, required this.userId});

  @override
  _FlightBookingPageState createState() => _FlightBookingPageState();
}

class _FlightBookingPageState extends State<FlightBookingPage> {
  List flights = [];
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    fetchFlights();
  }

  // Método para obtener vuelos desde el servidor
  void fetchFlights() async {
    try {
      var url = Uri.parse("http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/flights2.php");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          flights = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Error al obtener vuelos");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar vuelos: $e")),
      );
    }
  }

  // Método para reservar un vuelo
  void reserveFlight(int flightId) async {
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

                var url = Uri.parse("http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/reserve.php");
                var response = await http.post(url, body: {
                  "user_id": widget.userId.toString(),
                  "flight_id": flightId.toString(),
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
        title: const Text(
          "Vuelos disponibles",
          style: TextStyle(color: Colors.yellow), // Texto amarillo
        ),
        backgroundColor: const Color(0xFF212121), // AppBar gris oscuro
        iconTheme: const IconThemeData(color: Colors.yellow), // Icono de retroceso amarillo
      ),
      backgroundColor: const Color(0xFF121212), // Fondo gris oscuro
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.yellow)) // Indicador de carga
          : flights.isEmpty
              ? const Center(
                  child: Text(
                    "No hay vuelos disponibles",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      var flight = flights[index];

                      // Convertir el campo "id" a int para evitar errores
                      int flightId = int.tryParse(flight["id"].toString()) ?? 0;

                      return Card(
                        color: const Color(0xFF424242), // Gris más claro para las tarjetas
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(
                            Icons.airplanemode_active, // Icono de avión
                            color: Colors.white, // Color blanco para el icono
                          ),
                          title: Text(
                            "Vuelo: ${flight["flight_number"]}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Texto blanco
                            ),
                          ),
                          subtitle: Text(
                            "Origen: ${flight["departure_airport"]} → Destino: ${flight["arrival_airport"]}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => reserveFlight(flightId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Color azul del botón
                            ),
                            child: const Text(
                              "Reservar",
                              style: TextStyle(color: Colors.white), // Texto blanco
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