import 'package:flutter/material.dart';

class Opcion1 extends StatelessWidget {
  const Opcion1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Calendario')),
        body: const CardListExample(),
      backgroundColor: Colors.white,
    );
  }
}

class CardListExample extends StatelessWidget {
  const CardListExample({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> diasSemana = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];

    return ListView.builder(
      itemCount: diasSemana.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  diasSemana[index],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: const [
                    Circle(color: Colors.red),
                    SizedBox(width: 8),
                    Circle(color: Colors.yellow),
                    SizedBox(width: 8),
                    Circle(color: Colors.green),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget para un círculo de color
class Circle extends StatelessWidget {
  final Color color;

  const Circle({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
