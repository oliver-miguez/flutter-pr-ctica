import 'package:flutter/material.dart';

void main() {
  runApp(const Opcion1());
}

class Opcion1 extends StatelessWidget {
  const Opcion1({super.key});

  //Barra superior
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Menu',
      home: Scaffold(
        appBar: AppBar(title: const Text('Car Menu')),
        body: const CarMenu(),
      ),
    );
  }
}

//Lista de vehiculos para hacer verificar si funciona
class CarMenu extends StatelessWidget {
  const CarMenu({super.key});

  final List<Map<String, dynamic>> cars = const [
    {'name': 'Coche 1', 'quantity': 3},
    {'name': 'Coche 2', 'quantity': 7},
    {'name': 'Coche 3', 'quantity': 12},
  ];

  //Crea una lista de widgets de la lista de coches
  @override
  Widget build(BuildContext context) {
    return ListView( //para una lista scrolleable
      padding: const EdgeInsets.all(16),
      children: cars.map((car) { //de la lista de mapas 'cars' a través del .map se extraen sus valores
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: CarStatusWidget(
            carName: car['name'],
            quantity: car['quantity'],
          ),
        );
      }).toList(), //transforma los valores en una lista de widgets
    );
  }
}

//definir los datos de cada vehiculo
class CarStatusWidget extends StatelessWidget {
  final String carName;
  final int quantity;

  const CarStatusWidget({
    super.key,
    required this.carName,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    // Definimos los colores y si mostramos el número dentro del círculo
    Color redColor = Colors.red;
    Color yellowColor = Colors.yellow;
    Color greenColor = Colors.green;

    //evitar que muestre el número de vehiculos en donde corresponda
    bool showRedNumber = false;
    bool showYellowNumber = false;
    bool showGreenNumber = false;

    // Lógica para activar un círculo según quantity
    if (quantity < 5) {
      redColor = Colors.red;
      showRedNumber = true;
    } else if (quantity < 10) {
      yellowColor = Colors.yellow[700]!;
      showYellowNumber = true;
    } else {
      greenColor = Colors.green;
      showGreenNumber = true;
    }

    Widget circle(Color color, bool showNumber) {
      return CircleAvatar(
        radius: 14,
        backgroundColor: color,
        child: showNumber
            ? Text(
          quantity.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
            : null,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          carName,
          style: const TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            circle(redColor, showRedNumber),
            const SizedBox(width: 12),
            circle(yellowColor, showYellowNumber),
            const SizedBox(width: 12),
            circle(greenColor, showGreenNumber),
          ],
        ),
      ],
    );
  }
}
