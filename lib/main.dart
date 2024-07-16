import 'package:flutter/material.dart';
import 'package:marketlist/pages/splash_screen.dart';

void main() {
  runApp(const MarketListApp());
}

class MarketListApp extends StatelessWidget {
  const MarketListApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market List Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
