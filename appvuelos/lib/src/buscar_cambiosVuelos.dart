import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BuscarCambiosVuelo extends StatefulWidget {
  const BuscarCambiosVuelo({super.key});

  @override
  _BuscarCambiosVueloState createState() => _BuscarCambiosVueloState();
}

class _BuscarCambiosVueloState extends State<BuscarCambiosVuelo> {
  TextEditingController flightNumberController = TextEditingController();
  List<dynamic> searchResults = [];

  Future<void> searchFlights() async {
    String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/buscar_cambios_vuelo.php"; 
    try {
      var response = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "codigo_vuelo": flightNumberController.text,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success'] == true) {
          setState(() {
            searchResults = jsonResponse['data'];
          });
        } else {
          _showSnackBar("Error: ${jsonResponse['error']}");
        }
      } else {
        _showSnackBar("Error al buscar cambios.");
      }
    } catch (e) {
      print("Error fetching flights: $e");
      _showSnackBar("Error al buscar cambios: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar Cambios de Vuelo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: flightNumberController,
                decoration: InputDecoration(labelText: 'Número de Vuelo'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: searchFlights,
                child: Text("Buscar Cambios"),
              ),
              SizedBox(height: 20),
              
              if (searchResults.isNotEmpty) ...[
                Text("Resultados de la búsqueda:", style: TextStyle(fontSize: 18)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    var cambio = searchResults[index];
                    return ListTile(
                      title: Text("Estado: ${cambio['estado']}"),
                      subtitle: Text("Razón: ${cambio['razon']}, Fecha: ${cambio['fecha_creacion']}"),
                    );
                  },
                ),
              ] else if (searchResults.isEmpty) ...[
                Text("No se encontraron cambios para este vuelo."),
              ],
            ],
          ),
        ),
      ),
    );
  }
}