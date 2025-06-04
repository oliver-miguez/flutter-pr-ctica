import 'package:flutter/material.dart';
import 'package:programa/Contracts_Viewer.dart';
import 'package:programa/LocalPDFViewer.dart';
import 'package:programa/Opcion1.dart';
import 'package:programa/Opcion2.dart';
import 'package:programa/Opcion3.dart';
import 'package:programa/Opcion4.dart';
class Menu extends StatelessWidget {
  const Menu({super.key});
  //Rutas de cada opción
  void _navegar(BuildContext context, int opcion) {
    Widget destino;

    switch (opcion) {
      case 1:
        destino = const Opcion1();
        break;
      case 2:
        destino = const Opcion2();
        break;
      case 3:
        destino = const Contracts_Viewer();
        break;
      case 4:
        destino = const Opcion4();
        break;
      default:
        return;
    }
    //redirige a la ruta correspondiente según el botón presionado
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destino),
    );
  }

  //crear los 4 bloques
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú Principal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count( //Muestra una lista de elementos organizados en una cuadrícula
          crossAxisCount: 2, // número de columnas deseadas
          crossAxisSpacing: 16, //espacio entre columnas
          mainAxisSpacing: 16, //espacio vertical entre los elementos de la columna
          childAspectRatio: 1.5, // hace los botones más rectangulares
          children: [ //los cuatro botones
            _botonMenu(context, 'Opción 1', 1),
            _botonMenu(context, 'Opción 2', 2),
            _botonMenu(context, 'Opción 3', 3),
            _botonMenu(context, 'Opción 4', 4),
          ],
        ),
      ),
    );
  }

  //diseño de cada botón
  Widget _botonMenu(BuildContext context, String texto, int opcion) {
    return ElevatedButton(
      onPressed: () => _navegar(context, opcion),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // esquinas redondeadas
        ),
        backgroundColor: Colors.white38,
        foregroundColor: Colors.black,//color letras
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: Text(texto),
    );
  }
}

