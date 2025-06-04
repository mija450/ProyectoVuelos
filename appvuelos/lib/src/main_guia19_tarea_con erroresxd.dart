import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'reservas.dart';
import 'pasajeros.dart';
import 'vuelos.dart';
import 'aeropuertos.dart';
import 'viewAirports3.dart';
import 'viewReservations3.dart';
import 'viewFlights3.dart';
import 'viewusers4.dart';

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
                Icon(Icons.account_circle, size: 80, color: Colors.white),
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
                    MaterialPageRoute(builder: (context) => ViewReservations()),
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
  
  get context => null;

  void insertFlight() {
    
    print("Vuelo insertado con éxito");
    
    flightNumberController.clear();
    departureAirportIdController.clear();
    arrivalAirportIdController.clear();
    departureTimeController.clear();
    arrivalTimeController.clear();
    priceController.clear();
    seatsAvailableController.clear();
    airlineIdController.clear();
  }

  Future<void> _selectDateTime(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        controller.text = dateTime.toIso8601String(); 
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
                onPressed: insertFlight,
                child: Text("Insertar"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewFlightHistory()), 
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
      String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_reservation.php";
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