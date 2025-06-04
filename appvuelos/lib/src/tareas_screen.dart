import 'package:flutter/material.dart';

class TareasScreen extends StatelessWidget {
  const TareasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tareas Pendientes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildTaskItem('Tarea 1', 'Descripción de la tarea 1'),
                  _buildTaskItem('Tarea 2', 'Descripción de la tarea 2'),
                  _buildTaskItem('Tarea 3', 'Descripción de la tarea 3'),
                  // Agrega más tareas aquí
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String title, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Icon(Icons.check_circle_outline),
      ),
    );
  }
}
