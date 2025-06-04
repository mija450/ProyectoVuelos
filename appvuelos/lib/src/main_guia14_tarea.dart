import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'viewUsers.dart';
import 'registration_screen.dart';
import 'flight_registration.dart';
import 'reservation_registration.dart';
import 'airport_registration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Pasajeros y Reserva de Vuelos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.airplanemode_active),
            SizedBox(width: 10),
            Text("Registro de Vuelos"),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildButtonWithImage(
                context,
                "Registrar Usuario",
                RegistrationScreen(),
                'assets/images/usuario.png',
              ),
              _buildButtonWithImage(
                context,
                "Registrar Aeropuerto",
                MyApp(),
                'assets/images/vuelo.png',
              ),
              _buildButtonWithImage(
                context,
                "Registrar Vuelo",
                MyApp(),
                'assets/images/aeropuerto.png',
              ),
              _buildButtonWithImage(
                context,
                "Registrar Reserva",
                ReservationRegistration(),
                'assets/images/reserva.png',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonWithImage(BuildContext context, String text, Widget targetScreen, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image.asset(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => targetScreen),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}

class RegistrationScreen extends StatelessWidget {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  RegistrationScreen({super.key});

  void insertRecord() {
    // Lógica para insertar en la base de datos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Pasajeros'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/usuario.png',
                width: 250,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ingrese el nombre",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ingrese el email",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ingrese el password",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: insertRecord,
                child: Text("Insertar"),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => view_data(),
                    ),
                  );
                },
                child: Text('Mostrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
