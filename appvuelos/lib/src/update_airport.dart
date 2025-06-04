import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'viewAirports3.dart';

class UpdateAirport extends StatefulWidget {
  final String id;
  final String name;
  final String city;
  final String country;
  final String code;

  const UpdateAirport({super.key, 
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.code,
  });

  @override
  State<UpdateAirport> createState() => _UpdateAirportState();
}

class _UpdateAirportState extends State<UpdateAirport> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  Future<void> updateRecord() async {
    try {
      String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/update_airport.php";

      var res = await http.post(Uri.parse(uri), body: {
        "id": widget.id,
        "name": nameController.text,
        "city": cityController.text,
        "country": countryController.text,
        "code": codeController.text,
      });

      var response = jsonDecode(res.body);

      if (response["success"] == "true") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registro actualizado correctamente")),
        );

        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewAirports()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al actualizar el registro")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en la conexión con el servidor")),
      );
    }
  }

  void confirmUpdate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Actualización"),
          content: Text("¿Está seguro de que desea actualizar el registro?"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirmar"),
              onPressed: () {
                Navigator.of(context).pop();
                updateRecord(); 
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
    nameController.text = widget.name;
    cityController.text = widget.city;
    countryController.text = widget.country;
    codeController.text = widget.code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actualizar Aeropuerto')),
      body: Column(children: [
        Container(
          margin: EdgeInsets.all(10),
          child: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingrese el nombre',
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: TextFormField(
            controller: cityController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingrese la ciudad',
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: TextFormField(
            controller: countryController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingrese el país',
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: TextFormField(
            controller: codeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingrese el código',
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: confirmUpdate,
            child: Text('Actualizar'),
          ),
        ),
      ]),
    );
  }
}