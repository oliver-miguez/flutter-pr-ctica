import 'package:flutter/material.dart';

class Opcion2 extends StatefulWidget {
  const Opcion2({super.key});

  @override
  State<Opcion2> createState() => _ReservaFormularioScreenState();
}

class _ReservaFormularioScreenState extends State<Opcion2> {
  final List<String> diasSemana = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];
  final List<String> destinos = ['Cibeles', 'Atocha', 'Sol', 'Chamartín'];
  final List<String> tiposVehiculo = ['car', 'midi', 'max'];

  final Map<String, Map<String, int>> disponibilidad = {
    'Lunes': {'car': 5, 'midi': 2, 'max': 5},
    'Martes': {'car': 4, 'midi': 8, 'max': 4},
    'Miércoles': {'car': 3, 'midi': 0, 'max': 10},
    'Jueves': {'car': 2, 'midi': 1, 'max': 2},
    'Viernes': {'car': 8, 'midi': 5, 'max': 8},
    'Sábado': {'car': 0, 'midi': 4, 'max': 0},
    'Domingo': {'car': 1, 'midi': 3, 'max': 3},
  };

  //Guarda los datos que el usuario selecciona
  String? diaSeleccionado;
  String? destinoSeleccionado;
  String? vehiculoSeleccionado;

  void realizarReserva() {
    if (diaSeleccionado == null || destinoSeleccionado == null || vehiculoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    final disponibles = disponibilidad[diaSeleccionado]?[vehiculoSeleccionado] ?? 0;
    if (disponibles == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay vehículos disponibles para esta combinación')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reserva confirmada'),
        content: Text(
          'Día: $diaSeleccionado\n'
              'Destino: $destinoSeleccionado\n'
              'Vehículo: $vehiculoSeleccionado\n'
              'Disponibles: $disponibles',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int disponibles = 0;
    if (diaSeleccionado != null && vehiculoSeleccionado != null) {
      disponibles = disponibilidad[diaSeleccionado!]?[vehiculoSeleccionado!] ?? 0;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Formulario reserva')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Día:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: diaSeleccionado,
              hint: const Text('Selecciona un día'),
              items: diasSemana.map((dia) => DropdownMenuItem(
                value: dia, child: Text(dia),
              )).toList(),
              onChanged: (value) => setState(() => diaSeleccionado = value),
            ),

            const SizedBox(height: 16),
            const Text('Destino:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: destinoSeleccionado,
              hint: const Text('Selecciona destino'),
              items: destinos.map((d) => DropdownMenuItem(
                value: d, child: Text(d),
              )).toList(),
              onChanged: (value) => setState(() => destinoSeleccionado = value),
            ),

            const SizedBox(height: 16),
            const Text('Tipo de vehículo:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: vehiculoSeleccionado,
              hint: const Text('Selecciona tipo'),
              items: tiposVehiculo.map((v) => DropdownMenuItem(
                value: v, child: Text(v),
              )).toList(),
              onChanged: (value) => setState(() => vehiculoSeleccionado = value),
            ),

            const SizedBox(height: 16),
            if (diaSeleccionado != null && vehiculoSeleccionado != null)
              Text('Disponibles: $disponibles', style: const TextStyle(fontSize: 16)),

            const Spacer(),
            ElevatedButton(
              onPressed: realizarReserva,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Reservar'),
            ),
          ],
        ),
      ),
    );
  }
}
