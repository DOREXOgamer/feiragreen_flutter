import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class PermissionUtils {
  /// Solicita permissões necessárias para o image picker
  static Future<bool> requestImagePickerPermissions() async {
    try {
      // Verifica o status atual das permissões
      final cameraStatus = await ph.Permission.camera.status;
      final storageStatus = await ph.Permission.storage.status;
      final photosStatus = await ph.Permission.photos.status;

      // Lista de permissões que precisam ser solicitadas
      final permissions = <ph.Permission>[];

      if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
        permissions.add(ph.Permission.camera);
      }

      if (storageStatus.isDenied || storageStatus.isPermanentlyDenied) {
        permissions.add(ph.Permission.storage);
      }

      if (photosStatus.isDenied || photosStatus.isPermanentlyDenied) {
        permissions.add(ph.Permission.photos);
      }

      // Se não há permissões para solicitar, retorna true
      if (permissions.isEmpty) {
        return true;
      }

      // Solicita as permissões
      final results = await permissions.request();

      // Verifica se todas as permissões foram concedidas
      final allGranted = results.values.every((status) => status.isGranted);

      return allGranted;
    } catch (e) {
      debugPrint('Erro ao solicitar permissões: $e');
      return false;
    }
  }

  /// Verifica se as permissões do image picker estão concedidas
  static Future<bool> checkImagePickerPermissions() async {
    try {
      final cameraStatus = await ph.Permission.camera.status;
      final storageStatus = await ph.Permission.storage.status;
      final photosStatus = await ph.Permission.photos.status;

      return cameraStatus.isGranted &&
          (storageStatus.isGranted || photosStatus.isGranted);
    } catch (e) {
      debugPrint('Erro ao verificar permissões: $e');
      return false;
    }
  }

  /// Abre as configurações do aplicativo para o usuário conceder permissões manualmente
  static Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }
}
