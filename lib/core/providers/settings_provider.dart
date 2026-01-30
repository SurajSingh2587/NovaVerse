import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StreamQuality {
  low,      // 480p
  medium,   // 720p
  high,     // 1080p
  ultra,    // 1440p
}

enum VideoEncoder {
  h264,
  h265,
  vp9,
}

class SettingsProvider extends ChangeNotifier {
  // Video settings
  StreamQuality _streamQuality = StreamQuality.high;
  int _videoBitrate = 4500;
  int _fps = 30;
  VideoEncoder _encoder = VideoEncoder.h264;
  String _outputResolution = '1920x1080';
  
  // Audio settings
  int _audioBitrate = 160;
  String _audioSampleRate = '48kHz';
  bool _noiseSupression = true;
  bool _echoCancellation = true;
  
  // Stream settings
  String _streamPlatform = 'Custom RTMP';
  String _rtmpServer = '';
  String _streamKey = '';
  bool _autoReconnect = true;
  int _reconnectDelay = 10;
  
  // Recording settings
  String _recordingFormat = 'mp4';
  String _recordingPath = '';
  bool _splitRecording = false;
  int _splitDuration = 30; // minutes
  
  // Advanced settings
  bool _hardwareAcceleration = true;
  bool _lowLatencyMode = false;
  int _keyframeInterval = 2;
  String _colorSpace = 'sRGB';
  
  // App settings
  bool _darkMode = true;
  bool _showPreviewStats = true;
  bool _keepScreenAwake = true;
  bool _confirmBeforeStop = true;
  
  // Platform presets
  static const Map<String, Map<String, String>> platformPresets = {
    'YouTube': {
      'rtmpServer': 'rtmp://a.rtmp.youtube.com/live2',
      'icon': 'youtube',
    },
    'Twitch': {
      'rtmpServer': 'rtmp://live.twitch.tv/app',
      'icon': 'twitch',
    },
    'Facebook': {
      'rtmpServer': 'rtmps://live-api-s.facebook.com:443/rtmp/',
      'icon': 'facebook',
    },
    'Instagram': {
      'rtmpServer': 'rtmps://live-upload.instagram.com:443/rtmp/',
      'icon': 'instagram',
    },
    'TikTok': {
      'rtmpServer': 'rtmp://push.tiktok.com/live',
      'icon': 'tiktok',
    },
    'Custom RTMP': {
      'rtmpServer': '',
      'icon': 'custom',
    },
  };

  // Quality presets
  static const Map<StreamQuality, Map<String, dynamic>> qualityPresets = {
    StreamQuality.low: {
      'resolution': '854x480',
      'bitrate': 1500,
      'fps': 30,
      'label': '480p',
    },
    StreamQuality.medium: {
      'resolution': '1280x720',
      'bitrate': 3000,
      'fps': 30,
      'label': '720p',
    },
    StreamQuality.high: {
      'resolution': '1920x1080',
      'bitrate': 4500,
      'fps': 30,
      'label': '1080p',
    },
    StreamQuality.ultra: {
      'resolution': '2560x1440',
      'bitrate': 9000,
      'fps': 60,
      'label': '1440p',
    },
  };

  // Getters
  StreamQuality get streamQuality => _streamQuality;
  int get videoBitrate => _videoBitrate;
  int get fps => _fps;
  VideoEncoder get encoder => _encoder;
  String get outputResolution => _outputResolution;
  int get audioBitrate => _audioBitrate;
  String get audioSampleRate => _audioSampleRate;
  bool get noiseSupression => _noiseSupression;
  bool get echoCancellation => _echoCancellation;
  String get streamPlatform => _streamPlatform;
  String get rtmpServer => _rtmpServer;
  String get streamKey => _streamKey;
  bool get autoReconnect => _autoReconnect;
  int get reconnectDelay => _reconnectDelay;
  String get recordingFormat => _recordingFormat;
  String get recordingPath => _recordingPath;
  bool get splitRecording => _splitRecording;
  int get splitDuration => _splitDuration;
  bool get hardwareAcceleration => _hardwareAcceleration;
  bool get lowLatencyMode => _lowLatencyMode;
  int get keyframeInterval => _keyframeInterval;
  String get colorSpace => _colorSpace;
  bool get darkMode => _darkMode;
  bool get showPreviewStats => _showPreviewStats;
  bool get keepScreenAwake => _keepScreenAwake;
  bool get confirmBeforeStop => _confirmBeforeStop;

