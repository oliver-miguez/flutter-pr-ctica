import 'dart:typed_data';
import 'package:flutter/services.dart';

class PDFSigner {
  static const MethodChannel _channel = MethodChannel('pdf_signer');

  /// Firma un PDF con una imagen en múltiples posiciones
  static Future<Uint8List?> signPdfWithImage({
    required Uint8List pdfBytes,
    required Uint8List signatureBytes,
    required List<Map<String, double>> positions, // --> Crea el array de las posiciones
  }) async {
    try {
      final Uint8List? result = await _channel.invokeMethod<Uint8List>(
        'signPdfWithImage',
        {
          'pdf': pdfBytes,
          'image': signatureBytes,
          'positions': positions, // Se envía lista de mapas con page/x/y  --> Para poder firmar
        },
      );
      return result;
    } on PlatformException catch (e) {
      print('❌ Error al firmar PDF: ${e.message}');
      return null;
    }
  }
}
