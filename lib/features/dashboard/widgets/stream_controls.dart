import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/stream_provider.dart';
import '../../../core/providers/settings_provider.dart';

class StreamControls extends StatelessWidget {
  const StreamControls({super.key});

  @override
  Widget build(BuildContext context) {
    final streamProvider = context.watch<StreamStateProvider>();
    final settings = context.watch<SettingsProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.surfaceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.play_circle_outline_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Stream Controls',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (streamProvider.isStreaming)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.liveGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.live.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.3, 1.3),
                            duration: 600.ms,
                          ),
                      const SizedBox(width: 6),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Stream timer
          if (streamProvider.isStreaming) ...[
            Center(
              child: Text(
                streamProvider.formatDuration(streamProvider.streamDuration),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w200,
                  color: AppColors.textPrimary,
                  letterSpacing: 4,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Main buttons
          Row(
            children: [
              // Start/Stop Stream button
              Expanded(
                flex: 2,
                child: _StreamButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    if (streamProvider.isStreaming) {
                      await streamProvider.stopStream();
                    } else {
                      await streamProvider.startStream(
                        url: settings.rtmpServer,
                        key: settings.streamKey,
                      );
                    }
                  },
                  isActive: streamProvider.isStreaming,
                  isLoading: streamProvider.isConnecting,
                  activeGradient: AppColors.liveGradient,
                  inactiveColor: AppColors.primary,
                  icon: streamProvider.isStreaming
                      ? Icons.stop_rounded
                      : Icons.play_arrow_rounded,
                  label: streamProvider.isConnecting
                      ? 'Connecting...'
                      : streamProvider.isStreaming
                          ? 'End Stream'
                          : 'Go Live',
                ),
              ),
              const SizedBox(width: 12),

              // Record button
              Expanded(
                child: _StreamButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    if (streamProvider.isRecording) {
                      await streamProvider.stopRecording();
                    } else {
                      await streamProvider.startRecording();
                    }
                  },
                  isActive: streamProvider.isRecording,
                  activeColor: AppColors.recording,
                  inactiveColor: AppColors.surfaceLighter,
                  icon: Icons.fiber_manual_record_rounded,
                  label: 'REC',
                  compact: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Secondary controls
          Row(
            children: [
              // Camera toggle
              Expanded(
                child: _ControlChip(
                  icon: streamProvider.cameraEnabled
                      ? Icons.videocam_rounded
                      : Icons.videocam_off_rounded,
                  label: 'Camera',
                  isActive: streamProvider.cameraEnabled,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    streamProvider.toggleCamera();
                  },
                ),
              ),
              const SizedBox(width: 10),

              // Mic toggle
              Expanded(
                child: _ControlChip(
                  icon: streamProvider.isMuted
                      ? Icons.mic_off_rounded
                      : Icons.mic_rounded,
                  label: 'Mic',
                  isActive: !streamProvider.isMuted,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    streamProvider.toggleMute();
                  },
                ),
              ),
              const SizedBox(width: 10),

              // Screen share toggle
              Expanded(
                child: _ControlChip(
                  icon: Icons.screen_share_rounded,
                  label: 'Screen',
                  isActive: streamProvider.screenShareEnabled,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    streamProvider.toggleScreenShare();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreamButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;
  final bool isLoading;
  final LinearGradient? activeGradient;
  final Color? activeColor;
  final Color inactiveColor;
  final IconData icon;
  final String label;
  final bool compact;

  const _StreamButton({
    required this.onPressed,
    required this.isActive,
    this.isLoading = false,
    this.activeGradient,
    this.activeColor,
    required this.inactiveColor,
    required this.icon,
    required this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: compact ? 50 : 56,
        decoration: BoxDecoration(
          gradient: isActive ? activeGradient : null,
          color: isActive
              ? (activeGradient == null ? activeColor : null)
              : inactiveColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: (activeColor ?? AppColors.live).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      size: compact ? 20 : 24,
                    ),
                    if (!compact) ...[
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              isActive ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

class _ControlChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ControlChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.2)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppColors.primary.withOpacity(0.5)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textTertiary,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
