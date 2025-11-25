import 'package:flutter/material.dart';

import 'routes/app_router.dart';
import 'screens/home/home_screen.dart';

class MemorialApp extends StatelessWidget {
  const MemorialApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFFf6a192));

    return MaterialApp(
      title: '纪念日',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        appBarTheme: AppBarTheme(backgroundColor: colorScheme.surface, elevation: 0),
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: const HomeScreen(),
    );
  }
}

