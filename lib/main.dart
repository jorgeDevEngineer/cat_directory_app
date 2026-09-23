import 'package:flutter/material.dart';

void main() {
  runApp(const CatDirectoryApp());
}

class CatDirectoryApp extends StatelessWidget {
  const CatDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Directory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            '🐱 Cat Directory App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
