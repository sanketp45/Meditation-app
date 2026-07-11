import 'package:flutter/material.dart';

import '../../generated/app_colors.dart';
import '../../generated/app_radius.dart';
import '../../generated/app_spacing.dart';
import '../../generated/app_typography.dart';

/// The app's top bar: avatar, search field, paw count pill, and assistant
/// button in a single row, spaced on the 4px grid.
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.initials,
    required this.pawCount,
    this.searchPlaceholder = 'Search',
    this.assistantIcon = Icons.auto_awesome,
    this.onAvatarTap,
    this.onSearchTap,
    this.onAssistantTap,
  });

  final String initials;
  final int pawCount;
  final String searchPlaceholder;
  final IconData assistantIcon;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onAssistantTap;

  static const double _controlSize = 40;
  static const double _verticalPadding = 12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: _verticalPadding,
      ),
      child: Row(
        children: [
          _Avatar(initials: initials, onTap: onAvatarTap),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _SearchField(
              placeholder: searchPlaceholder,
              onTap: onSearchTap,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _PawCountPill(count: pawCount),
          const SizedBox(width: AppSpacing.sm),
          _AssistantButton(icon: assistantIcon, onTap: onAssistantTap),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, this.onTap});

  final String initials;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: TopBar._controlSize,
        height: TopBar._controlSize,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: AppTypography.label.copyWith(color: AppColors.textInverse),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.placeholder, this.onTap});

  static const double _iconSize = 16;

  final String placeholder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: TopBar._controlSize,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: _iconSize,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                placeholder,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PawCountPill extends StatelessWidget {
  const _PawCountPill({required this.count});

  static const double _iconSize = 16;
  static const double _horizontalPadding = 12;

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: TopBar._controlSize,
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.pets,
            size: _iconSize,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$count',
            style: AppTypography.labelStrong.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssistantButton extends StatelessWidget {
  const _AssistantButton({required this.icon, this.onTap});

  static const double _iconSize = 20;
  static const double _borderWidth = 1;

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: TopBar._controlSize,
        height: TopBar._controlSize,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: _borderWidth),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: _iconSize,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
