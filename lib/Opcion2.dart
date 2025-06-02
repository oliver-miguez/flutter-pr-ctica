import 'package:flutter/material.dart';

void main() {
  runApp(const Opcion2());
}

class Opcion2 extends StatelessWidget {
  const Opcion2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opción 2'),
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