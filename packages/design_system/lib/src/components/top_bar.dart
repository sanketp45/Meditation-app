import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../generated/app_colors.dart';
import '../../generated/app_radius.dart';
import '../../generated/app_spacing.dart';
import '../../generated/app_typography.dart';

/// The app's top bar: avatar, search field, paw count pill, and assistant
/// button in a single row, spaced on the 4px grid.
///
/// The search field is a real text input with distinct empty, focused
/// (typing), filled, and disabled states. Setting [enabled] to false
/// disables and dims every control in the bar.
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.initials,
    required this.pawCount,
    this.searchPlaceholder = 'Search',
    this.searchController,
    this.onSearchChanged,
    this.searchAutofocus = false,
    this.assistantIcon = LucideIcons.sparkles,
    this.enabled = true,
    this.onAvatarTap,
    this.onAssistantTap,
  });

  final String initials;
  final int pawCount;
  final String searchPlaceholder;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final bool searchAutofocus;
  final IconData assistantIcon;
  final bool enabled;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onAssistantTap;

  static const double controlSize = 40;
  static const double _verticalPadding = 12;
  static const double _disabledOpacity = 0.4;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : _disabledOpacity,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Padding(
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
                  controller: searchController,
                  onChanged: onSearchChanged,
                  autofocus: searchAutofocus,
                  enabled: enabled,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _PawCountPill(count: pawCount),
              const SizedBox(width: AppSpacing.sm),
              _AssistantButton(icon: assistantIcon, onTap: onAssistantTap),
            ],
          ),
        ),
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
        width: TopBar.controlSize,
        height: TopBar.controlSize,
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

/// A pill-shaped search field with four visual states:
/// empty (idle), focused (typing), filled (has text), and disabled.
class _SearchField extends StatefulWidget {
  const _SearchField({
    required this.placeholder,
    this.controller,
    this.onChanged,
    this.autofocus = false,
    this.enabled = true,
  });

  static const double _iconSize = 16;

  final String placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final bool enabled;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleTextChange);
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _handleTextChange() => setState(() {});

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.removeListener(_handleTextChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  bool get _isFilled => _controller.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = _isFocused ? AppColors.primary : AppColors.textSecondary;

    return Container(
      height: TopBar.controlSize,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: _isFocused
            ? Border.all(color: AppColors.primary, width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.search,
            size: _SearchField._iconSize,
            color: iconColor,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              enabled: widget.enabled,
              onChanged: widget.onChanged,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: widget.placeholder,
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_isFilled) ...[
            const SizedBox(width: AppSpacing.xs),
            GestureDetector(
              onTap: () {
                _controller.clear();
                widget.onChanged?.call('');
                _focusNode.requestFocus();
              },
              child: Icon(
                LucideIcons.x,
                size: _SearchField._iconSize,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
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
      height: TopBar.controlSize,
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.pawPrint,
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
        width: TopBar.controlSize,
        height: TopBar.controlSize,
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
