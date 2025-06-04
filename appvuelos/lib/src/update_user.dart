import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'viewusers3.dart';

class update_user extends StatefulWidget {
  final String id;
  final String name;
  final String email;

  const update_user(this.id, this.name, this.email, {super.key});

  @override
  State<update_user> createState() => _update_userState();
}

class _update_userState extends State<update_user> {
  TextEditingController id_user = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  Future<void> updateRecord() async {
    try {
      String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/update_users.php";

      var res = await http.post(Uri.parse(uri), body: {
        "id_user": id_user.text,
        "name": name.text,
        "email": email.text,
      });

      var response = jsonDecode(res.body);

      if (response["success"] == "true") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registro actualizado correctamente")),
        );

        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => view_data()),
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
    id_user.text = widget.id;
    name.text = widget.name;
    email.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actualizar Pasajero')),
      body: Column(children: [
        Container(
          margin: EdgeInsets.all(10),
          child: TextFormField(
            controller: name,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingrese el nombre',
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: TextFormField(
            controller: email,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingrese el email',
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