import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/settings_provider.dart';

class PlatformSelector extends StatelessWidget {
  const PlatformSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.surfaceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.broadcast_on_home_rounded,
                  color: AppColors.accentGreen,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Stream To',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Platform options
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: SettingsProvider.platformPresets.keys.map((platform) {
              final isSelected = settings.streamPlatform == platform;
              return _PlatformChip(
                platform: platform,
                isSelected: isSelected,
                onTap: () {
                  HapticFeedback.lightImpact();
                  settings.setStreamPlatform(platform);
                },
              );
            }).toList(),
          ),
          
          const SizedBox(height: 20),
          
          // RTMP Server
          const Text(
            'RTMP Server',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: settings.rtmpServer),
            decoration: InputDecoration(
              hintText: 'rtmp://...',
              prefixIcon: const Icon(
                Icons.link_rounded,
                color: AppColors.textTertiary,
              ),
              enabled: settings.streamPlatform == 'Custom RTMP',
            ),
            onChanged: settings.setRtmpServer,
          ),
          
          const SizedBox(height: 16),
          
          // Stream Key
          const Text(
            'Stream Key',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: settings.streamKey),
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Your stream key',
              prefixIcon: const Icon(
                Icons.key_rounded,
                color: AppColors.textTertiary,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.visibility_rounded,
                  color: AppColors.textTertiary,
                ),
                onPressed: () {},
              ),
            ),
            onChanged: settings.setStreamKey,
          ),
          
          const SizedBox(height: 16),
          
          // Connection status indicator
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: settings.streamKey.isNotEmpty
                        ? AppColors.accentGreen
                        : AppColors.textTertiary,
                    shape: BoxShape.circle,
                    boxShadow: settings.streamKey.isNotEmpty
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
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    settings.streamKey.isNotEmpty
                        ? 'Ready to stream to ${settings.streamPlatform}'
                        : 'Enter stream key to connect',
                    style: TextStyle(
                      fontSize: 13,
                      color: settings.streamKey.isNotEmpty
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                  ),
                ),
                if (settings.streamKey.isNotEmpty)
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text(
                      'Test',
                      style: TextStyle(fontSize: 13),
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

class _PlatformChip extends StatelessWidget {
  final String platform;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlatformChip({
    required this.platform,
    required this.isSelected,
    required this.onTap,
  });
  
  IconData get _icon {
    switch (platform) {
      case 'YouTube':
        return Icons.play_circle_filled_rounded;
      case 'Twitch':
        return Icons.stream_rounded;
      case 'Facebook':
        return Icons.facebook_rounded;
      case 'Instagram':
        return Icons.camera_alt_rounded;
      case 'TikTok':
        return Icons.music_note_rounded;
      default:
        return Icons.settings_input_antenna_rounded;
    }
  }
  
  Color get _color {
    switch (platform) {
      case 'YouTube':
        return const Color(0xFFFF0000);
      case 'Twitch':
        return const Color(0xFF9146FF);
      case 'Facebook':
        return const Color(0xFF1877F2);
      case 'Instagram':
        return const Color(0xFFE4405F);
      case 'TikTok':
        return const Color(0xFF000000);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _color.withOpacity(0.15) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? _color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _icon,
              color: isSelected ? _color : AppColors.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              platform,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? _color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
