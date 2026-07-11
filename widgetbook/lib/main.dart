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

class _TopBarPreview extends StatelessWidget {
  const _TopBarPreview();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const SafeArea(
        child: TopBar(initials: 'SP', pawCount: 128),
      ),
    );
  }
}
