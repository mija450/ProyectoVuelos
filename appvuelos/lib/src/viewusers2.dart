import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class view_data extends StatefulWidget {
  const view_data({super.key});
  @override
  State<view_data> createState() => _view_dataState();
}

class _view_dataState extends State<view_data> {
  List userdata = [];

  Future<void> delrecord(String id, int index) async {
    try {
      String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/delete_user.php";
      var res = await http.post(Uri.parse(uri), body: {"id": id});
      var response = jsonDecode(res.body);
      if (response["success"] == "true") {
        setState(() {
          userdata.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registro eliminado correctamente")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar el registro")),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en la conexión con el servidor")),
      );
    }
  }

  Future<void> getrecord() async {
    String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/view_users.php";
    try {
      var response = await http.get(Uri.parse(uri));
      setState(() {
        userdata = jsonDecode(response.body);
      });
    } catch (e) {
      print(e);
    }
  }

  void confirmDelete(String id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text("¿Estás seguro de que deseas eliminar este registro?"),
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
                delrecord(id, index);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getrecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PASAJEROS REGISTRADOS"),
      ),
      body: userdata.isEmpty
          ? Center(child: Text("No hay pasajeros registrados"))
          : ListView.builder(
              itemCount: userdata.length,
              itemBuilder: (context, index) {
                String name = userdata[index]["name"];
                String initials = name.isNotEmpty
                    ? name
                        .trim()
                        .split(" ")
                        .map((e) => e[0])
                        .take(2)
                        .join()
                        .toUpperCase()
                    : "?";

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blue,
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    title: Text(userdata[index]["name"]),
                    subtitle: Text(userdata[index]["email"]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        confirmDelete(userdata[index]["id"].toString(), index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}