import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/on_water_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const OnWaterApp());
}

class OnWaterApp extends StatelessWidget {
  const OnWaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnWater App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
      home: const OnWaterScreen(),
    );
  }
}
