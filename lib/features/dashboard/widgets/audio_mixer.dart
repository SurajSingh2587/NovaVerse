import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/stream_provider.dart';

class AudioMixer extends StatelessWidget {
  const AudioMixer({super.key});

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
                Icons.tune_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Audio Mixer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Advanced',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Microphone slider
          _AudioSlider(
            icon: streamProvider.isMuted 
                ? Icons.mic_off_rounded 
                : Icons.mic_rounded,
            label: 'Microphone',
            value: streamProvider.isMuted ? 0 : streamProvider.micVolume,
            color: AppColors.accentPink,
            onChanged: (value) => streamProvider.setMicVolume(value),
            onMuteToggle: () => streamProvider.toggleMute(),
            isMuted: streamProvider.isMuted,
          ),
          
          const SizedBox(height: 20),
          
          // System audio slider
          _AudioSlider(
            icon: Icons.volume_up_rounded,
            label: 'System Audio',
            value: streamProvider.systemVolume,
            color: AppColors.accent,
            onChanged: (value) => streamProvider.setSystemVolume(value),
          ),
          
          const SizedBox(height: 20),
          
          // Audio levels visualization
          _AudioLevels(),
        ],
      ),
    );
  }
}

class _AudioSlider extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;
  final VoidCallback? onMuteToggle;
  final bool isMuted;

  const _AudioSlider({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
    this.onMuteToggle,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onMuteToggle,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isMuted 
                  ? AppColors.surfaceLight 
                  : color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isMuted ? AppColors.textTertiary : color,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${(value * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  activeTrackColor: color,
                  inactiveTrackColor: color.withOpacity(0.2),
                  thumbColor: color,
                  overlayColor: color.withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                ),
                child: Slider(
                  value: value,
                  onChanged: isMuted ? null : onChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AudioLevels extends StatefulWidget {
  @override
  State<_AudioLevels> createState() => _AudioLevelsState();
}

class _AudioLevelsState extends State<_AudioLevels>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.graphic_eq_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Audio Levels',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Row(
                children: List.generate(20, (index) {
                  // Simulate audio levels
                  final now = DateTime.now().millisecondsSinceEpoch;
                  final phase = (index * 0.3) + (now / 100);
                  final height = 0.3 + 
                      (0.5 * (1 + math.sin(phase * 0.1).abs())) *
                      (index < 15 ? 1 : 0.3);
                  
                  Color barColor;
                  if (index < 12) {
                    barColor = AppColors.accentGreen;
                  } else if (index < 16) {
                    barColor = AppColors.warning;
                  } else {
                    barColor = AppColors.live;
                  }
                  
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      height: 30 * height,
                      decoration: BoxDecoration(
                        color: index < (height * 20).toInt()
                            ? barColor
                            : barColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
