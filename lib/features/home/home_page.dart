import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:satya_sang/features/home/pdf_reader_page.dart';

import '../../main.dart';
import './section_detail_page.dart';
import './shubh_vichar_section.dart';
import '../read/read_page.dart';

// -------------------- BOOK MODEL --------------------

class BookModel {
  final String title;
  final String banner;
  final String pdfPath;

  BookModel({required this.title, required this.banner, required this.pdfPath});
}

// -------------------- HOME SCREEN --------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String quote = 'Loading...';

  final List<BookModel> books = [
    BookModel(
      title: "Guru Vandana",
      banner: "assets/images/guru_vandana.jpeg",
      pdfPath: "assets/read/guru_vandana.pdf",
    ),
    BookModel(
      title: "Hanuman Chalisa",
      banner: "assets/images/hanuman.jpg",
      pdfPath: "assets/read/hanuman.pdf",
    ),
  ];

  @override
  void initState() {
    super.initState();
    loadQuote();
  }

  Future<void> loadQuote() async {
    final String response = await rootBundle.loadString(
      'assets/daily_quotes.json',
    );
    final data = json.decode(response);
    final List<dynamic> quotes = data['quotes'];
    final randomQuote = quotes[Random().nextInt(quotes.length)];

    setState(() {
      quote = randomQuote['quote'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌼 Banner + Quote
            ShubhVicharSection(quote: quote),

            const SizedBox(height: 20),

            // 📚 Recommended Reading Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    languageNotifier.currentLocale.languageCode == 'en'
                        ? "Quick Read"
                        : "क्विक रीड",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ReadPage(), // your books grid page
                        ),
                      );
                    },
                    child: Text(
                      languageNotifier.currentLocale.languageCode == 'en'
                          ? "Read More"
                          : "और पढ़ें",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 📖 Horizontal Book Shelf
            SizedBox(
              height: 325,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return BookCard(book: books[index]);
                },
              ),
            ),

            // 🧭 Other navigation sections
            SectionCard(
              title: languageNotifier.currentLocale.languageCode == 'en'
                  ? 'All Scriptures'
                  : 'सभी ग्रंथ',
              icon: Icons.menu_book,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// -------------------- BOOK CARD --------------------

class BookCard extends StatelessWidget {
  final BookModel book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 190,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(
              book.banner,
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text("Read"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PDFReaderPage(
                            title: book.title,
                            pdfPath: book.pdfPath,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- SECTION CARD (NAVIGATION) --------------------

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SectionDetailPage(title: title),
              ),
            );
          },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: ListTile(
          leading: Icon(icon, size: 40, color: Colors.orange.shade800),
          title: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
