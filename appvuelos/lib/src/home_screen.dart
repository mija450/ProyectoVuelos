import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comunicación y Aprendizaje'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildFeatureCard(
                    context,
                    'Comunicación',
                    Icons.chat,
                    Colors.blue,
                    '/comunicacion',
                  ),
                  _buildFeatureCard(
                    context,
                    'Aprendizaje',
                    Icons.school,
                    Colors.green,
                    '/aprendizaje',
                  ),
                  _buildFeatureCard(
                    context,
                    'Tareas',
                    Icons.assignment,
                    Colors.orange,
                    '/tareas',
                  ),
                  _buildFeatureCard(
                    context,
                    'Eventos',
                    Icons.event,
                    Colors.purple,
                    '/eventos',
                  ),
                  _buildFeatureCard(
                    context,
                    'Recursos',
                    Icons.library_books,
                    Colors.teal,
                    '/recursos',
                  ),
                  _buildFeatureCard(
                    context,
                    'Perfil',
                    Icons.person,
                    Colors.red,
                    '/perfil',
                  ),
                  _buildFeatureCard(
                    context,
                    'Configuración',
                    Icons.settings,
                    Colors.brown,
                    '/configuracion',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon,
      Color color, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        color: color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