  String get qualityLabel => qualityPresets[_streamQuality]!['label'] as String;

  // Video settings
  void setStreamQuality(StreamQuality quality) {
    _streamQuality = quality;
    final preset = qualityPresets[quality]!;
    _outputResolution = preset['resolution'] as String;
    _videoBitrate = preset['bitrate'] as int;
    _fps = preset['fps'] as int;
    notifyListeners();
    _saveSettings();
  }

  void setVideoBitrate(int bitrate) {
    _videoBitrate = bitrate;
    notifyListeners();
    _saveSettings();
  }

  void setFps(int fps) {
    _fps = fps;
    notifyListeners();
    _saveSettings();
  }

  void setEncoder(VideoEncoder encoder) {
    _encoder = encoder;
    notifyListeners();
    _saveSettings();
  }

  // Audio settings
  void setAudioBitrate(int bitrate) {
    _audioBitrate = bitrate;
    notifyListeners();
    _saveSettings();
  }

  void toggleNoiseSupression() {
    _noiseSupression = !_noiseSupression;
    notifyListeners();
    _saveSettings();
  }

  void toggleEchoCancellation() {
    _echoCancellation = !_echoCancellation;
    notifyListeners();
    _saveSettings();
  }

  // Stream settings
  void setStreamPlatform(String platform) {
    _streamPlatform = platform;
    if (platformPresets.containsKey(platform)) {
      _rtmpServer = platformPresets[platform]!['rtmpServer']!;
    }
    notifyListeners();
    _saveSettings();
  }

  void setRtmpServer(String server) {
    _rtmpServer = server;
    notifyListeners();
    _saveSettings();
  }

  void setStreamKey(String key) {
    _streamKey = key;
    notifyListeners();
    _saveSettings();
  }

  void toggleAutoReconnect() {
    _autoReconnect = !_autoReconnect;
    notifyListeners();
    _saveSettings();
  }

  // Recording settings
  void setRecordingFormat(String format) {
    _recordingFormat = format;
    notifyListeners();
    _saveSettings();
  }

  void setRecordingPath(String path) {
    _recordingPath = path;
    notifyListeners();
    _saveSettings();
  }

  void toggleSplitRecording() {
    _splitRecording = !_splitRecording;
    notifyListeners();
    _saveSettings();
  }

  void setSplitDuration(int minutes) {
    _splitDuration = minutes;
    notifyListeners();
    _saveSettings();
  }

  // Advanced settings
  void toggleHardwareAcceleration() {
    _hardwareAcceleration = !_hardwareAcceleration;
    notifyListeners();
    _saveSettings();
  }

  void toggleLowLatencyMode() {
    _lowLatencyMode = !_lowLatencyMode;
    notifyListeners();
    _saveSettings();
  }

  void setKeyframeInterval(int seconds) {
    _keyframeInterval = seconds;
    notifyListeners();
    _saveSettings();
  }

