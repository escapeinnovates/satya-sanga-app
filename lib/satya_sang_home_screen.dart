import 'package:flutter/material.dart';

class SatyaSangaHomeScreen extends StatelessWidget {
  const SatyaSangaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1EC),
      appBar: AppBar(
        title: const Text(
          "Satya Sang",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: const Center(
        child: Text(
          "Welcome to Satya Sang!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
