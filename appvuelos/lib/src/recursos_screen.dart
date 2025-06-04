import 'package:flutter/material.dart';

class RecursosScreen extends StatelessWidget {
  const RecursosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recursos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recursos de Estudio',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildResourceItem(
                      'Libro de Matemáticas', 'URL: www.libromatematicas.com'),
                  _buildResourceItem(
                      'Guía de Historia', 'URL: www.guiadehistoria.com'),
                  _buildResourceItem('Curso de Programación',
                      'URL: www.cursodeprogramacion.com'),
                  // Agrega más recursos aquí
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem(String title, String url) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(url),
        trailing: Icon(Icons.link),
        onTap: () {
          // Aquí puedes agregar la lógica para abrir el enlace en un navegador
        },
      ),
    );
  }
}
