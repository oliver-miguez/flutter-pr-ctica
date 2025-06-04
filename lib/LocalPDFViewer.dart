
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:programa/menu.dart';

import 'SignatureMarker.dart';

class LocalPDFViewer extends StatefulWidget {
  final String pdfFileName;
  final bool isSigned;

  const LocalPDFViewer({super.key, required this.pdfFileName, required this.isSigned});

  @override
  State<LocalPDFViewer> createState() => _LocalPDFViewerState();
}

class _LocalPDFViewerState extends State<LocalPDFViewer> {
  String? pdfPath;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

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

  @override
  Widget build(BuildContext context) {
    String textTitle = widget.isSigned ? "PDF firmado" : "PDF local";
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
          PDFView(
            filePath: pdfPath!,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => classRoute));
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