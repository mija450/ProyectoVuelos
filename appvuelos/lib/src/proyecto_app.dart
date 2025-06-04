import 'package:flutter/material.dart';

void main() {
  runApp(ColegioApp());
}

class ColegioApp extends StatelessWidget {
  const ColegioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colegio App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/communication': (context) => CommunicationScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Colegio App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bienvenido a la App del Colegio',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/communication');
              },
              child: Text('Ir a Comunicación'),
            ),
          ],
        ),
      ),
    );
  }
}

class CommunicationScreen extends StatelessWidget {
  const CommunicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comunicación'),
      ),
      body: Center(
        child: Text('Pantalla de Comunicación'),
      ),
    );
  }
}
