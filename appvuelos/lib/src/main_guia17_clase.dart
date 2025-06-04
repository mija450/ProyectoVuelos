import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'viewAirports2.dart';
import 'viewFlights2.dart';
import 'viewReservations2.dart';
import 'viewUsers2.dart';
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
        title: Text("Flight Booking"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Registros",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            _buildButton(context, "Registrar Pasajeros", RegistrationScreen(), 'assets/images/usuario.png'),
            _buildButton(context, "Registrar Aeropuerto", MyApp(), 'assets/images/aeropuerto.png'),
            _buildButton(context, "Registrar Vuelo", MyApp(), 'assets/images/vuelo.png'),
            _buildButton(context, "Registrar Reserva", ReservationRegistration(), 'assets/images/reserva.png'),
            SizedBox(height: 20),
            Text(
              "Visualización de Datos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            _buildButton(context, "Mostrar Usuarios", view_data(), 'assets/images/usuario.png'),
            _buildButton(context, "Mostrar Aeropuertos", ViewAirports(), 'assets/images/aeropuerto.png'),
            _buildButton(context, "Mostrar Reservas", ViewReservations(), 'assets/images/reserva.png'),
            _buildButton(context, "Mostrar Vuelos", ViewFlightHistory(), 'assets/images/vuelo.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Widget targetScreen, String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 24, 
              height: 24,
            ),
            SizedBox(width: 10), 
            Text(text, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> insertRecord() async {
    if (name.text.isNotEmpty && email.text.isNotEmpty && password.text.isNotEmpty) {
      try {
        String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_user.php";
        var res = await http.post(Uri.parse(uri), body: {
          "name": name.text,
          "email": email.text,
          "password": password.text
        });
        var response = jsonDecode(res.body);
        if (response["success"] == "true") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registro insertado correctamente")),
          );
          name.clear();
          email.clear();
          password.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al insertar el registro")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, llene todos los campos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Pasajeros'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              'assets/images/usuario.png',
              width: 250,
              height: 300,
              fit: BoxFit.cover,
            ),
            _buildTextField("Ingrese el nombre", name),
            _buildTextField("Ingrese el email", email),
            _buildTextField("Ingrese el password", password, obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: insertRecord,
              child: Text("Insertar"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}