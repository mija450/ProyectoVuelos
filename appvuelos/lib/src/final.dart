import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pasajeros.dart'; 
import 'vuelos.dart';
import 'aeropuertos.dart';
import 'flight_search.dart';
import 'viewFlights3.dart'; 
import 'reservas.dart';
import 'pasajeros_registration.dart';
import 'flight_registration.dart';
import 'airport_registration.dart';
import 'reservation_registration.dart';

//examen 
import 'cambio_vuelos.dart';
import 'formulario_historial_vuelos.dart';
import 'viewFlightHistory.dart';
import 'buscar_cambiosVuelos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menú Lateral con Submenús',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menú Lateral"),
        backgroundColor: Colors.blueGrey[900],
      ),
      drawer: SideMenu(),
      body: Container(
        color: Color.fromARGB(255, 16, 65, 104),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/img2.png',
              width: 400,
            ),
            SizedBox(height: 20),
            Text(
              "Sistemas de reservas",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey[900],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/reserva.png',
                  width: 70,
                  height: 70,
                ),
                SizedBox(height: 10),
                Text(
                  "Administrador",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  "admin@gmail.com",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.blueGrey),
            title: Text("Inicio"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.flight, color: Colors.blueGrey),
            title: Text("Vuelos"),
            children: [
              ListTile(
                leading: Icon(Icons.bookmark, color: Colors.grey),
                title: Text("Mis Reservas"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.search, color: Colors.grey),
                title: Text("Buscar Vuelos"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FlightSearch()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.flight_takeoff, color: Colors.grey),
                title: Text("Registrar Vuelos"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Vuelos_Registration()),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.people, color: Colors.blueGrey),
            title: Text("PASAJEROS"),
            children: [
              ListTile(
                leading: Icon(Icons.person_add, color: Colors.grey),
                title: Text("Registrar Pasajeros"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pasajeros_Registration()),
                  );
                },
              ),
            ],
          ),
         ExpansionTile(
  leading: Icon(Icons.history, color: Colors.blueGrey),
  title: Text("VER HISTORIAL DE VUELOS"),
  children: [
    ListTile(
      leading: Icon(Icons.search, color: Colors.grey),
      title: Text("ver historial de vuelos"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => View_Flight_History()),
        );
      },
    ),
    ListTile(
      leading: Icon(Icons.search, color: Colors.grey),
      title: Text("formulario_historial_vuelos"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Insert_Flight_History()),
        );
      },
    ),
  ],
),
          ExpansionTile(
        leading: Icon(Icons.history, color: Colors.blueGrey),
        title: Text("VER CAMBIOS DE VUELOS"),
        children: [
        ListTile(
          leading: Icon(Icons.history, color: Colors.grey),
          title: Text("Cambios de Vuelos"),
          onTap: () {
        int userId = 1;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BuscarCambiosVuelo()),
              );
            },
          ),
        ],
      ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text("Cerrar Sesión"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
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

  void loginUser() {
    int userId = 1; 
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightBookingPage(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accede a reservar"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text("Registrar Pasajero", style: TextStyle(color: Colors.white)),
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
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    fetchFlights();
  }

  void fetchFlights() async {
    try {
      var url = Uri.parse("http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/flights2.php");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          flights = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Error al obtener vuelos");
      }
    } catch (e) {
      setState(() => isLoading = false);
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
                Navigator.of(context).pop(); 
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); 

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
        title: const Text(
          "Vuelos disponibles",
          style: TextStyle(color: Colors.yellow), 
        ),
        backgroundColor: const Color(0xFF212121), 
        iconTheme: const IconThemeData(color: Colors.yellow), 
      ),
      backgroundColor: const Color(0xFF121212),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.yellow))
          : flights.isEmpty
              ? const Center(
                  child: Text(
                    "No hay vuelos disponibles",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      var flight = flights[index];

                      int flightId = int.tryParse(flight["id"].toString()) ?? 0;

                      return Card(
                        color: const Color(0xFF424242), 
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(
                            Icons.airplanemode_active, 
                            color: Colors.white,
                          ),
                          title: Text(
                            "Vuelo: ${flight["flight_number"]}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            "Origen: ${flight["departure_airport"]} → Destino: ${flight["arrival_airport"]}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => reserveFlight(flightId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, 
                            ),
                            child: const Text(
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

class FlightRegistration extends StatefulWidget {
  const FlightRegistration({super.key});

  @override
  _FlightRegistrationState createState() => _FlightRegistrationState();
}

class _FlightRegistrationState extends State<FlightRegistration> {
  TextEditingController flightNumberController = TextEditingController();
  TextEditingController departureAirportIdController = TextEditingController();
  TextEditingController arrivalAirportIdController = TextEditingController();
  TextEditingController departureTimeController = TextEditingController();
  TextEditingController arrivalTimeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController seatsAvailableController = TextEditingController();
  TextEditingController airlineIdController = TextEditingController();

  Future<void> insertFlight() async {
    if (flightNumberController.text.isNotEmpty &&
        departureAirportIdController.text.isNotEmpty &&
        arrivalAirportIdController.text.isNotEmpty &&
        departureTimeController.text.isNotEmpty &&
        arrivalTimeController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        seatsAvailableController.text.isNotEmpty &&
        airlineIdController.text.isNotEmpty) {
      
      if (double.tryParse(priceController.text) == null) {
        _showSnackBar("El precio debe ser un número válido.");
        return;
      }

      if (int.tryParse(seatsAvailableController.text) == null) {
        _showSnackBar("Los asientos disponibles deben ser un número entero.");
        return;
      }

      try {
        DateTime.parse(departureTimeController.text);
        DateTime.parse(arrivalTimeController.text);
      } catch (e) {
        _showSnackBar("Las fechas deben estar en formato YYYY-MM-DDTHH:MM:SS.");
        return;
      }

      try {
        String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_flight.php";

        var res = await http.post(
          Uri.parse(uri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "flight_number": flightNumberController.text,
            "departure_airport_id": int.parse(departureAirportIdController.text),
            "arrival_airport_id": int.parse(arrivalAirportIdController.text),
            "departure_time": departureTimeController.text,
            "arrival_time": arrivalTimeController.text,
            "price": double.parse(priceController.text),
            "seats_available": int.parse(seatsAvailableController.text),
            "airline_id": int.parse(airlineIdController.text),
          }),
        );

        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          _showSnackBar("Vuelo insertado correctamente");
          _clearFields();
        } else {
          _showSnackBar("Error: ${response['error']}");
        }
      } catch (e) {
        _showSnackBar("Error: $e");
      }
    } else {
      _showSnackBar("Por favor, llene todos los campos.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _selectDateTime(TextEditingController controller) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (pickedTime != null) {
        setState(() {
          controller.text = "${pickedDate.toIso8601String().substring(0, 10)}T${pickedTime.hour}:${pickedTime.minute}:00";
        });
      }
    }
  }

  void _clearFields() {
    flightNumberController.clear();
    departureAirportIdController.clear();
    arrivalAirportIdController.clear();
    departureTimeController.clear();
    arrivalTimeController.clear();
    priceController.clear();
    seatsAvailableController.clear();
    airlineIdController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Vuelos"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/vuelo.png'), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: flightNumberController,
              decoration: InputDecoration(labelText: 'Número de Vuelo'),
            ),
            TextField(
              controller: departureAirportIdController,
              decoration: InputDecoration(labelText: 'ID Aeropuerto de Salida'),
            ),
            TextField(
              controller: arrivalAirportIdController,
              decoration: InputDecoration(labelText: 'ID Aeropuerto de Llegada'),
            ),
            TextField(
              controller: departureTimeController,
              decoration: InputDecoration(
                labelText: 'Hora de Salida (YYYY-MM-DDTHH:MM:SS)',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDateTime(departureTimeController),
                ),
              ),
              readOnly: true,
            ),
            TextField(
              controller: arrivalTimeController,
              decoration: InputDecoration(
                labelText: 'Hora de Llegada (YYYY-MM-DDTHH:MM:SS)',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDateTime(arrivalTimeController),
                ),
              ),
              readOnly: true,
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: seatsAvailableController,
              decoration: InputDecoration(labelText: 'Asientos Disponibles'),
              keyboardType: TextInputType.number,
              ),
            TextField(
              controller: airlineIdController,
              decoration: InputDecoration(labelText: 'ID Aerolínea'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: insertFlight,
              child: Text("Registrar Vuelo"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewFlightHistory()), 
                );
              },
              child: Text("Mostrar Vuelos"),
            ),
          ],
        ),
      ),
    );
  }
}