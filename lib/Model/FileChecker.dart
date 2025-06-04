// Esta clase se encarga de verificar si los contratos PDF están almacenados localmente.
// Si no están, los descarga desde internet usando Dio.

import 'dart:io'; // Para trabajar con archivos locales
import 'package:dio/dio.dart'; // Cliente HTTP para descargar archivos
import 'package:path_provider/path_provider.dart'; // Para obtener rutas del almacenamiento interno

class FileChecker {
  // Mapa de archivos a verificar: nombre del archivo => URL de descarga
  static final Map<String, String> filesToCheck = {
    'PDF_A_FIRMAR.pdf': 'https://drive.google.com/uc?export=download&id=1GUS8c6tAzKNZcJAkc2EwiOBd4tz5mnl_',
    'PDF_A_FIRMAR.pdf': 'https://drive.google.com/uc?export=download&id=1GUS8c6tAzKNZcJAkc2EwiOBd4tz5mnl_',
  };

  /// Verifica si los archivos existen localmente.
  /// Si no existen, los descarga y los guarda en el almacenamiento interno.
  /// Devuelve una lista con los nombres de los archivos descargados.
  static Future<List<String>> checkAndDownloadFiles() async {
    final Directory dir = await getApplicationDocumentsDirectory(); // Carpeta privada de la app
    final Dio dio = Dio(); // Cliente HTTP
    List<String> descargados = [];

    for (final entry in filesToCheck.entries) {
      final String path = '${dir.path}/${entry.key}'; // Ruta completa del archivo
      final File file = File(path);

      // Si el archivo no existe, lo descarga
      if (!await file.exists()) {
        try {
          await dio.download(entry.value, path); // Descarga desde la URL al path
          descargados.add(entry.key); // Añade a la lista de descargados
        } catch (e) {
          print('❌ Error al descargar ${entry.key}: $e'); // Error en consola
        }
      }
    }

    return descargados; // Devuelve lista de archivos que fueron descargados
  }

  /// Verifica si un archivo específico ya existe en la carpeta interna
  static Future<bool> exists(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName').exists(); // Devuelve true/false
  }

  /// Devuelve la ruta completa de un archivo específico
  static Future<String> getFilePath(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$fileName'; // Ruta absoluta al archivo
  }
}
