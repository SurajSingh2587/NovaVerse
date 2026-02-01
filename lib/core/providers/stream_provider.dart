import 'package:flutter/material.dart';
import '../services/rtmp_service.dart';

enum StreamStatus {
  idle,
  connecting,
  live,
  reconnecting,
  error,
}

enum RecordingStatus {
  idle,
  recording,
  paused,
}

class StreamStateProvider extends ChangeNotifier {
  StreamStatus _streamStatus = StreamStatus.idle;
  RecordingStatus _recordingStatus = RecordingStatus.idle;
  Duration _streamDuration = Duration.zero;
  Duration _recordingDuration = Duration.zero;
  int _viewerCount = 0;
  double _bitrate = 0;
  final int _droppedFrames = 0;
  int _fps = 30;
  String _streamKey = '';
  String _rtmpUrl = '';
  String _selectedPlatform = 'Custom RTMP';
  bool _isMuted = false;
  double _micVolume = 0.8;
  double _systemVolume = 0.8;
  bool _cameraEnabled = true;
  bool _screenShareEnabled = false;

  // Getters
  StreamStatus get streamStatus => _streamStatus;
  RecordingStatus get recordingStatus => _recordingStatus;
  Duration get streamDuration => _streamDuration;
  Duration get recordingDuration => _recordingDuration;
  int get viewerCount => _viewerCount;
  double get bitrate => _bitrate;
  int get droppedFrames => _droppedFrames;
  int get fps => _fps;
  String get streamKey => _streamKey;
  String get rtmpUrl => _rtmpUrl;
  String get selectedPlatform => _selectedPlatform;
  bool get isMuted => _isMuted;
  double get micVolume => _micVolume;
  double get systemVolume => _systemVolume;
  bool get cameraEnabled => _cameraEnabled;
  bool get screenShareEnabled => _screenShareEnabled;

  bool get isStreaming => _streamStatus == StreamStatus.live;
  bool get isRecording => _recordingStatus == RecordingStatus.recording;
  bool get isConnecting => _streamStatus == StreamStatus.connecting;

  final RtmpService _rtmpService = RtmpService();
  RtmpService get rtmpService => _rtmpService;

  // Stream controls
  Future<void> startStream({String? url, String? key}) async {
    final targetUrl = url ?? _rtmpUrl;
    final targetKey = key ?? _streamKey;

    if (targetUrl.isEmpty || targetKey.isEmpty) {
      _streamStatus = StreamStatus.error;
      notifyListeners();
      return;
    }

    _streamStatus = StreamStatus.connecting;
    notifyListeners();

    try {
      await _rtmpService.startStream(url: targetUrl, streamKey: targetKey);

      _streamStatus = StreamStatus.live;
      _streamDuration = Duration.zero;
      _viewerCount = 0;
      notifyListeners();

      // Start duration timer
      _startStreamTimer();
    } catch (e) {
      _streamStatus = StreamStatus.error;
      debugPrint("Streaming error: $e");
      notifyListeners();
    }
  }

  Future<void> stopStream() async {
    await _rtmpService.stopStream();
    _streamStatus = StreamStatus.idle;
    _viewerCount = 0;
    _bitrate = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _rtmpService.dispose();
    super.dispose();
  }

  void _startStreamTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_streamStatus == StreamStatus.live) {
        _streamDuration += const Duration(seconds: 1);
        // Simulate varying stats
        _viewerCount = _viewerCount + (DateTime.now().second % 3 == 0 ? 1 : 0);
        _bitrate = 2500 + (DateTime.now().millisecond % 500).toDouble();
        notifyListeners();
        return true;
      }
      return false;
    });
  }

  // Recording controls
  Future<void> startRecording() async {
    _recordingStatus = RecordingStatus.recording;
    _recordingDuration = Duration.zero;
    notifyListeners();

    _startRecordingTimer();
  }

  Future<void> pauseRecording() async {
    _recordingStatus = RecordingStatus.paused;
    notifyListeners();
  }

  Future<void> resumeRecording() async {
    _recordingStatus = RecordingStatus.recording;
    notifyListeners();
    _startRecordingTimer();
  }

  Future<void> stopRecording() async {
    _recordingStatus = RecordingStatus.idle;
    notifyListeners();
  }

  void _startRecordingTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_recordingStatus == RecordingStatus.recording) {
        _recordingDuration += const Duration(seconds: 1);
        notifyListeners();
        return true;
      }
      return false;
    });
  }

  // Settings
  void setStreamKey(String key) {
    _streamKey = key;
    notifyListeners();
  }

  void setRtmpUrl(String url) {
    _rtmpUrl = url;
    notifyListeners();
  }

  void setPlatform(String platform) {
    _selectedPlatform = platform;
    notifyListeners();
  }

  void setFps(int fps) {
    _fps = fps;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void setMicVolume(double volume) {
    _micVolume = volume;
    _rtmpService.setMicVolume(volume);
    notifyListeners();
  }

  void setSystemVolume(double volume) {
    _systemVolume = volume;
    _rtmpService.setSystemVolume(volume);
    notifyListeners();
  }

  void toggleCamera() {
    _cameraEnabled = !_cameraEnabled;
    notifyListeners();
  }

  void toggleScreenShare() {
    _screenShareEnabled = !_screenShareEnabled;
    notifyListeners();
  }

  // Format duration to string
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
