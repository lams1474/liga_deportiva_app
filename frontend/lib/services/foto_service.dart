import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FotoService {
  // 🔥 Guardar la foto en un directorio permanente
  static Future<String?> guardarFotoPermanente(String rutaTemporal) async {
    try {
      final archivoTemporal = File(rutaTemporal);
      if (!await archivoTemporal.exists()) {
        print('❌ La foto temporal no existe: $rutaTemporal');
        return null;
      }

      final directorioApp = await getApplicationDocumentsDirectory();
      final directorioFotos = Directory(
        p.join(directorioApp.path, 'fotos_jugadores'),
      );

      if (!await directorioFotos.exists()) {
        await directorioFotos.create(recursive: true);
      }

      final nombreArchivo =
          'jugador_${DateTime.now().millisecondsSinceEpoch}${p.extension(rutaTemporal)}';
      final rutaPermanente = p.join(directorioFotos.path, nombreArchivo);

      await archivoTemporal.copy(rutaPermanente);

      // 🔥 Debug: confirmar que se guardó
      final archivoFinal = File(rutaPermanente);
      final existe = await archivoFinal.exists();
      final tamanio = existe ? await archivoFinal.length() : 0;
      print('✅ Foto guardada en: $rutaPermanente ($tamanio bytes)');

      return rutaPermanente;
    } catch (e) {
      print('❌ Error al guardar foto permanente: $e');
      return null;
    }
  }

  // 🔥 Eliminar una foto (al eliminar el jugador)
  static Future<void> eliminarFoto(String? rutaFoto) async {
    if (rutaFoto == null) return;
    try {
      final archivo = File(rutaFoto);
      if (await archivo.exists()) {
        await archivo.delete();
      }
    } catch (e) {
      print('❌ Error al eliminar foto: $e');
    }
  }
}