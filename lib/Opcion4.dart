import 'package:flutter/material.dart';

void main() {
  runApp(const Opcion4());
}

class Opcion4 extends StatelessWidget {
  const Opcion4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opción 4'),
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