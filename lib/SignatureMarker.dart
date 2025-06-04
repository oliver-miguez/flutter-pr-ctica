import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import 'LocalPDFViewer.dart';
import 'PDFSigner.dart';

class SignatureMaker extends StatefulWidget {
  const SignatureMaker({super.key});

  @override
  _SignatureMakerState createState() => _SignatureMakerState();
}

class _SignatureMakerState extends State<SignatureMaker> {
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
          SizedBox(
            height: 300,
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.grey[200]!,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_controller.isNotEmpty) {
                Uint8List? signature = await _controller.toPngBytes();
                if (signature != null) {
                  final dir = await getApplicationDocumentsDirectory();
                  final file = File("${dir.path}/PDF_A_FIRMAR.pdf");

                  if (!await file.exists()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("❌ PDF no encontrado")),
                    );
                    return;
                  }

                  Uint8List pdfBytes = await file.readAsBytes();

                  // AQUÍ defines las posiciones de firma: (como en estos contratos solo hay que firmar dos veces, pues solo dos objetos en el array)
                  final positions = [
                    {'page': 0.0, 'x': 100.0, 'y': 150.0},
                    {'page': 1.0, 'x': 200.0, 'y': 100.0},
                  ];

                  final Uint8List? pdfFirmado = await PDFSigner.signPdfWithImage(
                    pdfBytes: pdfBytes,
                    signatureBytes: signature,
                    positions: positions,
                  );

                  if (pdfFirmado != null) {
                    final output = File("${dir.path}/Contrato1_firmado.pdf");
                    await output.writeAsBytes(pdfFirmado);

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
