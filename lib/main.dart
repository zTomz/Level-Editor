import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_editor/constants.dart';
import 'package:level_editor/home_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Level Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: GREEN,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: GREEN,
          inactiveTrackColor: GREEN.withOpacity(0.4),
          thumbColor: GREEN,
        ),
      ),
      home: const LevelEditor(),
    );
  }
}
