import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'viewusers2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> insertrecord() async {
    if (name.text != "" && email.text != "" && password.text != "") {
      try {
        String uri = "http://127.0.0.1/ProyectoVuelos/insert_user.php";
        var res = await http.post(Uri.parse(uri), body: {
          "name": name.text,
          "email": email.text,
          "password": password.text
        });

        print("Código de respuesta: ${res.statusCode}");
        print("Respuesta: ${res.body}");

        var response = jsonDecode(res.body);
        if (response["success"] == "true") {
          print("Registro insertado correctamente.");
          name.text = "";
          email.text = "";
          password.text = "";
        } else {
          print("Error en la inserción: ${response["error"]}");
        }
      } catch (e) {
        print("Error de conexión: $e");
      }
    } else {
      print("Por favor, llene todos los campos.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('REGISTRO DE PASAJEROS'),
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
                    label: Text("Ingrese el nombre"),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Ingrese el email"),
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
                    label: Text("Ingrese el password"),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    insertrecord();
                  },
                  child: Text("Insertar"),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () {
                        
                        print("Botón presionado, navegando a la nueva página.");

                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => view_data()),
                        );
                      },
                      child: Text("Mostrar"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}