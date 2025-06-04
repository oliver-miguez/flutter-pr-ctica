// Paquete principal de la aplicación Android nativa
package com.example.programa

// Importaciones necesarias para Flutter y la manipulación de PDFs
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.graphics.BitmapFactory

// Librerías PDFBox modificadas para Android (tom_roush)
import com.tom_roush.pdfbox.pdmodel.PDDocument
import com.tom_roush.pdfbox.pdmodel.PDPageContentStream
import com.tom_roush.pdfbox.pdmodel.graphics.image.JPEGFactory
import com.tom_roush.pdfbox.pdmodel.interactive.form.PDAcroForm
import com.tom_roush.pdfbox.pdmodel.interactive.form.PDTextField

import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream

// Clase principal de la actividad Android, que extiende FlutterActivity
class MainActivity: FlutterActivity() {

    // Nombre del canal de comunicación entre Flutter y Android nativo
    private val CHANNEL = "pdf_signer"

    // Este método se llama al inicializar el motor de Flutter
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Se crea el canal de comunicación y se establece un manejador para llamadas desde Flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "signPdfWithImage" -> {
                    // Recibe los parámetros enviados desde Flutter
                    val pdfBytes = call.argument<ByteArray>("pdf")
                    val imageBytes = call.argument<ByteArray>("image")
                    val positions = call.argument<List<Map<String, Double>>>("positions")

                    // Verifica que todos los parámetros estén presentes
                    if (pdfBytes == null || imageBytes == null || positions == null) {
                        result.error("INVALID_ARGUMENT", "PDF, image o positions faltan", null)
                        return@setMethodCallHandler
                    }

                    // Intenta firmar el PDF con la imagen
                    try {
                        val signedPdf = signPdfWithImage(pdfBytes, imageBytes, positions)
                        result.success(signedPdf) // Devuelve el PDF firmado a Flutter
                    } catch (e: Exception) {
                        result.error("SIGN_ERROR", "Error al firmar: ${e.localizedMessage}", null)
                    }
                }

                "fillPdfForm" -> {
                    // Recibe los campos del formulario desde Flutter
                    val pdfBytes = call.argument<ByteArray>("pdf")
                    val nombre = call.argument<String>("Nombre") ?: ""
                    val apellidos = call.argument<String>("Apellidos") ?: ""
                    val dni = call.argument<String>("DNI") ?: ""
                    val telefono = call.argument<String>("Telefono") ?: ""
                    val personalidad = call.argument<String>("Personalidad") ?: ""

                    // Verifica que el PDF esté presente
                    if (pdfBytes == null) {
                        result.error("INVALID_ARGUMENT", "PDF bytes faltan", null)
                        return@setMethodCallHandler
                    }

                    // Intenta rellenar el formulario
                    try {
                        val filledPdf = fillPdfForm(pdfBytes, nombre, apellidos, dni, telefono, personalidad)
                        result.success(filledPdf) // Devuelve el PDF completado a Flutter
                    } catch (e: Exception) {
                        result.error("FILL_FORM_ERROR", "Error al rellenar formulario: ${e.localizedMessage}", null)
                    }
                }

                // Si se llama un método no implementado
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // Función para firmar un PDF con una imagen en posiciones específicas
    private fun signPdfWithImage(
        pdfData: ByteArray,
        imageData: ByteArray,
        positions: List<Map<String, Double>>,
    ): ByteArray {
        // Carga el PDF en memoria
        val inputPdf = ByteArrayInputStream(pdfData)
        val document = PDDocument.load(inputPdf)

        // Convierte los bytes de la imagen en un Bitmap y luego en una imagen PDFBox
        val bitmap = BitmapFactory.decodeStream(ByteArrayInputStream(imageData))
        val pdImage = JPEGFactory.createFromImage(document, bitmap)

        // Inserta la imagen en cada posición especificada
        for (position in positions) {
            val pageIndex = (position["page"] ?: 0.0).toInt()
            val x = position["x"] ?: 0.0
            val y = position["y"] ?: 0.0

            // Si el índice de página es inválido, continúa con la siguiente
            if (pageIndex >= document.numberOfPages) continue

            val page = document.getPage(pageIndex)
            val mediaBox = page.mediaBox
            val signatureWidth = mediaBox.width * 0.3f // Ancho relativo de la firma
            val signatureHeight = mediaBox.height * 0.1f // Alto relativo de la firma

            // Crea un flujo de contenido para agregar la imagen
            val contentStream = PDPageContentStream(
                document,
                page,
                PDPageContentStream.AppendMode.APPEND, // Añadir contenido, no sobrescribir
                true
            )

            // Dibuja la imagen en la posición indicada
            contentStream.drawImage(
                pdImage,
                x.toFloat(),
                y.toFloat(),
                signatureWidth,
                signatureHeight
            )

            // Cierra el flujo de contenido
            contentStream.close()
        }

        // Guarda el PDF en un flujo de salida y lo convierte en bytes
        val outputStream = ByteArrayOutputStream()
        document.save(outputStream)
        document.close()

        return outputStream.toByteArray() // Retorna el PDF firmado
    }

    // Función para rellenar campos de un formulario en un PDF
    private fun fillPdfForm(
        pdfData: ByteArray,
        nombre: String,
        apellidos: String,
        dni: String,
        telefono: String,
        personalidad: String
    ): ByteArray {
        // Carga el PDF en memoria
        val inputPdf = ByteArrayInputStream(pdfData)
        val document = PDDocument.load(inputPdf)

        // Obtiene el formulario (AcroForm) del PDF
        val acroForm: PDAcroForm? = document.documentCatalog.acroForm

        // Si hay un formulario, se rellenan los campos correspondientes
        if (acroForm != null) {
            (acroForm.getField("Nombre") as? PDTextField)?.value = nombre
            (acroForm.getField("Apellidos") as? PDTextField)?.value = apellidos
            (acroForm.getField("DNI") as? PDTextField)?.value = dni
            (acroForm.getField("Telefono") as? PDTextField)?.value = telefono
            (acroForm.getField("Personalidad") as? PDTextField)?.value = personalidad

            // Si quieres que el formulario quede como no editable, descomenta esto:
            // acroForm.flatten()
        }

        // Guarda y retorna el PDF con los datos rellenados
        val outputStream = ByteArrayOutputStream()
        document.save(outputStream)
        document.close()

        return outputStream.toByteArray()
    }
}
