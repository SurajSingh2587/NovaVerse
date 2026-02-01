import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

// Debugging: Ensure apivideo_live_stream is loaded
// import 'package:apivideo_live_stream/apivideo_live_stream.dart';

class RtmpService extends ChangeNotifier {
  ApiVideoLiveStreamController? _controller;
  bool _isStreaming = false;

  bool get isStreaming => _isStreaming;
  ApiVideoLiveStreamController? get controller => _controller;

  Future<void> initialize() async {
    // Check permissions
    await [
      Permission.camera,
      Permission.microphone,
    ].request();

    try {
      _controller = ApiVideoLiveStreamController(
        initialAudioConfig: AudioConfig(
          bitrate: 128 * 1000,
          channel: Channel.stereo,
        ),
        initialVideoConfig: VideoConfig.withDefaultBitrate(
          resolution: Resolution.RESOLUTION_720,
        ),
      );

      // Initialize controller (might involve creating tracks)
      // Note: create() is often async
      await _controller?.initialize();
      notifyListeners();
    } catch (e) {
      debugPrint("Error initializing RtmpService: $e");
    }
  }

  Future<void> startStream({
    required String url,
    required String streamKey,
  }) async {
    if (_controller == null) await initialize();

    try {
      await _controller?.startStreaming(
        streamKey: streamKey,
        url: url,
      );
      _isStreaming = true;
      notifyListeners();
    } catch (e) {
      debugPrint("Error starting stream: $e");
      _isStreaming = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> stopStream() async {
    try {
      await _controller?.stopStreaming();
    } catch (e) {
      debugPrint("Error stopping stream: $e");
    }
    _isStreaming = false;
    notifyListeners();
  }

  void setMicVolume(double volume) {
    if (_controller != null) {
      // apivideo_live_stream 1.2.0 might use setAudioConfig or similar,
      // or audioVolume property if available.
      // If not directly available in this version, we log it.
      // _controller!.setAudioConfig(...);
    }
  }

  void setSystemVolume(double volume) {
    // Not typically supported directly for system audio capture on mobile without special permissions
  }

  void switchCamera() {
    _controller?.switchCamera();
  }

  void toggleMute() {
    _controller?.toggleMute();
  }

  @override
  void dispose() {
    _controller?.dispose(); // Release resources
    super.dispose();
  }
}
