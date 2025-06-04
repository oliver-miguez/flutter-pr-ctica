import 'package:flutter/material.dart';

import '../Model/FileChecker.dart';
import 'LocalPDFViewer.dart';

/// Vista principal para mostrar los contratos disponibles en forma de tarjetas.
///
/// Esta clase representa una pantalla con una lista de contratos PDF que se
/// pueden visualizar y eventualmente firmar.
class Contracts_Viewer extends StatefulWidget {
  const Contracts_Viewer({super.key});

  @override
  State<Contracts_Viewer> createState() => _Contracts_ViewerState();
}

/// Estado asociado a la vista [Contracts_Viewer].
///
/// Se encarga de verificar que los archivos PDF estén descargados y
/// construir la interfaz con las tarjetas para acceder a cada contrato.
class _Contracts_ViewerState extends State<Contracts_Viewer> {
  /// Variable para controlar si aún se están cargando los archivos.
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _checkFiles(); // Llama al método que verifica y descarga archivos.
  }

  /// Método que verifica si los archivos PDF necesarios están en el almacenamiento.
  ///
  /// Si no están, los descarga usando la clase [FileChecker].
  Future<void> _checkFiles() async {
    final descargados = await FileChecker.checkAndDownloadFiles();
    print("Descargados: $descargados");

    setState(() {
      loading = false;
    });
  }

  /// Método principal que construye el widget de la pantalla.
  ///
  /// Muestra un spinner si los archivos aún están cargando.
  /// Luego muestra una lista de tarjetas con los contratos.
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Nombres visibles de los contratos
    final names = [
      "Contrato coches",
      "Contrato furgonetas",
      "Contratos motos",
      "Contratos campers"
    ];

    // Nombres reales de los archivos PDF en el almacenamiento
    final contracts = [
      "PDF_A_FIRMAR.pdf",
      "PDF_A_FIRMAR.pdf",
      "PDF_A_FIRMAR.pdf",
      "PDF_A_FIRMAR.pdf"
    ];

    // Construye la lista de tarjetas
    final list = buildList(4, names, contracts);

    return Scaffold(
      appBar: AppBar(
        title: Text("Visor de contratos"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [...list],
        ),
      ),
    );
  }

  /// Construye una tarjeta para cada contrato.
  ///
  /// Al hacer `tap` en una tarjeta, se navega a [LocalPDFViewer] para ver el PDF.
  Widget buildCard(String name, String contractName) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocalPDFViewer(
              pdfFileName: contractName,
              isSigned: false,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye una lista de widgets tipo tarjeta usando los nombres y archivos.
  ///
  /// [numberCards] indica cuántas tarjetas crear.
  /// [names] contiene los títulos visibles.
  /// [contracts] contiene los nombres de los archivos PDF.
  List<Widget> buildList(int numberCards, List<String> names, List<String> contracts) {
    List<Widget> list = [];
    for (int i = 0; i < numberCards; i++) {
      list.add(buildCard(names[i], contracts[i]));
    }
    return list;
  }
}
