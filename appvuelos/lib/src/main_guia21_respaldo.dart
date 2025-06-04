import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'reservas.dart';
import 'pasajeros.dart';
import 'vuelos.dart';
import 'aeropuertos.dart';
import 'viewAirports3.dart';
import 'viewReservations3.dart';
import 'viewFlights3.dart';
import 'viewusers4.dart';
import 'flight_booking_page3.dart';
import 'flight_search.dart';

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
      theme: ThemeData(primarySwatch: Colors.blue),
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
                Image.asset('assets/images/vuelo.png', width: 80), // Logotipo
                SizedBox(height: 10),
                Text(
                  "Administrador",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  "usuario@email.com",
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
                leading: Icon(Icons.add, color: Colors.grey),
                title: Text("Registrar Vuelo"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FlightRegistration()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.search, color: Colors.grey),
                title: Text("Buscar Vuelos"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReservasApp()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.bookmark, color: Colors.grey),
                title: Text("Mis Reservas"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FlightSearch()),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.airport_shuttle, color: Colors.blueGrey),
            title: Text("Aeropuertos"),
            children: [
              ListTile(
                leading: Icon(Icons.add_location, color: Colors.grey),
                title: Text("Registrar Aeropuertos"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AirportManagement()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.list, color: Colors.grey),
                title: Text("Ver Aeropuertos"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewAirports()),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.book, color: Colors.blueGrey),
            title: Text("Reservas"),
            children: [
              ListTile(
                leading: Icon(Icons.add, color: Colors.grey),
                title: Text("Registrar Reserva"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReservationRegistration()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.list, color: Colors.grey),
                title: Text("Mostrar Reservas"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewReservations()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.airplanemode_active, color: Colors.grey),
                title: Text("Reservar Vuelo"),
                onTap: () {
                  int userId = 1; // Cambia según la lógica de tu app
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FlightBookingPage(userId: userId)),
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
          Divider(), // Añade un divisor para separar las secciones
          ListTile(
            leading: Icon(Icons.login, color: Colors.blue),
            title: Text("Iniciar Sesión"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservasApp()), // Redirige a la página de reservas
              );
            },
          ),
        ],
      ),
    );
  }
}

class FlightRegistration extends StatelessWidget {
  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController departureAirportIdController = TextEditingController();
  final TextEditingController arrivalAirportIdController = TextEditingController();
  final TextEditingController departureTimeController = TextEditingController();
  final TextEditingController arrivalTimeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController seatsAvailableController = TextEditingController();
  final TextEditingController airlineIdController = TextEditingController();

  FlightRegistration({super.key});

