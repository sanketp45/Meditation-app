import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  runApp(const MeditationApp());
}

class MeditationApp extends StatelessWidget {
  const MeditationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      initials: 'SP',
      pawCount: 12,
      companionState: CompanionState.active,
      statsSubtext: "You're on a roll today",
      splitFlapText: 'PEACE COMES FROM WITHIN',
      actionCards: [
        ActionCard(
          icon: LucideIcons.sportShoe,
          title: 'Go for a walk',
          range: '10 - 100',
          onTap: () {},
        ),
        ActionCard(
          icon: LucideIcons.wind,
          title: 'Breathing exercise',
          range: '5 - 20',
          onTap: () {},
        ),
      ],
    );
  }
}
