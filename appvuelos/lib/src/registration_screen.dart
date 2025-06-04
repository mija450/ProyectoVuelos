import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'viewusers4.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Pasajeros',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserRegistration(),
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
      String email = emailController.text;

      // Validar el correo electrónico
      if (!email.endsWith('@gmail.com') && !email.endsWith('@hotmail.com')) {
        _showSnackbar(context, "El correo debe ser @gmail.com o @hotmail.com");
        return;
      }

      try {
        String uri = "http://127.0.0.1/ProyectoVuelos/appvuelos/lib/src/insert_user.php";
        var res = await http.post(Uri.parse(uri), body: {
          "name": nameController.text,
          "email": email,
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