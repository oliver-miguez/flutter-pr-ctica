import 'dart:typed_data';
import 'package:flutter/services.dart';

/// Servicio nativo para firmar archivos PDF con una imagen de firma.
///
/// Usa un canal de plataforma (`MethodChannel`) para comunicarse con código nativo
/// que implementa la lógica de firma en el PDF (por ejemplo, en Android/Kotlin o iOS/Swift).
class PDFSigner {
  static const MethodChannel _channel = MethodChannel('pdf_signer');

  /// Firma un PDF insertando una imagen en múltiples posiciones dentro del documento.
  ///
  /// - [pdfBytes]: contenido en bytes del PDF original.
  /// - [signatureBytes]: contenido en bytes de la imagen de la firma.
  /// - [positions]: lista de posiciones donde colocar la firma.
  ///   Cada posición debe tener las claves: `'page'`, `'x'` y `'y'`.
  ///
  /// Devuelve los bytes del PDF firmado o `null` si hubo un error.
  static Future<Uint8List?> signPdfWithImage({
    required Uint8List pdfBytes,
    required Uint8List signatureBytes,
    required List<Map<String, double>> positions,
  }) async {
    try {
      final Uint8List? result = await _channel.invokeMethod<Uint8List>(
        //parametros con los que firmará el pdf en el kotlin
        'signPdfWithImage',
        {
          'pdf': pdfBytes,
          'image': signatureBytes,
          'positions': positions,
        },
      );
      if(result == null){
        print("Error al rellenar el PDF");
        return result;
      }

      final Uint8List? res = await _channel.invokeMethod<Uint8List>(
          'fillPdfForm',
        {
          'pdf': result, // <-- El pdf ya firmado
          'Nombre': 'Juan',
          'Apellidos': 'Pérez',
          'DNI': '12345678A',
          'Telefono': '600123456',
          'Personalidad': 'Física',
        },
      );

      if(res == null){
        print("Error con el relleno de las tablas del PDF");
        return res;
      }


    } on PlatformException catch (e) {
      print('❌ Error al firmar PDF: ${e.message}');
      return null;
    }
  }
}
