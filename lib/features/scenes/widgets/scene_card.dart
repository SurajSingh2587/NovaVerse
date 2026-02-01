import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/scene_provider.dart';

class SceneCard extends StatelessWidget {
  final Scene scene;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const SceneCard({
    super.key,
    required this.scene,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scene.isActive 
              ? scene.color.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: scene.isActive 
                ? scene.color.withOpacity(0.5)
                : AppColors.surfaceLighter,
            width: scene.isActive ? 2 : 1,
          ),
          boxShadow: scene.isActive
              ? [
                  BoxShadow(
                    color: scene.color.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Scene color indicator
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: scene.color.withOpacity(scene.isActive ? 1 : 0.6),
                borderRadius: BorderRadius.circular(12),
                boxShadow: scene.isActive
                    ? [
                        BoxShadow(
                          color: scene.color.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.layers_rounded,
                color: Colors.white.withOpacity(scene.isActive ? 1 : 0.8),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            
            // Scene info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          scene.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: scene.isActive 
                                ? FontWeight.bold 
                                : FontWeight.w500,
                            color: scene.isActive 
                                ? AppColors.textPrimary 
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (scene.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'ACTIVE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentGreen,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Sources preview
                  Row(
                    children: [
                      const Icon(
                        Icons.view_in_ar_rounded,
                        color: AppColors.textTertiary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${scene.sources.length} sources',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      if (scene.sources.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 12,
                          color: AppColors.surfaceLighter,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            children: scene.sources.take(4).map((source) {
                              return Container(
                                margin: const EdgeInsets.only(right: 4),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: source.color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Icon(
                                  source.icon,
                                  color: source.color,
                                  size: 12,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Arrow indicator
            Icon(
              Icons.chevron_right_rounded,
              color: scene.isActive 
                  ? scene.color 
                  : AppColors.textTertiary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
