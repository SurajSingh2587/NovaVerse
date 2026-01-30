import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/settings_provider.dart';
import 'widgets/settings_section.dart';
import 'widgets/platform_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.background,
            title: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.restore_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                onPressed: () => _showResetConfirmation(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Stream Platform Section
                  const PlatformSelector()
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1),
                  
                  const SizedBox(height: 20),
                  
                  // Video Settings
                  SettingsSection(
                    title: 'Video',
                    icon: Icons.videocam_rounded,
                    children: [
                      _QualitySelector(
                        value: settings.streamQuality,
                        onChanged: settings.setStreamQuality,
                      ),
                      const SizedBox(height: 16),
                      _SliderSetting(
                        label: 'Bitrate',
                        value: settings.videoBitrate.toDouble(),
                        min: 1000,
                        max: 12000,
                        divisions: 22,
                        unit: 'kbps',
                        onChanged: (v) => settings.setVideoBitrate(v.toInt()),
                      ),
                      const SizedBox(height: 16),
                      _SegmentedSetting<int>(
                        label: 'Frame Rate',
                        value: settings.fps,
                        options: const [24, 30, 60],
                        optionLabels: const ['24 fps', '30 fps', '60 fps'],
                        onChanged: settings.setFps,
                      ),
                      const SizedBox(height: 16),
                      _DropdownSetting<VideoEncoder>(
                        label: 'Encoder',
                        value: settings.encoder,
                        items: const [
                          DropdownMenuItem(
                            value: VideoEncoder.h264,
                            child: Text('H.264'),
                          ),
                          DropdownMenuItem(
                            value: VideoEncoder.h265,
                            child: Text('H.265 (HEVC)'),
                          ),
                          DropdownMenuItem(
                            value: VideoEncoder.vp9,
                            child: Text('VP9'),
                          ),
                        ],
                        onChanged: (v) => settings.setEncoder(v!),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms)
                      .slideY(begin: 0.1),
                  
                  const SizedBox(height: 20),
                  
                  // Audio Settings
                  SettingsSection(
                    title: 'Audio',
                    icon: Icons.headphones_rounded,
                    children: [
                      _SliderSetting(
                        label: 'Audio Bitrate',
                        value: settings.audioBitrate.toDouble(),
                        min: 64,
                        max: 320,
                        divisions: 8,
                        unit: 'kbps',
                        onChanged: (v) => settings.setAudioBitrate(v.toInt()),
                      ),
                      const SizedBox(height: 16),
                      _SwitchSetting(
                        label: 'Noise Suppression',
                        description: 'Reduce background noise',
                        value: settings.noiseSupression,
                        onChanged: (_) => settings.toggleNoiseSupression(),
                      ),
                      _SwitchSetting(
                        label: 'Echo Cancellation',
                        description: 'Prevent audio feedback',
                        value: settings.echoCancellation,
                        onChanged: (_) => settings.toggleEchoCancellation(),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideY(begin: 0.1),
                  
                  const SizedBox(height: 20),
                  
                  // Recording Settings
                  SettingsSection(
                    title: 'Recording',
                    icon: Icons.fiber_manual_record_rounded,
                    children: [
                      _SegmentedSetting<String>(
                        label: 'Format',
                        value: settings.recordingFormat,
                        options: const ['mp4', 'mkv', 'mov'],
                        optionLabels: const ['MP4', 'MKV', 'MOV'],
                        onChanged: settings.setRecordingFormat,
                      ),
                      const SizedBox(height: 16),
                      _SwitchSetting(
                        label: 'Split Recording',
                        description: 'Split into ${settings.splitDuration}min segments',
                        value: settings.splitRecording,
                        onChanged: (_) => settings.toggleSplitRecording(),
                      ),
                      if (settings.splitRecording) ...[
                        const SizedBox(height: 12),
                        _SliderSetting(
                          label: 'Split Duration',
                          value: settings.splitDuration.toDouble(),
                          min: 5,
                          max: 60,
                          divisions: 11,
                          unit: 'min',
                          onChanged: (v) => settings.setSplitDuration(v.toInt()),
                        ),
                      ],
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideY(begin: 0.1),
                  
                  const SizedBox(height: 20),
                  
                  // Advanced Settings
                  SettingsSection(
                    title: 'Advanced',
                    icon: Icons.tune_rounded,
                    children: [
                      _SwitchSetting(
                        label: 'Hardware Acceleration',
                        description: 'Use GPU for encoding',
                        value: settings.hardwareAcceleration,
                        onChanged: (_) => settings.toggleHardwareAcceleration(),
                      ),
                      _SwitchSetting(
                        label: 'Low Latency Mode',
                        description: 'Optimize for real-time streaming',
                        value: settings.lowLatencyMode,
                        onChanged: (_) => settings.toggleLowLatencyMode(),
                      ),
                      const SizedBox(height: 16),
                      _SliderSetting(
                        label: 'Keyframe Interval',
                        value: settings.keyframeInterval.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        unit: 's',
                        onChanged: (v) => settings.setKeyframeInterval(v.toInt()),
                      ),
                      const SizedBox(height: 16),
                      _SwitchSetting(
                        label: 'Auto Reconnect',
                        description: 'Automatically reconnect on disconnect',
                        value: settings.autoReconnect,
                        onChanged: (_) => settings.toggleAutoReconnect(),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms)
                      .slideY(begin: 0.1),
                  
                  const SizedBox(height: 20),
                  
                  // App Settings
                  SettingsSection(
                    title: 'App',
                    icon: Icons.phone_android_rounded,
                    children: [
                      _SwitchSetting(
                        label: 'Show Preview Stats',
                        description: 'Display stats on preview',
                        value: settings.showPreviewStats,
                        onChanged: (_) => settings.toggleShowPreviewStats(),
                      ),
                      _SwitchSetting(
                        label: 'Keep Screen Awake',
                        description: 'Prevent screen from sleeping',
                        value: settings.keepScreenAwake,
                        onChanged: (_) => settings.toggleKeepScreenAwake(),
                      ),
                      _SwitchSetting(
                        label: 'Confirm Before Stop',
                        description: 'Ask before ending stream',
                        value: settings.confirmBeforeStop,
                        onChanged: (_) => settings.toggleConfirmBeforeStop(),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 400.ms)
                      .slideY(begin: 0.1),
                  
                  const SizedBox(height: 20),
                  
                  // About Section
                  _AboutSection()
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 400.ms),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showResetConfirmation(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SettingsProvider>().resetToDefaults();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Settings reset to defaults'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.surfaceLighter,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _QualitySelector extends StatelessWidget {
  final StreamQuality value;
  final ValueChanged<StreamQuality> onChanged;

  const _QualitySelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stream Quality',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: StreamQuality.values.map((quality) {
            final isSelected = quality == value;
            final preset = SettingsProvider.qualityPresets[quality]!;
            
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onChanged(quality);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                    right: quality != StreamQuality.ultra ? 8 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.15)
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        preset['label'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${(preset['bitrate'] as int) ~/ 1000}Mb/s',
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.8)
                              : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SliderSetting extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String unit;
  final ValueChanged<double> onChanged;

  const _SliderSetting({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                color: AppColors.textSecondary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${value.toInt()} $unit',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _SwitchSetting extends StatelessWidget {
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSetting({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SegmentedSetting<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> options;
  final List<String> optionLabels;
  final ValueChanged<T> onChanged;

  const _SegmentedSetting({
    required this.label,
    required this.value,
    required this.options,
    required this.optionLabels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(options.length, (index) {
            final option = options[index];
            final isSelected = option == value;
            
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onChanged(option);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                    right: index < options.length - 1 ? 8 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.15)
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      optionLabels[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _DropdownSetting<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownSetting({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: AppColors.surface,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.surfaceCard(),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.stream_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'NovaVerse',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Stream Anywhere, Everywhere',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            children: [
              _LinkChip(
                icon: Icons.description_rounded,
                label: 'Docs',
                onTap: () {},
              ),
              _LinkChip(
                icon: Icons.privacy_tip_rounded,
                label: 'Privacy',
                onTap: () {},
              ),
              _LinkChip(
                icon: Icons.gavel_rounded,
                label: 'Terms',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinkChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LinkChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
