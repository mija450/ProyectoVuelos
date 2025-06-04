import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewAirports extends StatefulWidget {
  const ViewAirports({super.key});

  @override
  State<ViewAirports> createState() => _ViewAirportsState();
}

class _ViewAirportsState extends State<ViewAirports> {
  List<dynamic> airportsData = [];

  Future<void> getAirports() async {
    String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/view_Airports.php"; 
    try {
      var response = await http.get(Uri.parse(uri));
      setState(() {
        airportsData = jsonDecode(response.body);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getAirports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AEROPUERTOS REGISTRADOS")),
      body: ListView.builder(
        itemCount: airportsData.length,
        itemBuilder: (context, index) {
          String airportName = airportsData[index]["name"];
          String city = airportsData[index]["city"];
          String country = airportsData[index]["country"];
          String code = airportsData[index]["code"] ?? "N/A";

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue,
                child: Text(
                  airportName.isNotEmpty ? airportName[0].toUpperCase() : "?",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              title: Text(airportName),
              subtitle: Text("Ciudad: $city\nPaís: $country\nCódigo: $code"),
            ),
          );
        },
      ),
    );
  }
}