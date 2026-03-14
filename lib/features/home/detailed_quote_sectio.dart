import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class DailyQuoteScreen extends StatefulWidget {
  final String quote;
  final String author;

  const DailyQuoteScreen({
    super.key,
    required this.quote,
    required this.author,
  });

  @override
  State<DailyQuoteScreen> createState() => _DailyQuoteScreenState();
}

class _DailyQuoteScreenState extends State<DailyQuoteScreen> {
  bool liked = false;
  bool saved = false;

  /// SHARE QUOTE
  void shareQuote() {
    final message =
        '''
✨ आज का शुभ विचार ✨

"${widget.quote}"

— ${widget.author}

Satya Sang App
''';

    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0A18),
      body: Stack(
        children: [
          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Image.network(
              "https://images.unsplash.com/photo-1744979324655-520e1be34f4e?q=80&w=1080",
              fit: BoxFit.cover,
            ),
          ),

          /// GRADIENT OVERLAY
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xB30C0A18),
                    Color(0x8C0C0A18),
                    Color(0xD90C0A18),
                    Color(0xFA0C0A18),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// BACK
                      _circleButton(
                        icon: Icons.chevron_left,
                        onTap: () => Navigator.pop(context),
                        color: const Color(0xFFD4AF37),
                      ),

                      /// TITLE BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFD4AF37)),
                          color: const Color(0x33D4AF37),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Color(0xFFD4AF37),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "आज का शुभ विचार",
                              style: TextStyle(
                                color: Color(0xFFD4AF37),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// SHARE
                      _circleButton(
                        icon: Icons.share,
                        onTap: shareQuote,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// ICON
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD4AF37)),
                    color: const Color(0x33D4AF37),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/lang_icon.png',
                    width: 26,
                    height: 26,
                  ),
                ),

                const SizedBox(height: 20),

                /// QUOTE CARD
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xCC0C0A18),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: const Color(0x33D4AF37)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '"',
                        style: TextStyle(
                          fontSize: 36,
                          color: Color(0xFFD4AF37),
                        ),
                      ),

                      Text(
                        widget.quote,
                        style: const TextStyle(
                          fontSize: 19,
                          height: 1.7,
                          color: Color(0xFFF4EFE6),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(height: 1, color: const Color(0x22D4AF37)),

                      const SizedBox(height: 12),

                      Text(
                        widget.author,
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0x990C0A18),
          border: Border.all(color: const Color(0x33FFFFFF)),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
