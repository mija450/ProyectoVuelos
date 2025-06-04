import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'viewAirports3.dart';
import 'viewFlights3.dart';
import 'viewReservations3.dart';
import 'flight_registration.dart';
import 'reservation_registration.dart';
import 'airport_registration.dart';
import 'viewusers4.dart';
import 'update_user.dart';

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
            _buildButton(context, "Registrar Pasajeros", UserRegistration(), 'assets/images/usuario.png'),
            _buildButton(context, "Registrar Aeropuerto", AirportRegistration(), 'assets/images/aeropuerto.png'),
            _buildButton(context, "Registrar Vuelo", FlightManagement(), 'assets/images/vuelo.png'),
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

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> insertRecord(BuildContext context) async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      try {
        String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_user.php";
        var res = await http.post(Uri.parse(uri), body: {
          "name": nameController.text,
          "email": emailController.text,
          "password": passwordController.text
        });
        var response = jsonDecode(res.body);

        if (response["success"] == "true") {
          _showSnackbar(context, "Registro insertado con éxito");
          nameController.clear();
          emailController.clear();
          passwordController.clear();
        } else {
          _showSnackbar(context, "Error al insertar el registro");
        }
      } catch (e) {
        _showSnackbar(context, "Error: $e");
      }
    } else {
      _showSnackbar(context, "Por favor, llene todos los campos");
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Pasajeros')),
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
                    image: AssetImage('assets/images/usuario.png'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ingrese el nombre",
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ingrese el email",
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ingrese el password",
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => insertRecord(context),
                child: Text("Insertar"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => view_data()),
                  );
                },
                child: Text("Mostrar Usuarios"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlightManagement extends StatefulWidget {
  const FlightManagement({super.key});

  @override
  _FlightManagementState createState() => _FlightManagementState();
}

class _FlightManagementState extends State<FlightManagement> {
  List<dynamic> flightsData = [];
  TextEditingController flightNumberController = TextEditingController();
  TextEditingController departureAirportIdController = TextEditingController();
  TextEditingController arrivalAirportIdController = TextEditingController();
  TextEditingController departureTimeController = TextEditingController();
  TextEditingController arrivalTimeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController seatsAvailableController = TextEditingController();
  TextEditingController airlineIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getFlights();
  }

  Future<void> getFlights() async {
    String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/view_flights.php";
    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        setState(() {
          flightsData = jsonDecode(response.body);
        });
      } else {
        _showSnackBar("Error al cargar los vuelos.");
      }
    } catch (e) {
      print("Error fetching flights: $e");
      _showSnackBar("Error al cargar los vuelos: $e");
    }
  }

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
          getFlights(); 
        } else {
          _showSnackBar("Error: ${response['error']}");
        }
      } catch (e) {
        _showSnackBar("Error al insertar el vuelo: $e");
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
      if (response.statusCode == 200) {
        setState(() {
          userdata = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al cargar los registros")),
        );
      }
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => update_user(
                                  userdata[index]["id"],
                                  userdata[index]["name"],
                                  userdata[index]["email"],
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            confirmDelete(
                                userdata[index]["id"].toString(), index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  } 
}