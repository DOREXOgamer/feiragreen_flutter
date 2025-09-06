import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  /// Solicita permissões necessárias para o image picker
  static Future<bool> requestImagePickerPermissions() async {
    try {
      // Verifica o status atual das permissões
      final cameraStatus = await Permission.camera.status;
      final storageStatus = await Permission.storage.status;
      final photosStatus = await Permission.photos.status;

      // Lista de permissões que precisam ser solicitadas
      final permissions = <Permission>[];

      if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
        permissions.add(Permission.camera);
      }

      if (storageStatus.isDenied || storageStatus.isPermanentlyDenied) {
        permissions.add(Permission.storage);
      }

      if (photosStatus.isDenied || photosStatus.isPermanentlyDenied) {
        permissions.add(Permission.photos);
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
      print('Erro ao solicitar permissões: $e');
      return false;
    }
  }

  /// Verifica se as permissões do image picker estão concedidas
  static Future<bool> checkImagePickerPermissions() async {
    try {
      final cameraStatus = await Permission.camera.status;
      final storageStatus = await Permission.storage.status;
      final photosStatus = await Permission.photos.status;

      return cameraStatus.isGranted &&
          (storageStatus.isGranted || photosStatus.isGranted);
    } catch (e) {
      print('Erro ao verificar permissões: $e');
      return false;
    }
  }

  /// Abre as configurações do aplicativo para o usuário conceder permissões manualmente
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
