import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.flip_camera_ios_rounded,
        label: 'Flip Camera',
        color: AppColors.primary,
        onTap: () => _showSnackbar(context, 'Camera flipped'),
      ),
      _QuickAction(
        icon: Icons.flash_on_rounded,
        label: 'Flash',
        color: AppColors.accentOrange,
        onTap: () => _showSnackbar(context, 'Flash toggled'),
      ),
      _QuickAction(
        icon: Icons.blur_on_rounded,
        label: 'Background',
        color: AppColors.accent,
        onTap: () => _showBackgroundOptions(context),
      ),
      _QuickAction(
        icon: Icons.filter_vintage_rounded,
        label: 'Filters',
        color: AppColors.accentPink,
        onTap: () => _showFilters(context),
      ),
      _QuickAction(
        icon: Icons.text_fields_rounded,
        label: 'Text',
        color: AppColors.accentGreen,
        onTap: () => _showSnackbar(context, 'Add text overlay'),
      ),
      _QuickAction(
        icon: Icons.gif_box_rounded,
        label: 'Stickers',
        color: AppColors.warning,
        onTap: () => _showSnackbar(context, 'Open sticker picker'),
      ),
    ];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.surfaceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.bolt_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Action grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: actions.map((action) => _ActionTile(action: action)).toList(),
          ),
        ],
      ),
    );
  }
  
  void _showSnackbar(BuildContext context, String message) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceLighter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  
  void _showBackgroundOptions(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _BackgroundOptionsSheet(),
    );
  }
  
  void _showFilters(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _FiltersSheet(),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _ActionTile extends StatelessWidget {
  final _QuickAction action;

  const _ActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: action.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                action.icon,
                color: action.color,
                size: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundOptionsSheet extends StatelessWidget {
  final List<_BackgroundOption> options = [
    _BackgroundOption('None', Icons.do_not_disturb_alt_rounded, false),
    _BackgroundOption('Blur', Icons.blur_on_rounded, true),
    _BackgroundOption('Green Screen', Icons.square_rounded, false),
    _BackgroundOption('Image', Icons.image_rounded, false),
    _BackgroundOption('Video', Icons.movie_rounded, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Text(
            'Background Effects',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ...options.map((option) => _BackgroundOptionTile(option: option)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _BackgroundOption {
  final String label;
  final IconData icon;
  final bool isSelected;

  _BackgroundOption(this.label, this.icon, this.isSelected);
}

class _BackgroundOptionTile extends StatelessWidget {
  final _BackgroundOption option;

  const _BackgroundOptionTile({required this.option});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: option.isSelected 
            ? AppColors.primary.withOpacity(0.15)
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: option.isSelected 
              ? AppColors.primary.withOpacity(0.5)
              : Colors.transparent,
        ),
      ),
      child: ListTile(
        leading: Icon(
          option.icon,
          color: option.isSelected 
              ? AppColors.primary 
              : AppColors.textSecondary,
        ),
        title: Text(
          option.label,
          style: TextStyle(
            color: option.isSelected 
                ? AppColors.primary 
                : AppColors.textPrimary,
            fontWeight: option.isSelected 
                ? FontWeight.w600 
                : FontWeight.normal,
          ),
        ),
        trailing: option.isSelected
            ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
            : null,
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}

class _FiltersSheet extends StatelessWidget {
  final List<_FilterOption> filters = [
    _FilterOption('None', Colors.transparent, true),
    _FilterOption('Warm', Colors.orange, false),
    _FilterOption('Cool', Colors.blue, false),
    _FilterOption('Vintage', Colors.brown, false),
    _FilterOption('B&W', Colors.grey, false),
    _FilterOption('Vivid', Colors.purple, false),
    _FilterOption('Soft', Colors.pink, false),
    _FilterOption('Dramatic', Colors.deepPurple, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Text(
            'Camera Filters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return _FilterTile(filter: filter);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _FilterOption {
  final String label;
  final Color color;
  final bool isSelected;

  _FilterOption(this.label, this.color, this.isSelected);
}

class _FilterTile extends StatelessWidget {
  final _FilterOption filter;

  const _FilterTile({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: filter.color == Colors.transparent 
                  ? AppColors.surfaceLight 
                  : filter.color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: filter.isSelected 
                    ? AppColors.primary 
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: filter.color == Colors.transparent
                ? const Icon(
                    Icons.do_not_disturb_alt_rounded,
                    color: AppColors.textTertiary,
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            filter.label,
            style: TextStyle(
              fontSize: 12,
              color: filter.isSelected 
                  ? AppColors.primary 
                  : AppColors.textSecondary,
              fontWeight: filter.isSelected 
                  ? FontWeight.w600 
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
