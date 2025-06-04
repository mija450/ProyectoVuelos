import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    var url = Uri.parse("http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/login_user.php");
    try {
      var response = await http.post(url, body: {
        "email": emailController.text,
        "password": passwordController.text,
      });

      print("Response status: ${response.statusCode}"); 
      print("Response body: ${response.body}"); 

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"] == "success") {
          int userId = int.parse(data["user"]["id"].toString());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlightBookingPage(userId: userId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data["message"])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al procesar la respuesta: $e")),
      );
    }
  }

  void navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Accede a reservar",
          style: TextStyle(color: Colors.yellow),
        ),
        backgroundColor: const Color(0xFF121212),
      ),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/img1.png', 
              height: 200,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text("Login", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            const Text(
              '¡Reserva aquí ahora!',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: navigateToRegistration,
              child: const Text('Registrar Usuario', style: TextStyle(color: Colors.black)),
            ),
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
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> insertRecord() async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      try {
        String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_user.php"; 
        var res = await http.post(Uri.parse(uri), body: {
          "name": nameController.text,
          "email": emailController.text,
          "password": passwordController.text,
        });
        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registro insertado correctamente")),
          );
          nameController.clear();
          emailController.clear();
          passwordController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al insertar el registro: ${response['message']}")),
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
      appBar: AppBar(title: Text('Registro de Pasajeros')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/usuario.png', 
              width: 250,
              height: 300,
              fit: BoxFit.cover,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Ingrese el nombre'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Ingrese el email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Ingrese el password'),
            ),
            ElevatedButton(
              onPressed: insertRecord,
              child: Text("Insertar"),
            ),
          ],
        ),
      ),
    );
  }
}

class FlightBookingPage extends StatefulWidget {
  final int userId;

  const FlightBookingPage({super.key, required this.userId});

  @override
  _FlightBookingPageState createState() => _FlightBookingPageState();
}

class _FlightBookingPageState extends State<FlightBookingPage> {
  List flights = [];

  @override
  void initState() {
    super.initState();
    fetchFlights();
  }

  void fetchFlights() async {
    var url = Uri.parse("http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/flights.php");
    var response = await http.get(url);

    try {
      setState(() {
        flights = json.decode(response.body);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar vuelos: $e")),
      );
    }
  }

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
        title: Text(
          "Vuelos disponibles",
          style: TextStyle(
            color: Colors.yellow,
          ),
        ),
        backgroundColor: Color(0xFF212121),
        iconTheme: IconThemeData(
          color: Colors.yellow,
        ),
      ),
      backgroundColor: Color(0xFF212121),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: flights.length,
          itemBuilder: (context, index) {
            var flight = flights[index];

            // Convertir el campo "id" a int para asegurarse de que no genere error
            int flightId = int.tryParse(flight["id"].toString()) ?? 0;

            return Card(
              color: Color(0xFF424242),
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  Icons.airplanemode_active,
                  color: Colors.white,
                ),
                title: Text(
                  "Vuelo: ${flight["flight_number"]}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  "Origen: ${flight["departure_airport"]} → Destino: ${flight["arrival_airport"]}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () => reserveFlight(flightId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    "Reservar",
                    style: TextStyle(color: Colors.white),
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