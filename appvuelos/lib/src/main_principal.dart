import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'comunicacion_screen.dart';
import 'aprendizaje_screen.dart';
import 'tareas_screen.dart';
import 'eventos_screen.dart';
import 'recursos_screen.dart';
import 'perfil_screen.dart';
import 'configuracion_screen.dart';

void main() {
  runApp(ColegioApp());
}

class ColegioApp extends StatefulWidget {
  const ColegioApp({super.key});

  @override
  _ColegioAppState createState() => _ColegioAppState();
}

class _ColegioAppState extends State<ColegioApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Comunicación y Aprendizaje',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/comunicacion': (context) => ComunicacionScreen(),
        '/aprendizaje': (context) => AprendizajeScreen(),
        '/tareas': (context) => TareasScreen(),
        '/eventos': (context) => EventosScreen(),
        '/recursos': (context) => RecursosScreen(),
        '/perfil': (context) => PerfilScreen(),
        '/configuracion': (context) => ConfiguracionScreen(
              isDarkMode: _isDarkMode,
              onThemeChanged: (value) {
                setState(() {
                  _isDarkMode = value; // Cambia el estado del modo oscuro
                });
              },
            ),
      },
    );
  }
}