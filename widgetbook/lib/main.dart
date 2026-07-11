import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const MeditationAppWidgetbook());
}

class MeditationAppWidgetbook extends StatelessWidget {
  const MeditationAppWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookCategory(
          name: 'Components',
          children: [
            WidgetbookComponent(
              name: 'TopBar',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => const _TopBarPreview(),
                ),
                WidgetbookUseCase(
                  name: 'Typing',
                  builder: (context) => const _TopBarPreview(
                    searchAutofocus: true,
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Filled',
                  builder: (context) => const _TopBarPreview(
                    searchText: 'yoga nidra',
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Disabled',
                  builder: (context) => const _TopBarPreview(
                    enabled: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
      addons: [
        ThemeAddon<ThemeData>(
          themes: [
            WidgetbookTheme(name: 'Light', data: ThemeData.light()),
            WidgetbookTheme(name: 'Dark', data: ThemeData.dark()),
          ],
          themeBuilder: (context, theme, child) => Theme(
            data: theme,
            child: child,
          ),
        ),
      ],
    );
  }
}

class _TopBarPreview extends StatefulWidget {
  const _TopBarPreview({
    this.searchAutofocus = false,
    this.searchText,
    this.enabled = true,
  });

  final bool searchAutofocus;
  final String? searchText;
  final bool enabled;

  @override
  State<_TopBarPreview> createState() => _TopBarPreviewState();
}

class _TopBarPreviewState extends State<_TopBarPreview> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.searchText != null) {
      _controller = TextEditingController(text: widget.searchText);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: TopBar(
          initials: 'SP',
          pawCount: 128,
          searchAutofocus: widget.searchAutofocus,
          searchController: _controller,
          enabled: widget.enabled,
        ),
      ),
    );
  }
}
