import 'package:flutter/material.dart';

class ShubhVicharSection extends StatelessWidget {
  final String quote;

  const ShubhVicharSection({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. The White Content (Drawn First, so it's at the back)
        Padding(
          padding: const EdgeInsets.only(top: 250), // Height of your banner
          child: Container(
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
        ),

        // 2. The Banner Image
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

        // 3. Floating Circle (Drawn Last, so it's on top of everything)
        Positioned(
          top: 220, // (Banner height 250) - (Half of circle height 30)
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
              child: const Icon(Icons.format_quote,size: 30, color: Colors.orange),
            ),
          ),
        ),
      ],
    );
  }
}
