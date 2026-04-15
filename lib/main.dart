import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/speed_test_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpeedTestService()),
      ],
      child: const NetSpeedApp(),
    ),
  );
}

class NetSpeedApp extends StatelessWidget {
  const NetSpeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NetSpeed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0B1A),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E5FF),
          brightness: Brightness.dark,
          primary: const Color(0xFF00E5FF),
          secondary: const Color(0xFF0066FF),
          surface: const Color(0xFF16162D),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
