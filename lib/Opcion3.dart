import 'package:flutter/material.dart';

void main() {
  runApp(const Opcion3());
}

class Opcion3 extends StatelessWidget {
  const Opcion3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opción 3'),
        // No necesitas agregar nada más, la flecha aparecerá sola
      ),
      body: const Center(
        child: Text(
          'Hola Mundo',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}