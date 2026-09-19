import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  // 🔥 Verificar y solicitar permiso de cámara
  static Future<bool> solicitarCamara(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      await _mostrarDialogoAjustes(context, 'cámara');
      return false;
    }

    final result = await Permission.camera.request();
    return result.isGranted;
  }

  // 🔥 Verificar y solicitar permiso de ubicación
  static Future<bool> solicitarUbicacion(BuildContext context) async {
    final status = await Permission.locationWhenInUse.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      await _mostrarDialogoAjustes(context, 'ubicación');
      return false;
    }

    final result = await Permission.locationWhenInUse.request();
    return result.isGranted;
  }

  // 🔥 Diálogo para denegación permanente
  static Future<void> _mostrarDialogoAjustes(
    BuildContext context,
    String capacidad,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Acceso a $capacidad bloqueado'),
        content: Text(
          'El acceso a $capacidad está bloqueado. Puede habilitarlo desde los ajustes del sistema.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Abrir Ajustes'),
          ),
        ],
      ),
    );
  }
}