  Future<void> insertFlight(BuildContext context) async {
    if (flightNumberController.text.isNotEmpty &&
        departureAirportIdController.text.isNotEmpty &&
        arrivalAirportIdController.text.isNotEmpty &&
        departureTimeController.text.isNotEmpty &&
        arrivalTimeController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        seatsAvailableController.text.isNotEmpty &&
        airlineIdController.text.isNotEmpty) {
      
      if (double.tryParse(priceController.text) == null) {
        _showSnackBar(context, "El precio debe ser un número válido.");
        return;
      }

      if (int.tryParse(seatsAvailableController.text) == null) {
        _showSnackBar(context, "Los asientos disponibles deben ser un número entero.");
        return;
      }

      try {
        DateTime.parse(departureTimeController.text);
        DateTime.parse(arrivalTimeController.text);
      } catch (e) {
        _showSnackBar(context, "Las fechas deben estar en formato YYYY-MM-DDTHH:MM:SS.");
        return;
      }

      try {
        String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_flight.php"; // Cambia la IP aquí

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
          _showSnackBar(context, "Vuelo insertado correctamente");
          flightNumberController.clear();
          departureAirportIdController.clear();
          arrivalAirportIdController.clear();
          departureTimeController.clear();
          arrivalTimeController.clear();
          priceController.clear();
          seatsAvailableController.clear();
          airlineIdController.clear();
        } else {
          _showSnackBar(context, "Error: ${response['error']}");
        }
      } catch (e) {
        _showSnackBar(context, "Error: $e");
      }
    } else {
      _showSnackBar(context, "Por favor, llene todos los campos.");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _selectDateTime(TextEditingController controller, BuildContext context) async {
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
        controller.text = "${pickedDate.toIso8601String().substring(0, 10)}T${pickedTime.hour}:${pickedTime.minute}:00";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro y Visualización de Vuelos"),
      ),
      body: SingleChildScrollView( 
        child: Padding(
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
                decoration: InputDecoration(labelText: 'Ingrese el Número de Vuelo'),
              ),
              TextField(
                controller: departureAirportIdController,
                decoration: InputDecoration(labelText: 'Ingrese el ID del Aeropuerto de Salida'),
              ),
              TextField(
                controller: arrivalAirportIdController,
                decoration: InputDecoration(labelText: 'Ingrese el ID del Aeropuerto de Llegada'),
              ),
              TextField(
                controller: departureTimeController,
                decoration: InputDecoration(
                  labelText: 'Hora de Salida (YYYY-MM-DDTHH:MM:SS)',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDateTime(departureTimeController, context),
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
                    onPressed: () => _selectDateTime(arrivalTimeController, context),
                  ),
                ),
                readOnly: true,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Ingrese el Precio'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: seatsAvailableController,
                decoration: InputDecoration(labelText: 'Ingrese Asientos Disponibles'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: airlineIdController,
                decoration: InputDecoration(labelText: 'ID Aerolínea'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => insertFlight(context),
                child: Text("Insertar"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewFlightHistory()), // Asegúrate de que esta clase exista
                  );
                },
                child: Text('Mostrar Vuelos'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class AirportManagement extends StatefulWidget {
  const AirportManagement({super.key});

  @override
  State<AirportManagement> createState() => _AirportManagementState();
}

class _AirportManagementState extends State<AirportManagement> {
  TextEditingController airportNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  Future<void> insertAirport() async {
    if (airportNameController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        countryController.text.isNotEmpty &&
        codeController.text.isNotEmpty) {
      try {
        String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_airport.php"; 
        var res = await http.post(
          Uri.parse(uri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": airportNameController.text,
            "city": cityController.text,
            "country": countryController.text,
            "code": codeController.text,
          }),
        );

        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registro insertado con éxito")),
          );
          airportNameController.clear();
          cityController.clear();
          countryController.clear();
          codeController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ocurrió un problema al insertar el registro: ${response['error']}")),
          );
        }
      } catch (e) {
        print("Error: $e");
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
        title: Text('REGISTRO DE AEROPUERTOS'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/aeropuerto.png', 
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: airportNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese el nombre del aeropuerto"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese la ciudad"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: countryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese el país"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: codeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese el código IATA/ICAO"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: insertAirport,
                child: Text("Insertar"),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewAirports()), 
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

class ReservationRegistration extends StatefulWidget {
  const ReservationRegistration({super.key});

  @override
  _ReservationRegistrationState createState() => _ReservationRegistrationState();
}

class _ReservationRegistrationState extends State<ReservationRegistration> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController flightIdController = TextEditingController();
  TextEditingController bookingDateController = TextEditingController();
  String? status;

  Future<void> insertReservation() async {
    if (userIdController.text.isEmpty || 
        flightIdController.text.isEmpty || 
        bookingDateController.text.isEmpty || 
        status == null) {
      _showSnackBar("Por favor, llene todos los campos.");
      return;
    }

    try {
      String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_reservation.php"; // Cambia la IP aquí
      var res = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": int.parse(userIdController.text),
          "flight_id": int.parse(flightIdController.text),
          "booking_date": bookingDateController.text,
          "status": status,
        }),
      );

      var response = jsonDecode(res.body);

      if (response["success"] == true) {
        _showSnackBar("Reserva insertada correctamente.");
        userIdController.clear();
        flightIdController.clear();
        bookingDateController.clear();
        setState(() {
          status = null;
        });
      } else {
        _showSnackBar("Error: ${response['error']}");
      }
    } catch (e) {
      _showSnackBar("Error de conexión: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _selectBookingDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        bookingDateController.text = pickedDate.toIso8601String().substring(0, 10); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro de Reserva")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/reserva.png'), 
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: userIdController,
                decoration: InputDecoration(labelText: 'ID del Usuario'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: flightIdController,
                decoration: InputDecoration(labelText: 'ID del Vuelo'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: bookingDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Reserva',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectBookingDate(context),
                  ),
                ),
                readOnly: true,
              ),
              DropdownButtonFormField<String>(
                value: status,
                onChanged: (String? newValue) {
                  setState(() {
                    status = newValue;
                  });
                },
                items: ['confirmed', 'cancelled'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                hint: Text('Seleccione el Estado'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: insertReservation,
                child: Text("Insertar Reserva"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewReservations()), 
                  );
                },
                child: Text("Mostrar Reservas"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Clases para ver aeropuertos, vuelos y reservas
class ViewAirports extends StatelessWidget {
  const ViewAirports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ver Aeropuertos")),
      body: Center(child: Text("Aquí se mostrarán los aeropuertos.")),
    );
  }
}

class ViewFlights extends StatelessWidget {
  const ViewFlights({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ver Vuelos")),
      body: Center(child: Text("Aquí se mostrarán los vuelos.")),
    );
  }
}

class ViewReservations extends StatelessWidget {
  const ViewReservations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ver Reservas")),
      body: Center(child: Text("Aquí se mostrarán las reservas.")),
    );
  }
}

class ReservasApp extends StatelessWidget {
  const ReservasApp({super.key});

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