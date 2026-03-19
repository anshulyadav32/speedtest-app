import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedtest/providers/theme_manager.dart';
import 'package:speedtest/screens/home_screen.dart';
import 'package:speedtest/services/themes.dart';

import 'confidential.dart';

void main() {
  final _ = syncFusionLicenseKey;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Speed Test',
            theme: themeManager.isDark ? darkTheme : lightTheme,
            darkTheme: darkTheme,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
