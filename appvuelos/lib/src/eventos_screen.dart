import 'package:flutter/material.dart';

class EventosScreen extends StatelessWidget {
  const EventosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Eventos Programados',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildEventItem('Evento 1', 'Fecha: 01/01/2024'),
                  _buildEventItem('Evento 2', 'Fecha: 15/01/2024'),
                  _buildEventItem('Evento 3', 'Fecha: 28/01/2024'),
                  // Agrega más eventos aquí
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem(String title, String date) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Icon(Icons.calendar_today),
      ),
    );
  }
}
