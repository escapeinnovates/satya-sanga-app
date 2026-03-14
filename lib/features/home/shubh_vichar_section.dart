import 'package:flutter/material.dart';
import 'package:satya_sang/features/home/detailed_quote_sectio.dart';
import 'package:satya_sang/app_layout.dart';

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
    /// Show only first line preview
    String preview = quote.split('\n').first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: () {
          // / OPEN FULL PAGE
          AppLayout.of(
            context,
          ).open(DailyQuoteScreen(quote: quote, author: author));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              /// BACKGROUND IMAGE
              Image.asset(
                "assets/images/shubh_vichar.jpeg", // your existing image
                height: 270,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              /// DARK OVERLAY
              Container(
                height: 270,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(.7),
                      Colors.black.withOpacity(.2),
                    ],
                  ),
                ),
              ),

              /// CONTENT
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.black),
                            SizedBox(width: 6),
                            Text(
                              "आज का शुभ विचार",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      /// QUOTE PREVIEW
                      Text(
                        "“$preview”",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// AUTHOR + HINT
                      Text(
                        "$author • Tap to read more",
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
