import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/scene_provider.dart';
import 'widgets/source_tile.dart';
import 'widgets/add_source_dialog.dart';

class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sceneProvider = context.watch<SceneProvider>();
    final activeScene = sceneProvider.activeScene;
    final sources = activeScene?.sources ?? [];
    
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.background,
            title: const Text(
              'Sources',
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
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                onPressed: () => _showAddSourceDialog(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          // Active scene info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  if (activeScene != null) ...[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: activeScene.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    activeScene != null
                        ? 'Sources for "${activeScene.name}"'
                        : 'No scene selected',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 300.ms),
            ),
          ),
          
          // Source types panel
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SourceTypesPanel()
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1),
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
          
          // Section header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.view_in_ar_rounded,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Current Sources',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${sources.length} sources',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),
          
          // Sources list
          if (sources.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _EmptySourcesView(
                  onAddSource: () => _showAddSourceDialog(context),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final source = sources[index];
                    return SourceTile(
                      source: source,
                      index: index,
                      totalCount: sources.length,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        sceneProvider.selectSource(source.id);
                      },
                      onVisibilityToggle: () {
                        HapticFeedback.lightImpact();
                        sceneProvider.toggleSourceVisibility(source.id);
                      },
                      onMuteToggle: () {
                        HapticFeedback.lightImpact();
                        sceneProvider.toggleSourceMute(source.id);
                      },
                      onDelete: () {
                        HapticFeedback.mediumImpact();
                        sceneProvider.removeSource(source.id);
                      },
                      onMoveUp: index < sources.length - 1
                          ? () {
                              HapticFeedback.lightImpact();
                              sceneProvider.moveSourceUp(source.id);
                            }
                          : null,
                      onMoveDown: index > 0
                          ? () {
                              HapticFeedback.lightImpact();
                              sceneProvider.moveSourceDown(source.id);
                            }
                          : null,
                      onDuplicate: () {
                        HapticFeedback.mediumImpact();
                        sceneProvider.duplicateSource(source.id);
                      },
                    )
                        .animate()
                        .fadeIn(
                          delay: Duration(milliseconds: 50 * index),
                          duration: 300.ms,
                        )
                        .slideX(begin: 0.1);
                  },
                  childCount: sources.length,
                ),
              ),
            ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }
  
  void _showAddSourceDialog(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddSourceDialog(),
    );
  }
}

class _SourceTypesPanel extends StatelessWidget {
  final List<_SourceTypeItem> sourceTypes = [
    _SourceTypeItem(
      type: SourceType.camera,
      icon: Icons.videocam_rounded,
      label: 'Camera',
      color: const Color(0xFF6C5CE7),
    ),
    _SourceTypeItem(
      type: SourceType.screenCapture,
      icon: Icons.screen_share_rounded,
      label: 'Screen',
      color: const Color(0xFF00D9FF),
    ),
    _SourceTypeItem(
      type: SourceType.image,
      icon: Icons.image_rounded,
      label: 'Image',
      color: const Color(0xFF00F5A0),
    ),
    _SourceTypeItem(
      type: SourceType.text,
      icon: Icons.text_fields_rounded,
      label: 'Text',
      color: const Color(0xFFFF9F43),
    ),
    _SourceTypeItem(
      type: SourceType.audio,
      icon: Icons.mic_rounded,
      label: 'Audio',
      color: const Color(0xFFFF6B9D),
    ),
    _SourceTypeItem(
      type: SourceType.browser,
      icon: Icons.web_rounded,
      label: 'Browser',
      color: const Color(0xFF54A0FF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.surfaceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.add_box_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Quick Add',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: sourceTypes.take(6).map((type) {
              return _SourceTypeButton(item: type);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SourceTypeItem {
  final SourceType type;
  final IconData icon;
  final String label;
  final Color color;

  _SourceTypeItem({
    required this.type,
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _SourceTypeButton extends StatelessWidget {
  final _SourceTypeItem item;

  const _SourceTypeButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        final sceneProvider = context.read<SceneProvider>();
        sceneProvider.addSource(item.type, item.label);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.label} added to scene'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.surfaceLighter,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              color: item.color,
              size: 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySourcesView extends StatelessWidget {
  final VoidCallback onAddSource;

  const _EmptySourcesView({required this.onAddSource});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.surfaceLighter,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.view_in_ar_rounded,
              color: AppColors.textTertiary,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Sources Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add cameras, images, text, and more\nto your scene',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAddSource,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Source'),
          ),
        ],
      ),
    );
  }
}
