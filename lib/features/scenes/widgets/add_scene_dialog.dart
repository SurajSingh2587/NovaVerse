import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/scene_provider.dart';

class AddSceneDialog extends StatefulWidget {
  const AddSceneDialog({super.key});

  @override
  State<AddSceneDialog> createState() => _AddSceneDialogState();
}

class _AddSceneDialogState extends State<AddSceneDialog> {
  final _nameController = TextEditingController();
  Color _selectedColor = AppColors.primary;
  
  final List<Color> _colorOptions = [
    const Color(0xFF6C5CE7),
    const Color(0xFF00D9FF),
    const Color(0xFF00F5A0),
    const Color(0xFFFF6B9D),
    const Color(0xFFFF9F43),
    const Color(0xFFFF6B6B),
    const Color(0xFF54A0FF),
    const Color(0xFFFECA57),
    const Color(0xFFA29BFE),
    const Color(0xFF81ECEC),
  ];
  
  final List<_SceneTemplate> _templates = [
    _SceneTemplate(
      name: 'Just Chatting',
      icon: Icons.chat_bubble_rounded,
      color: const Color(0xFF00D9FF),
      description: 'Full webcam view',
    ),
    _SceneTemplate(
      name: 'Gaming',
      icon: Icons.sports_esports_rounded,
      color: const Color(0xFFFF6B6B),
      description: 'Game + facecam',
    ),
    _SceneTemplate(
      name: 'Be Right Back',
      icon: Icons.pause_circle_rounded,
      color: const Color(0xFFFF9F43),
      description: 'BRB screen',
    ),
    _SceneTemplate(
      name: 'Starting Soon',
      icon: Icons.schedule_rounded,
      color: const Color(0xFF6C5CE7),
      description: 'Pre-stream screen',
    ),
    _SceneTemplate(
      name: 'Ending',
      icon: Icons.stop_circle_rounded,
      color: const Color(0xFFFF6B9D),
      description: 'End stream screen',
    ),
    _SceneTemplate(
      name: 'Screen Share',
      icon: Icons.screen_share_rounded,
      color: const Color(0xFF54A0FF),
      description: 'Desktop capture',
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
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
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
              'Add New Scene',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a new scene or use a template',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Templates
            const Text(
              'Templates',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _templates.length,
                itemBuilder: (context, index) {
                  final template = _templates[index];
                  return GestureDetector(
                    onTap: () {
                      _nameController.text = template.name;
                      setState(() => _selectedColor = template.color);
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _nameController.text == template.name
                              ? template.color
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            template.icon,
                            color: template.color,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            template.name,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            
            // Scene name input
            const Text(
              'Scene Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter scene name',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.layers_rounded,
                    color: _selectedColor,
                    size: 18,
                  ),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            
            // Color picker
            const Text(
              'Scene Color',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _colorOptions.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected 
                            ? Colors.white 
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 20,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            
            // Create button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nameController.text.trim().isEmpty
                    ? null
                    : () {
                        HapticFeedback.mediumImpact();
                        context.read<SceneProvider>().addScene(
                          _nameController.text.trim(),
                          color: _selectedColor,
                        );
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedColor,
                  disabledBackgroundColor: AppColors.surfaceLighter,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Create Scene',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SceneTemplate {
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  _SceneTemplate({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}
