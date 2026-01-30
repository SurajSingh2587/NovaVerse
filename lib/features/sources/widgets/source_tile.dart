import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/scene_provider.dart';

class SourceTile extends StatelessWidget {
  final Source source;
  final int index;
  final int totalCount;
  final VoidCallback onTap;
  final VoidCallback onVisibilityToggle;
  final VoidCallback onMuteToggle;
  final VoidCallback onDelete;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final VoidCallback onDuplicate;

  const SourceTile({
    super.key,
    required this.source,
    required this.index,
    required this.totalCount,
    required this.onTap,
    required this.onVisibilityToggle,
    required this.onMuteToggle,
    required this.onDelete,
    this.onMoveUp,
    this.onMoveDown,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(source.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_rounded,
          color: AppColors.error,
          size: 24,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showSourceOptions(context),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.surfaceLighter,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Source type icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: source.color.withOpacity(source.isVisible ? 0.15 : 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  source.icon,
                  color: source.isVisible 
                      ? source.color 
                      : source.color.withOpacity(0.4),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              
              // Source info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: source.isVisible 
                            ? AppColors.textPrimary 
                            : AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _getSourceTypeLabel(source.type),
                          style: TextStyle(
                            fontSize: 12,
                            color: source.color.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 12,
                          color: AppColors.surfaceLighter,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Layer ${totalCount - index}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Quick actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Visibility toggle
                  _QuickActionButton(
                    icon: source.isVisible
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: source.isVisible
                        ? AppColors.textSecondary
                        : AppColors.textTertiary,
                    onTap: onVisibilityToggle,
                  ),
                  
                  // Mute toggle (for audio sources)
                  if (source.type == SourceType.audio ||
                      source.type == SourceType.camera ||
                      source.type == SourceType.video)
                    _QuickActionButton(
                      icon: source.isMuted
                          ? Icons.volume_off_rounded
                          : Icons.volume_up_rounded,
                      color: source.isMuted
                          ? AppColors.textTertiary
                          : AppColors.textSecondary,
                      onTap: onMuteToggle,
                    ),
                  
                  // More options
                  _QuickActionButton(
                    icon: Icons.more_vert_rounded,
                    color: AppColors.textTertiary,
                    onTap: () => _showSourceOptions(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getSourceTypeLabel(SourceType type) {
    switch (type) {
      case SourceType.camera:
        return 'Camera';
      case SourceType.screenCapture:
        return 'Screen Capture';
      case SourceType.image:
        return 'Image';
      case SourceType.text:
        return 'Text';
      case SourceType.audio:
        return 'Audio';
      case SourceType.browser:
        return 'Browser';
      case SourceType.video:
        return 'Video';
      case SourceType.gameCapture:
        return 'Game Capture';
    }
  }
  
  void _showSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceLighter,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: source.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    source.icon,
                    color: source.color,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      _getSourceTypeLabel(source.type),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _OptionTile(
              icon: Icons.edit_rounded,
              label: 'Edit Source',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _OptionTile(
              icon: source.isVisible
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              label: source.isVisible ? 'Hide Source' : 'Show Source',
              onTap: () {
                onVisibilityToggle();
                Navigator.pop(context);
              },
            ),
            if (onMoveUp != null)
              _OptionTile(
                icon: Icons.arrow_upward_rounded,
                label: 'Move Up (Front)',
                onTap: () {
                  onMoveUp!();
                  Navigator.pop(context);
                },
              ),
            if (onMoveDown != null)
              _OptionTile(
                icon: Icons.arrow_downward_rounded,
                label: 'Move Down (Back)',
                onTap: () {
                  onMoveDown!();
                  Navigator.pop(context);
                },
              ),
            _OptionTile(
              icon: Icons.copy_rounded,
              label: 'Duplicate Source',
              onTap: () {
                onDuplicate();
                Navigator.pop(context);
              },
            ),
            _OptionTile(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Source',
              color: AppColors.error,
              onTap: () {
                onDelete();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.textPrimary;
    
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: tileColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: tileColor, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: tileColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
