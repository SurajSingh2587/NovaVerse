import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider extends ChangeNotifier {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isInitialized = false;
  bool _isInitializing = false;
  String? _error;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;
  String? get error => _error;
  bool get hasCameras => _cameras.isNotEmpty;

  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;

    _isInitializing = true;
    _error = null;
    notifyListeners();

    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        _error = 'No cameras found';
        _isInitializing = false;
        notifyListeners();
        return;
      }

      // Default to front camera for streaming if available, else first one
      _selectedCameraIndex = _cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );

      if (_selectedCameraIndex == -1) {
        _selectedCameraIndex = 0;
      }

      await _initController();
    } catch (e) {
      _error = 'Failed to initialize camera: $e';
      debugPrint(_error);
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> _initController() async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    final camera = _cameras[_selectedCameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg, // Compatible default
    );

    try {
      await _controller!.initialize();
      _isInitialized = true;
    } catch (e) {
      _error = 'Error initializing camera controller: $e';
      _isInitialized = false;
      debugPrint(_error);
    }
    notifyListeners();
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