  // App settings
  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
    _saveSettings();
  }

  void toggleShowPreviewStats() {
    _showPreviewStats = !_showPreviewStats;
    notifyListeners();
    _saveSettings();
  }

  void toggleKeepScreenAwake() {
    _keepScreenAwake = !_keepScreenAwake;
    notifyListeners();
    _saveSettings();
  }

  void toggleConfirmBeforeStop() {
    _confirmBeforeStop = !_confirmBeforeStop;
    notifyListeners();
    _saveSettings();
  }

  // Persistence
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streamQuality', _streamQuality.index);
    await prefs.setInt('videoBitrate', _videoBitrate);
    await prefs.setInt('fps', _fps);
    await prefs.setInt('encoder', _encoder.index);
    await prefs.setInt('audioBitrate', _audioBitrate);
    await prefs.setBool('noiseSupression', _noiseSupression);
    await prefs.setBool('echoCancellation', _echoCancellation);
    await prefs.setString('streamPlatform', _streamPlatform);
    await prefs.setString('rtmpServer', _rtmpServer);
    await prefs.setString('streamKey', _streamKey);
    await prefs.setBool('autoReconnect', _autoReconnect);
    await prefs.setString('recordingFormat', _recordingFormat);
    await prefs.setString('recordingPath', _recordingPath);
    await prefs.setBool('splitRecording', _splitRecording);
    await prefs.setInt('splitDuration', _splitDuration);
    await prefs.setBool('hardwareAcceleration', _hardwareAcceleration);
    await prefs.setBool('lowLatencyMode', _lowLatencyMode);
    await prefs.setInt('keyframeInterval', _keyframeInterval);
    await prefs.setBool('darkMode', _darkMode);
    await prefs.setBool('showPreviewStats', _showPreviewStats);
    await prefs.setBool('keepScreenAwake', _keepScreenAwake);
    await prefs.setBool('confirmBeforeStop', _confirmBeforeStop);
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _streamQuality = StreamQuality.values[prefs.getInt('streamQuality') ?? 2];
    _videoBitrate = prefs.getInt('videoBitrate') ?? 4500;
    _fps = prefs.getInt('fps') ?? 30;
    _encoder = VideoEncoder.values[prefs.getInt('encoder') ?? 0];
    _audioBitrate = prefs.getInt('audioBitrate') ?? 160;
    _noiseSupression = prefs.getBool('noiseSupression') ?? true;
    _echoCancellation = prefs.getBool('echoCancellation') ?? true;
    _streamPlatform = prefs.getString('streamPlatform') ?? 'Custom RTMP';
    _rtmpServer = prefs.getString('rtmpServer') ?? '';
    _streamKey = prefs.getString('streamKey') ?? '';
    _autoReconnect = prefs.getBool('autoReconnect') ?? true;
    _recordingFormat = prefs.getString('recordingFormat') ?? 'mp4';
    _recordingPath = prefs.getString('recordingPath') ?? '';
    _splitRecording = prefs.getBool('splitRecording') ?? false;
    _splitDuration = prefs.getInt('splitDuration') ?? 30;
    _hardwareAcceleration = prefs.getBool('hardwareAcceleration') ?? true;
    _lowLatencyMode = prefs.getBool('lowLatencyMode') ?? false;
    _keyframeInterval = prefs.getInt('keyframeInterval') ?? 2;
    _darkMode = prefs.getBool('darkMode') ?? true;
    _showPreviewStats = prefs.getBool('showPreviewStats') ?? true;
    _keepScreenAwake = prefs.getBool('keepScreenAwake') ?? true;
    _confirmBeforeStop = prefs.getBool('confirmBeforeStop') ?? true;
    
    // Apply quality preset
    final preset = qualityPresets[_streamQuality]!;
    _outputResolution = preset['resolution'] as String;
    
    notifyListeners();
  }

  // Reset to defaults
  void resetToDefaults() {
    _streamQuality = StreamQuality.high;
    _videoBitrate = 4500;
    _fps = 30;
    _encoder = VideoEncoder.h264;
    _outputResolution = '1920x1080';
    _audioBitrate = 160;
    _audioSampleRate = '48kHz';
    _noiseSupression = true;
    _echoCancellation = true;
    _streamPlatform = 'Custom RTMP';
    _rtmpServer = '';
    _streamKey = '';
    _autoReconnect = true;
    _reconnectDelay = 10;
    _recordingFormat = 'mp4';
    _recordingPath = '';
    _splitRecording = false;
    _splitDuration = 30;
    _hardwareAcceleration = true;
    _lowLatencyMode = false;
    _keyframeInterval = 2;
    _colorSpace = 'sRGB';
    _darkMode = true;
    _showPreviewStats = true;
    _keepScreenAwake = true;
    _confirmBeforeStop = true;
    notifyListeners();
    _saveSettings();
  }
}
