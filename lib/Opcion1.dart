import 'package:flutter/material.dart';

/// Pantalla principal que muestra una lista de tarjetas de días de la semana.
class Opcion1 extends StatelessWidget {
  const Opcion1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario')),
      body: const CardList(), // Componente modularizado
      backgroundColor: Colors.white,
    );
  }
}

/// Componente que muestra una lista de tarjetas para cada día de la semana.
/// También contiene listas de valores asociados a cada día (aunque actualmente no se usan visualmente).
class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    // Valores de ejemplo por día de la semana
    final List<int> listCar = [5, 4, 3, 2, 8, 0, 1];
    final List<int> listMidi = [2, 8, 0, 1, 5, 4, 3];
    final List<int> listMax = [5, 4, 10, 2, 8, 0, 3];

    // Nombres de los días de la semana
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
        return DayCard(
          day: diasSemana[index],
          carValue: listCar[index],
          midiValue: listMidi[index],
          maxValue: listMax[index],
        );
      },
    );
  }
}

/// Tarjeta individual que representa un día y sus valores asociados.
class DayCard extends StatelessWidget {
  final String day;
  final int carValue;
  final int midiValue;
  final int maxValue;

  //permite que cada targeta sea autonoma
  const DayCard({
    super.key,
    required this.day,
    required this.carValue,
    required this.midiValue,
    required this.maxValue,
  });

  // Función para determinar el color según el valor
  Color getColor(int value) {
    if (value < 5) {
      return Colors.red;
    } else if (value >= 5 && value <= 7) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                day,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Primer grupo: "car" + círculo
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('car', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Circle(number: carValue, color: getColor(carValue)),
              ],
            ),
            const SizedBox(width: 16),
            // Segundo grupo: "midi" + círculo
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('midi', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Circle(number: midiValue, color: getColor(midiValue)),
              ],
            ),
            const SizedBox(width: 16),
            // Tercer grupo: "max" + círculo
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('max', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Circle(number: maxValue, color: getColor(maxValue)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Círculo con número centrado.
/// Se utiliza para mostrar valores como pequeños indicadores visuales.
class Circle extends StatelessWidget {
  final int number;
  final Color color;

  const Circle({super.key, required this.number, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
