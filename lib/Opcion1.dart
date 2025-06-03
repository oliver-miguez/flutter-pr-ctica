import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// App principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendario Vehículos',
      home: const Opcion1(),
    );
  }
}

/// Pantalla principal que muestra una lista de tarjetas de días de la semana.
class Opcion1 extends StatelessWidget {
  const Opcion1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario')),
      body: const CardList(),
      backgroundColor: Colors.white,
    );
  }
}

/// Lista de tarjetas de cada día con sus valores.
class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> listCar = [5, 4, 3, 2, 8, 0, 1];
    final List<int> listMidi = [2, 8, 0, 1, 5, 4, 3];
    final List<int> listMax = [5, 4, 10, 2, 8, 0, 3];

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

/// Tarjeta individual de un día
class DayCard extends StatelessWidget {
  final String day;
  final int carValue;
  final int midiValue;
  final int maxValue;

  const DayCard({
    super.key,
    required this.day,
    required this.carValue,
    required this.midiValue,
    required this.maxValue,
  });

  Color getColor(int value) {
    if (value < 5) return Colors.red;
    if (value <= 7) return Colors.yellow;
    return Colors.green;
  }

  void _openVehicleList(BuildContext context, String type, int count) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleListScreen(day: day, type: type, count: count),
      ),
    );
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('car', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Circle(
                  number: carValue,
                  color: getColor(carValue),
                  onTap: () => _openVehicleList(context, 'car', carValue),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('midi', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Circle(
                  number: midiValue,
                  color: getColor(midiValue),
                  onTap: () => _openVehicleList(context, 'midi', midiValue),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('max', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Circle(
                  number: maxValue,
                  color: getColor(maxValue),
                  onTap: () => _openVehicleList(context, 'max', maxValue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Círculo con número clickeable
class Circle extends StatelessWidget {
  final int number;
  final Color color;
  final VoidCallback? onTap;

  const Circle({super.key, required this.number, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
      ),
    );
  }
}

/// Pantalla de lista de vehículos
class VehicleListScreen extends StatelessWidget {
  final String day;
  final String type;
  final int count;

  const VehicleListScreen({
    super.key,
    required this.day,
    required this.type,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final vehicles = List.generate(
      count,
          (index) => '$type Vehicle ${index + 1} for $day',
    );

    return Scaffold(
      appBar: AppBar(title: Text('Vehículos $type - $day')),
      body: vehicles.isEmpty
          ? const Center(child: Text('No hay vehículos disponibles.'))
          : ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.directions_car),
            title: Text(vehicles[index]),
          );
        },
      ),
    );
  }
}
