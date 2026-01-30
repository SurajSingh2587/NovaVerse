import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/stream_provider.dart';

class StreamStats extends StatelessWidget {
  const StreamStats({super.key});

  @override
  Widget build(BuildContext context) {
    final streamProvider = context.watch<StreamStateProvider>();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.surfaceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Stream Stats',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: streamProvider.isStreaming 
                      ? AppColors.accentGreen 
                      : AppColors.textTertiary,
                  shape: BoxShape.circle,
                  boxShadow: streamProvider.isStreaming
                      ? [
                          BoxShadow(
                            color: AppColors.accentGreen.withOpacity(0.5),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                streamProvider.isStreaming ? 'Connected' : 'Offline',
                style: TextStyle(
                  fontSize: 12,
                  color: streamProvider.isStreaming 
                      ? AppColors.accentGreen 
                      : AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Stats grid
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.people_alt_outlined,
                  label: 'Viewers',
                  value: streamProvider.viewerCount.toString(),
                  color: AppColors.accent,
                  isActive: streamProvider.isStreaming,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.speed_rounded,
                  label: 'Bitrate',
                  value: streamProvider.isStreaming 
                      ? '${(streamProvider.bitrate / 1000).toStringAsFixed(1)}M'
                      : '--',
                  color: AppColors.accentGreen,
                  isActive: streamProvider.isStreaming,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.timer_outlined,
                  label: 'FPS',
                  value: '${streamProvider.fps}',
                  color: AppColors.primary,
                  isActive: streamProvider.isStreaming,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.warning_amber_rounded,
                  label: 'Dropped',
                  value: '${streamProvider.droppedFrames}',
                  color: streamProvider.droppedFrames > 10 
                      ? AppColors.warning 
                      : AppColors.textSecondary,
                  isActive: streamProvider.isStreaming,
                ),
              ),
            ],
          ),
          
          // Health indicator
          if (streamProvider.isStreaming) ...[
            const SizedBox(height: 20),
            _StreamHealthBar(
              bitrate: streamProvider.bitrate,
              droppedFrames: streamProvider.droppedFrames,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isActive;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive 
              ? color.withOpacity(0.3) 
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isActive 
                        ? AppColors.textPrimary 
                        : AppColors.textTertiary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StreamHealthBar extends StatelessWidget {
  final double bitrate;
  final int droppedFrames;

  const _StreamHealthBar({
    required this.bitrate,
    required this.droppedFrames,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate health score (0-100)
    final bitrateScore = (bitrate / 5000).clamp(0.0, 1.0);
    final droppedScore = 1 - (droppedFrames / 100).clamp(0.0, 1.0);
    final healthScore = ((bitrateScore + droppedScore) / 2 * 100).toInt();
    
    Color healthColor;
    String healthLabel;
    if (healthScore >= 80) {
      healthColor = AppColors.accentGreen;
      healthLabel = 'Excellent';
    } else if (healthScore >= 60) {
      healthColor = AppColors.warning;
      healthLabel = 'Good';
    } else {
      healthColor = AppColors.error;
      healthLabel = 'Poor';
    }
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            healthColor.withOpacity(0.15),
            healthColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: healthColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: healthColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                healthScore >= 60 
                    ? Icons.check_circle_rounded 
                    : Icons.warning_rounded,
                color: healthColor,
                size: 22,
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.05, 1.05),
                duration: 1000.ms,
              ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Stream Health',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      healthLabel,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: healthColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: healthScore / 100,
                    backgroundColor: healthColor.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(healthColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
