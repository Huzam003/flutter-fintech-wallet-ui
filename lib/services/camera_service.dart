import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();

  factory CameraService() {
    return _instance;
  }

  CameraService._internal();

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  CameraController? get cameraController => _cameraController;

  Future<void> initializeCameras() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      debugPrint('Error initializing cameras: $e');
    }
  }

  Future<void> initializeCamera(CameraDescription camera) async {
    try {
      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
      );
      await _cameraController?.initialize();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<String?> takePicture() async {
    try {
      if (_cameraController == null || !_cameraController!.value.isInitialized) {
        return null;
      }

      final XFile picture = await _cameraController!.takePicture();
      return picture.path;
    } catch (e) {
      debugPrint('Error taking picture: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    try {
      await _cameraController?.dispose();
    } catch (e) {
      debugPrint('Error disposing camera: $e');
    }
  }

  List<CameraDescription>? get cameras => _cameras;
}
