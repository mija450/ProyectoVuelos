import 'package:flutter/material.dart';

class ComunicacionScreen extends StatelessWidget {
  const ComunicacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comunicación'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Text(
              'Bienvenido a la sección de Comunicación',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Lista de anuncios
            Text(
              '📢 Anuncios Importantes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.announcement, color: Colors.blue),
                title: Text('Reunión de padres de familia'),
                subtitle: Text('Fecha: 10 de enero, 5:00 PM en el auditorio.'),
              ),
            ),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.green),
                title: Text('Entrega de boletines'),
                subtitle:
                    Text('Fecha: 15 de enero, horario: 8:00 AM - 2:00 PM.'),
              ),
            ),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.sports_basketball, color: Colors.orange),
                title: Text('Inscripciones abiertas para talleres deportivos'),
                subtitle: Text('Consulta en secretaría para más información.'),
              ),
            ),
            SizedBox(height: 20),

            // Formulario de contacto
            Text(
              '✉️ Enviar un mensaje',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ContactForm(),
          ],
        ),
      ),
    );
  }
}

// Widget para el formulario de contacto
class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _mensaje = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Nombre',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu nombre.';
              }
              return null;
            },
            onSaved: (value) {
              _nombre = value!;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Mensaje',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, escribe un mensaje.';
              }
              return null;
            },
            onSaved: (value) {
              _mensaje = value!;
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mensaje enviado por $_nombre')),
                );
              }
            },
            child: Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
