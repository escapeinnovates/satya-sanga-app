import 'package:flutter/material.dart';

class ShubhVicharSection extends StatelessWidget {
  final String quote;

  const ShubhVicharSection({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -70), // pulls card into banner
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 12),
          ],
        ),
        child: Column(
          children: [
            // Quote icon (half in banner, half in card)
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 6),
                ],
              ),
              child: const Icon(
                Icons.format_quote,
                size: 28,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              quote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}