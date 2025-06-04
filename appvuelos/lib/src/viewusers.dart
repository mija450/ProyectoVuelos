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

  @override
  void initState() {
    super.initState();
    getrecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PASAJEROS REGISTRADOS")),
      body: ListView.builder(
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
            ), 
          );
        },
      ),
    );
  }
}