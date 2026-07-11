import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'screens/home_screen.dart';

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
        scaffoldBackgroundColor: AppColors.surface,
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
      pawCount: 0,
      companionState: CompanionState.sleeping,
      statsSubtext: 'Ready to take a challenge?',
      splitFlapText: 'PEACE COMES FROM WITHIN',
      activityCards: [
        GridActivityCard(
          icon: LucideIcons.sportShoe,
          title: 'Walk',
          range: '10 - 100',
          onStart: () {},
        ),
        GridActivityCard(
          icon: LucideIcons.wind,
          title: 'Breathe',
          range: '5 - 20',
          onStart: () {},
        ),
        GridActivityCard(
          icon: LucideIcons.flower,
          title: 'Meditate',
          range: '20 - 50',
          onStart: () {},
        ),
        GridActivityCard(
          icon: LucideIcons.personStanding,
          title: 'Stretch',
          range: '10 - 30',
          onStart: () {},
        ),
      ],
    );
  }
}
