//This class is to check if the contracts are in the private storage of the app.
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class FileChecker {
  static final Map<String, String> filesToCheck = {
    'PDF_A_FIRMAR.pdf': 'https://drive.google.com/uc?export=download&id=1GUS8c6tAzKNZcJAkc2EwiOBd4tz5mnl_',
    'PDF_A_FIRMAR.pdf': 'https://drive.google.com/uc?export=download&id=1GUS8c6tAzKNZcJAkc2EwiOBd4tz5mnl_',
  };

  // Verifica si los archivos existen en el almacenamiento interno,
  // y si no existen, los descarga.
  static Future<List<String>> checkAndDownloadFiles() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final Dio dio = Dio();
    List<String> descargados = [];

    for (final entry in filesToCheck.entries) {
      final String path = '${dir.path}/${entry.key}';
      final File file = File(path);

      if (!await file.exists()) {
        try {
          await dio.download(entry.value, path);
          descargados.add(entry.key);
        } catch (e) {
          print('❌ Error al descargar ${entry.key}: $e');
        }
      }
    }

    return descargados;
  }

  /// Verifica si un archivo específico ya existe
  static Future<bool> exists(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName').exists();
  }

  /// Devuelve el path absoluto de un archivo guardado
  static Future<String> getFilePath(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$fileName';
  }
}