import 'package:flutter/material.dart';

// Stub classes for Web
class LiveStreamController {
  LiveStreamController(
      {dynamic initialAudioConfig, dynamic initialVideoConfig});

  Future<void> create() async {}
  Future<void> startStreaming(
      {required String streamKey, required String url}) async {}
  Future<void> stopStreaming() async {}
  void switchCamera() {}
  void toggleMute() {}
  void dispose() {}
}

class AudioConfig {
  final int bitrate;
  final dynamic channel;
  AudioConfig({required this.bitrate, required this.channel});
}

class VideoConfig {
  static withDefaultBitrate({required dynamic resolution}) {
    return VideoConfig();
  }
}

class AudioChannel {
  static const stereo = 0;
}

class VideoResolution {
  static const res720p = 0;
}

class ApiVideoCameraPreview extends StatelessWidget {
  final LiveStreamController controller;
  const ApiVideoCameraPreview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: const Center(child: Text("Web Preview Not Supported")));
  }
}
