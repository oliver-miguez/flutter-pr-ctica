import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import 'LocalPDFViewer.dart';
import '../Service/PDFSigner.dart';

/// Pantalla para capturar la firma del usuario y aplicarla sobre un PDF.
///
/// Permite dibujar la firma, guardar la imagen y usarla para firmar
/// posiciones específicas dentro de un documento PDF.
class SignatureMaker extends StatefulWidget {
  const SignatureMaker({super.key});

  @override
  _SignatureMakerState createState() => _SignatureMakerState();
}

class _SignatureMakerState extends State<SignatureMaker> {
  /// Controlador para capturar el trazo de la firma.
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firme aquí')),
      body: Column(
        children: [
          /// Área donde el usuario dibuja su firma.
          SizedBox(
            height: 300,
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.grey[200]!,
            ),
          ),
          const SizedBox(height: 20),

          /// Botón para continuar: exporta la firma, firma el PDF y navega a la vista del PDF firmado.
          ElevatedButton(
            onPressed: () async {
              if (_controller.isNotEmpty) {
                Uint8List? signature = await _controller.toPngBytes();
                if (signature != null) {
                  final dir = await getApplicationDocumentsDirectory();
                  final file = File("${dir.path}/PDF_A_FIRMAR.pdf");

                  // Verificar que el PDF exista.
                  if (!await file.exists()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("❌ PDF no encontrado")),
                    );
                    return;
                  }

                  Uint8List pdfBytes = await file.readAsBytes();

                  // Posiciones en el PDF donde se aplicará la firma.
                  final positions = [
                    {'page': 0.0, 'x': 100.0, 'y': 150.0},
                    {'page': 1.0, 'x': 200.0, 'y': 100.0},
                  ];

                  // Llamada al servicio que firma el PDF con la imagen de la firma.
                  final Uint8List? pdfFirmado = await PDFSigner.signPdfWithImage(
                    pdfBytes: pdfBytes,
                    signatureBytes: signature,
                    positions: positions,
                  );

                  if (pdfFirmado != null) {
                    final output = File("${dir.path}/Contrato1_firmado.pdf");
                    await output.writeAsBytes(pdfFirmado);

                    // Navegar a la pantalla de visor del PDF firmado.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LocalPDFViewer(
                          pdfFileName: "Contrato1_firmado.pdf",
                          isSigned: true,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("❌ Error al firmar el PDF")),
                    );
                  }
                }
              }
            },
            child: const Text('Continuar'),
          ),

          /// Botón para limpiar la firma dibujada.
          TextButton(
            onPressed: () {
              _controller.clear();
            },
            child: const Text('Borrar firma'),
          ),
        ],
      ),
    );
  }
}
