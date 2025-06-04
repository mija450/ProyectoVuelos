import 'package:flutter/material.dart';

class ConfiguracionScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const ConfiguracionScreen({super.key, required this.isDarkMode, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Opciones de Configuración',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildSwitchTile('Notificaciones', true),
            _buildSwitchTile('Modo Oscuro', isDarkMode, (newValue) {
              onThemeChanged(
                  newValue); // Llama a la función para cambiar el tema
            }),
            _buildSwitchTile('Ubicación', true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para guardar la configuración
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value,
      [ValueChanged<bool>? onChanged]) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged ?? (bool newValue) {},
    );
  }
}
