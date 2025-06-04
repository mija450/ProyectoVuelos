import 'package:flutter/material.dart';

class AprendizajeScreen extends StatelessWidget {
  const AprendizajeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aprendizaje'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            Text(
              'Bienvenido a la sección de Aprendizaje',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),


            Text(
              '📚 Recursos Educativos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.book, color: Colors.blue),
                title: Text('Matemáticas Básicas'),
                subtitle:
                    Text('Explora conceptos clave como álgebra y geometría.'),
                trailing: Icon(Icons.arrow_forward, color: Colors.grey),
                onTap: () {
      
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResourceDetailScreen(
                        title: 'Matemáticas Básicas',
                        content:
                            'En esta sección aprenderás álgebra, geometría, fracciones y mucho más.',
                      ),
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.language, color: Colors.green),
                title: Text('Aprender Inglés'),
                subtitle:
                    Text('Recursos para mejorar tu gramática y vocabulario.'),
                trailing: Icon(Icons.arrow_forward, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResourceDetailScreen(
                        title: 'Aprender Inglés',
                        content:
                            'Aquí encontrarás guías de gramática, ejercicios de vocabulario y audios para mejorar tu pronunciación.',
                      ),
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.science, color: Colors.orange),
                title: Text('Ciencias Naturales'),
                subtitle:
                    Text('Descubre experimentos y conceptos científicos.'),
                trailing: Icon(Icons.arrow_forward, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResourceDetailScreen(
                        title: 'Ciencias Naturales',
                        content:
                            'Explora el mundo de la biología, la física y la química con actividades prácticas y experimentos.',
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),

 
            Text(
              '🎮 Actividades Interactivas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()),
                );
              },
              icon: Icon(Icons.quiz),
              label: Text('Iniciar Quiz'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
              },
              icon: Icon(Icons.games),
              label: Text('Juegos Educativos'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResourceDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  const ResourceDetailScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz de Aprendizaje'),
      ),
      body: Center(
        child: Text(
          'Aquí estará el quiz interactivo.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
