package com.example.programa

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.graphics.BitmapFactory
import com.tom_roush.pdfbox.pdmodel.PDDocument
import com.tom_roush.pdfbox.pdmodel.PDPage
import com.tom_roush.pdfbox.pdmodel.PDPageContentStream
import com.tom_roush.pdfbox.pdmodel.graphics.image.JPEGFactory
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "pdf_signer"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "signPdfWithImage") {
                // Se reciben los bytes del PDF, la imagen de la firma y la lista de posiciones
                val pdfBytes = call.argument<ByteArray>("pdf")
                val imageBytes = call.argument<ByteArray>("image")
                val positions = call.argument<List<Map<String, Double>>>("positions")

                // Verifica que no falte ninguno de los datos requeridos
                if (pdfBytes == null || imageBytes == null || positions == null) {
                    result.error("INVALID_ARGUMENT", "PDF, image o positions faltan", null)
                    return@setMethodCallHandler
                }

                try {
                    // Llama a la función que hace la firma múltiple
                    val signedPdf = signPdfWithImage(pdfBytes, imageBytes, positions)
                    result.success(signedPdf)
                } catch (e: Exception) {
                    result.error("SIGN_ERROR", "Error al firmar: ${e.localizedMessage}", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
    /**
     * Firma el PDF en múltiples posiciones especificadas.
     *
     * @param pdfData Bytes del PDF original
     * @param imageData Bytes de la imagen de la firma
     * @param positions Lista de mapas con claves "page", "x", "y" (coordenadas donde colocar la firma)
     */
    private fun signPdfWithImage(
        pdfData: ByteArray,
        imageData: ByteArray,
        positions: List<Map<String, Double>>
    ): ByteArray {
        val inputPdf = ByteArrayInputStream(pdfData)
        val document = PDDocument.load(inputPdf)

        val bitmap = BitmapFactory.decodeStream(ByteArrayInputStream(imageData))
        val pdImage = JPEGFactory.createFromImage(document, bitmap)

        // Por cada posición que viene de Flutter:
        for (position in positions) {
            val pageIndex = (position["page"] ?: 0.0).toInt()
            val x = position["x"] ?: 0.0
            val y = position["y"] ?: 0.0

            if (pageIndex >= document.numberOfPages) continue

            val page = document.getPage(pageIndex)
            val mediaBox = page.mediaBox
            val signatureWidth = mediaBox.width * 0.3f
            val signatureHeight = mediaBox.height * 0.1f

            //Inserta la imagen en la posición deseada
            val contentStream = PDPageContentStream(
                document,
                page,
                PDPageContentStream.AppendMode.APPEND,
                true
            )
            contentStream.drawImage(
                pdImage,
                x.toFloat(),
                y.toFloat(),
                signatureWidth,
                signatureHeight
            )
            contentStream.close()
        }

        val outputStream = ByteArrayOutputStream()
        document.save(outputStream)
        document.close()

        return outputStream.toByteArray()
    }
}