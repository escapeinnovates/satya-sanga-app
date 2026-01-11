import 'package:flutter/material.dart';

class ShubhVicharSection extends StatelessWidget {
  final String quote;

  const ShubhVicharSection({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // 🌿 Banner image
            Image.asset(
              "assets/images/shubh_vichar.jpeg",
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // 🔵 Quote icon (half on image, half on white area)
            Positioned(
              bottom: -20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 50,
                  width: 50,
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
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
          ],
        ),

        // 🧾 White text section (no box, no shadow)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
          color: Colors.white,
          child: Text(
            quote,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
