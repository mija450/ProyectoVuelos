import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CambioVuelos extends StatefulWidget {
  final int userId;

  const CambioVuelos({super.key, required this.userId});

  @override
  _CambioVuelosState createState() => _CambioVuelosState();
}

class _CambioVuelosState extends State<CambioVuelos> {
  List flights = [];
  List userBookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserBookings();
    fetchAvailableFlights();
  }

  void fetchUserBookings() async {
    // Cambia la URL según tu implementación
    var url = Uri.parse("http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/user_bookings.php?user_id=${widget.userId}");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        userBookings = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar reservas del usuario")),
      );
    }
  }

  void fetchAvailableFlights() async {
    var url = Uri.parse("http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/flights2.php");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        flights = json.decode(response.body);
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar vuelos disponibles")),
      );
    }
  }

  void changeFlight(int oldFlightId, int newFlightId) async {
    // Cambia la URL según tu implementación
    var url = Uri.parse("http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/change_flight.php");
    var response = await http.post(url, body: {
      "user_id": widget.userId.toString(),
      "old_flight_id": oldFlightId.toString(),
      "new_flight_id": newFlightId.toString(),
    });

    var data = json.decode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(data["message"])),
    );

    // Volver a cargar las reservas después de la modificación
    fetchUserBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cambiar Vuelo"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: userBookings.length,
                    itemBuilder: (context, index) {
                      var booking = userBookings[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text("Vuelo: ${booking["flight_number"]}"),
                          subtitle: Text("Origen: ${booking["departure_airport"]} - Destino: ${booking["arrival_airport"]}"),
                          trailing: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Seleccionar nuevo vuelo"),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        itemCount: flights.length,
                                        itemBuilder: (context, flightIndex) {
                                          var flight = flights[flightIndex];
                                          return ListTile(
                                            title: Text("Vuelo: ${flight["flight_number"]}"),
                                            onTap: () {
                                              changeFlight(booking["flight_id"], flight["id"]);
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text("Cancelar"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text("Cambiar"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}