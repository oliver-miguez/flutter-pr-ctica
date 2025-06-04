import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:programa/menu.dart';

import 'SignatureMarker.dart';

/// Vista que muestra un archivo PDF guardado localmente.
///
/// Esta pantalla permite visualizar un PDF ya descargado, y dependiendo
/// de si está firmado o no, permite redirigir a [SignatureMaker] o a [Menu].
class LocalPDFViewer extends StatefulWidget {
  /// Nombre del archivo PDF a visualizar.
  final String pdfFileName;

  /// Indica si el PDF ya está firmado o no.
  final bool isSigned;

  const LocalPDFViewer({
    super.key,
    required this.pdfFileName,
    required this.isSigned,
  });

  @override
  State<LocalPDFViewer> createState() => _LocalPDFViewerState();
}

/// Estado para [LocalPDFViewer].
///
/// Se encarga de cargar el archivo desde almacenamiento local
/// y de construir la interfaz para visualizar el PDF.
class _LocalPDFViewerState extends State<LocalPDFViewer> {
  /// Ruta absoluta al archivo PDF en el dispositivo.
  String? pdfPath;

  /// Indica si el archivo aún se está cargando.
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf(); // Intenta cargar el archivo al iniciar.
  }

  /// Método que busca el archivo PDF en el almacenamiento local del dispositivo.
  ///
  /// Si el archivo existe, actualiza la ruta y quita el estado de carga.
  Future<void> _loadPdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${widget.pdfFileName}';
    final file = File(filePath);

    if (await file.exists()) {
      setState(() {
        pdfPath = file.path;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      debugPrint('⚠️ El archivo no existe en: $filePath');
    }
  }

  /// Construye la interfaz de la pantalla de visualización del PDF.
  ///
  /// Si el archivo se está cargando, muestra un spinner.
  /// Si no existe, muestra un mensaje de error.
  /// Si todo está bien, muestra el PDF y un botón para continuar.
  @override
  Widget build(BuildContext context) {
    // Título dinámico según si está firmado o no
    String textTitle = widget.isSigned ? "PDF firmado" : "PDF local";

    // Ruta que se tomará al presionar "Continuar"
    final classRoute = !widget.isSigned ? SignatureMaker() : Menu();

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (pdfPath == null) {
      return const Scaffold(
        body: Center(child: Text('PDF no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(textTitle)),
      body: Stack(
        children: [
          /// Componente que muestra el PDF utilizando el plugin `flutter_pdfview`
          PDFView(
            filePath: pdfPath!,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
          ),
          /// Botón flotante para avanzar a la siguiente pantalla
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => classRoute),
                  );
                },
                child: const Text('Continuar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
