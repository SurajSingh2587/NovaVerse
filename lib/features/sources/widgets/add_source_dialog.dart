import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/scene_provider.dart';

class AddSourceDialog extends StatefulWidget {
  const AddSourceDialog({super.key});

  @override
  State<AddSourceDialog> createState() => _AddSourceDialogState();
}

class _AddSourceDialogState extends State<AddSourceDialog> {
  SourceType? _selectedType;
  final _nameController = TextEditingController();
  
  final List<_SourceTypeOption> _sourceTypes = [
    _SourceTypeOption(
      type: SourceType.camera,
      icon: Icons.videocam_rounded,
      label: 'Camera',
      description: 'Capture from device camera',
      color: const Color(0xFF6C5CE7),
    ),
    _SourceTypeOption(
      type: SourceType.screenCapture,
      icon: Icons.screen_share_rounded,
      label: 'Screen Capture',
      description: 'Share your screen',
      color: const Color(0xFF00D9FF),
    ),
    _SourceTypeOption(
      type: SourceType.image,
      icon: Icons.image_rounded,
      label: 'Image',
      description: 'Add static image overlay',
      color: const Color(0xFF00F5A0),
    ),
    _SourceTypeOption(
      type: SourceType.text,
      icon: Icons.text_fields_rounded,
      label: 'Text',
      description: 'Add text overlay',
      color: const Color(0xFFFF9F43),
    ),
    _SourceTypeOption(
      type: SourceType.audio,
      icon: Icons.mic_rounded,
      label: 'Audio Input',
      description: 'Capture microphone audio',
      color: const Color(0xFFFF6B9D),
    ),
    _SourceTypeOption(
      type: SourceType.browser,
      icon: Icons.web_rounded,
      label: 'Browser Source',
      description: 'Embed web content',
      color: const Color(0xFF54A0FF),
    ),
    _SourceTypeOption(
      type: SourceType.video,
      icon: Icons.movie_rounded,
      label: 'Video',
      description: 'Play video file',
      color: const Color(0xFFFECA57),
    ),
    _SourceTypeOption(
      type: SourceType.gameCapture,
      icon: Icons.sports_esports_rounded,
      label: 'Game Capture',
      description: 'Capture game content',
      color: const Color(0xFFFF6B6B),
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceLighter,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          const Text(
            'Add Source',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedType == null
                ? 'Select a source type to add'
                : 'Configure your ${_sourceTypes.firstWhere((t) => t.type == _selectedType).label.toLowerCase()}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Content
          Flexible(
            child: _selectedType == null
                ? _buildSourceTypeList()
                : _buildSourceConfig(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSourceTypeList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _sourceTypes.length,
      itemBuilder: (context, index) {
        final sourceType = _sourceTypes[index];
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _selectedType = sourceType.type;
              _nameController.text = sourceType.label;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: sourceType.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    sourceType.icon,
                    color: sourceType.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sourceType.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sourceType.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildSourceConfig() {
    final selectedOption = _sourceTypes.firstWhere((t) => t.type == _selectedType);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected type display
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: selectedOption.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedOption.color.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selectedOption.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    selectedOption.icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedOption.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedType = null;
                      _nameController.clear();
                    });
                  },
                  child: const Text('Change'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Source name input
          const Text(
            'Source Name',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter source name',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          
          // Type-specific settings
          _buildTypeSpecificSettings(selectedOption),
          
          const SizedBox(height: 24),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _nameController.text.trim().isEmpty
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          context.read<SceneProvider>().addSource(
                            _selectedType!,
                            _nameController.text.trim(),
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${_nameController.text.trim()} added to scene',
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.surfaceLighter,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedOption.color,
                  ),
                  child: const Text('Add Source'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTypeSpecificSettings(_SourceTypeOption option) {
    switch (option.type) {
      case SourceType.camera:
        return _buildCameraSettings();
      case SourceType.text:
        return _buildTextSettings();
      default:
        return const SizedBox();
    }
  }
  
  Widget _buildCameraSettings() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Camera Settings',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SettingOption(
                  icon: Icons.camera_front_rounded,
                  label: 'Front',
                  isSelected: true,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _SettingOption(
                  icon: Icons.camera_rear_rounded,
                  label: 'Back',
                  isSelected: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTextSettings() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Text Content',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your text here...',
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceTypeOption {
  final SourceType type;
  final IconData icon;
  final String label;
  final String description;
  final Color color;

  _SourceTypeOption({
    required this.type,
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
  });
}

class _SettingOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _SettingOption({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.15)
            : AppColors.surfaceLighter,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withOpacity(0.5)
              : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textTertiary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
