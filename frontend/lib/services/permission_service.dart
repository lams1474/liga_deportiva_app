import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Resultado de una solicitud de permiso
enum PermissionResult {
  granted,              // Concedido
  denied,               // Denegado (puede volver a pedir)
  permanentlyDenied,    // Denegación permanente (solo ajustes)
  serviceDisabled,      // Servicio del dispositivo apagado (GPS)
}

class PermissionService {
  // ============================================================
  // CÁMARA
  // ============================================================
  static Future<PermissionResult> solicitarCamara(BuildContext context) async {
    try {
      final status = await Permission.camera.status;
      if (status.isGranted) return PermissionResult.granted;

      if (status.isPermanentlyDenied || status.isRestricted) {
        await _mostrarDialogoAjustes(context, 'cámara');
        return PermissionResult.permanentlyDenied;
      }

      final result = await Permission.camera.request();

      if (result.isGranted) return PermissionResult.granted;

      if (result.isPermanentlyDenied || result.isRestricted) {
        await _mostrarDialogoAjustes(context, 'cámara');
        return PermissionResult.permanentlyDenied;
      }

      _mostrarSnackBar(
        context,
        'Para tomar la foto necesitas permitir el acceso a la cámara.',
      );
      return PermissionResult.denied;
    } catch (e) {
      debugPrint('❌ Error en solicitarCamara: $e');
      return PermissionResult.denied;
    }
  }

  // ============================================================
  // UBICACIÓN
  // ============================================================
  static Future<PermissionResult> solicitarUbicacion(BuildContext context) async {
    try {
      // 1. ¿El servicio de ubicación está encendido?
      final servicioActivo = await Geolocator.isLocationServiceEnabled();
      if (!servicioActivo) {
        await _mostrarDialogoGPSApagado(context);
        return PermissionResult.serviceDisabled;
      }

      // 2. ¿Ya tiene permiso?
      final status = await Permission.locationWhenInUse.status;
      if (status.isGranted) return PermissionResult.granted;

      if (status.isPermanentlyDenied || status.isRestricted) {
        await _mostrarDialogoAjustes(context, 'ubicación');
        return PermissionResult.permanentlyDenied;
      }

      // 3. Pedir permiso
      final result = await Permission.locationWhenInUse.request();

      if (result.isGranted) return PermissionResult.granted;

      if (result.isPermanentlyDenied || result.isRestricted) {
        await _mostrarDialogoAjustes(context, 'ubicación');
        return PermissionResult.permanentlyDenied;
      }

      _mostrarSnackBar(
        context,
        'Para registrar la ubicación necesitas permitir el acceso.',
      );
      return PermissionResult.denied;
    } catch (e) {
      debugPrint('❌ Error en solicitarUbicacion: $e');
      return PermissionResult.denied;
    }
  }

  // ============================================================
  // DIÁLOGOS
  // ============================================================
  static Future<void> _mostrarDialogoAjustes(
    BuildContext context,
    String capacidad,
  ) async {
    if (!context.mounted) return;
    try {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text('Acceso a $capacidad bloqueado'),
          content: Text(
            'El acceso a $capacidad está bloqueado. '
            'Puedes habilitarlo manualmente desde los ajustes del sistema.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                // Pequeño delay para que el diálogo se cierre antes de abrir Ajustes
                await Future.delayed(const Duration(milliseconds: 200));
                try {
                  await openAppSettings();
                } catch (e) {
                  debugPrint('❌ Error abriendo ajustes: $e');
                }
              },
              child: const Text('Abrir Ajustes'),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('❌ Error mostrando diálogo de ajustes: $e');
    }
  }

  static Future<void> _mostrarDialogoGPSApagado(BuildContext context) async {
    if (!context.mounted) return;
    try {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Ubicación desactivada'),
          content: const Text(
            'El servicio de ubicación del dispositivo está apagado. '
            'Actívalo para poder registrar la ubicación.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await Future.delayed(const Duration(milliseconds: 200));
                try {
                  await Geolocator.openLocationSettings();
                } catch (e) {
                  debugPrint('❌ Error abriendo ajustes de ubicación: $e');
                }
              },
              child: const Text('Activar ubicación'),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('❌ Error mostrando diálogo GPS: $e');
    }
  }

  static void _mostrarSnackBar(BuildContext context, String mensaje) {
    if (!context.mounted) return;
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: Colors.orange.shade700,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error mostrando SnackBar: $e');
    }
  }
}