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

      // 1. Obtener el directorio permanente de la app
      final directorioApp = await getApplicationDocumentsDirectory();
      final directorioFotos = Directory(
        p.join(directorioApp.path, 'fotos_jugadores'),
      );

      // 2. Crear el directorio si no existe
      if (!await directorioFotos.exists()) {
        await directorioFotos.create(recursive: true);
      }

      // 3. Copiar la foto con un nombre único
      final nombreArchivo = 'jugador_${DateTime.now().millisecondsSinceEpoch}${p.extension(rutaTemporal)}';
      final rutaPermanente = p.join(directorioFotos.path, nombreArchivo);

      await archivoTemporal.copy(rutaPermanente);

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