import 'package:flutter/material.dart';

class ShubhVicharSection extends StatelessWidget {
  final String quote;
  final String author;

  const ShubhVicharSection({
    super.key,
    required this.quote,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // White content
        Padding(
          padding: const EdgeInsets.only(top: 250),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  quote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  author,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Banner
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 250,
          child: Image.asset(
            "assets/images/shubh_vichar.jpeg",
            fit: BoxFit.cover,
          ),
        ),

        // Quote icon
        Positioned(
          top: 220,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.format_quote,
                size: 30,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
