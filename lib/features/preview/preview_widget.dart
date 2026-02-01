import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/stream_provider.dart';
import '../../core/providers/scene_provider.dart';
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import '../../core/providers/settings_provider.dart';

class PreviewWidget extends StatefulWidget {
  const PreviewWidget({super.key});

  @override
  State<PreviewWidget> createState() => _PreviewWidgetState();
}

class _PreviewWidgetState extends State<PreviewWidget> {
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StreamStateProvider>().rtmpService.initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final streamProvider = context.watch<StreamStateProvider>();
    final sceneProvider = context.watch<SceneProvider>();
    final settings = context.watch<SettingsProvider>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: streamProvider.isStreaming
              ? AppColors.live.withOpacity(0.5)
              : AppColors.surfaceLighter,
          width: streamProvider.isStreaming ? 2 : 1,
        ),
        boxShadow: streamProvider.isStreaming
            ? [
                BoxShadow(
                  color: AppColors.live.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              // Preview background
              // Preview background
              // Preview background
              if (streamProvider.rtmpService.controller != null)
                ApiVideoCameraPreview(
                    controller: streamProvider.rtmpService.controller!)
              else
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.surface,
                        AppColors.surfaceLight,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceLighter,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            streamProvider.cameraEnabled
                                ? Icons.videocam_rounded
                                : Icons.videocam_off_rounded,
                            color: AppColors.textTertiary,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Initializing Camera...',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Scene: ${sceneProvider.activeScene?.name ?? 'None'}',
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Top overlay - Status bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      // Live indicator
                      if (streamProvider.isStreaming)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.liveGradient,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              )
                                  .animate(
                                    onPlay: (c) => c.repeat(reverse: true),
                                  )
                                  .scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.3, 1.3),
                                    duration: 600.ms,
                                  ),
                              const SizedBox(width: 4),
                              const Text(
                                'LIVE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Recording indicator
                      if (streamProvider.isRecording) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.recording,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.fiber_manual_record,
                                color: Colors.white,
                                size: 10,
                              )
                                  .animate(
                                    onPlay: (c) => c.repeat(reverse: true),
                                  )
                                  .scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.3, 1.3),
                                    duration: 800.ms,
                                  ),
                              const SizedBox(width: 4),
                              Text(
                                streamProvider.formatDuration(
                                  streamProvider.recordingDuration,
                                ),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const Spacer(),

                      // Stream time
                      if (streamProvider.isStreaming)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            streamProvider.formatDuration(
                              streamProvider.streamDuration,
                            ),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Bottom overlay - Stats
              if (settings.showPreviewStats && streamProvider.isStreaming)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        _StatChip(
                          icon: Icons.people_alt_rounded,
                          value: '${streamProvider.viewerCount}',
                        ),
                        const SizedBox(width: 10),
                        _StatChip(
                          icon: Icons.speed_rounded,
                          value:
                              '${(streamProvider.bitrate / 1000).toStringAsFixed(1)}Mb/s',
                        ),
                        const SizedBox(width: 10),
                        _StatChip(
                          icon: Icons.timer_rounded,
                          value: '${streamProvider.fps}fps',
                        ),
                        const Spacer(),
                        _StatChip(
                          icon: Icons.high_quality_rounded,
                          value: settings.qualityLabel,
                        ),
                      ],
                    ),
                  ),
                ),

              // Fullscreen button
              Positioned(
                bottom: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _isFullscreen = !_isFullscreen);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _isFullscreen
                          ? Icons.fullscreen_exit_rounded
                          : Icons.fullscreen_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Scene name badge
              if (sceneProvider.activeScene != null)
                Positioned(
                  top: 44,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: sceneProvider.activeScene!.color.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.layers_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          sceneProvider.activeScene!.name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;

  const _StatChip({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 12),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
