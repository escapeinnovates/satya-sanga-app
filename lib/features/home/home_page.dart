import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../read/read_page.dart';
import './pdf_reader_page.dart';
import './section_detail_page.dart';
import './shubh_vichar_section.dart';
import './quote_service.dart';
import './quote_model.dart';

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
  String author = '';

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

  // ---------------- LOAD QUOTE FROM GOOGLE SHEET ----------------

  @override
  void initState() {
    super.initState();
    loadQuoteFromSheet();
  }

  Future<void> loadQuoteFromSheet() async {
    final List<QuoteModel> quotes = await QuoteService.fetchQuotes();

    if (!mounted) return;

    if (quotes.isEmpty) {
      setState(() {
        quote = 'No quote available';
        author = '';
      });
      return;
    }

    final int weekday = DateTime.now().weekday;
    final List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final String today = days[weekday - 1];

    for (final q in quotes) {}

    final QuoteModel todayQuote = quotes.firstWhere(
      (q) => q.day.trim().toLowerCase() == today.toLowerCase(),
      orElse: () => QuoteModel(day: '', quote: '', author: ''),
    );

    if (todayQuote.quote.isEmpty) {
      setState(() {
        quote = 'No quote for today';
        author = '';
      });
      return;
    }

    setState(() {
      quote = todayQuote.quote;
      author = todayQuote.author;
    });
  }

  // ---------------- UI ----------------

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
            // 🌼 SHUBH VICHAR (FROM GOOGLE SHEET, DAY-WISE)
            ShubhVicharSection(quote: quote, author: author),

            const SizedBox(height: 20),

            // 📚 Quick Read Header
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
                        MaterialPageRoute(builder: (_) => const ReadPage()),
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

            // 📖 Horizontal Book List
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

            // 🧭 Navigation Section
            SectionCard(
              title: languageNotifier.currentLocale.languageCode == 'en'
                  ? 'Announcements'
                  : 'घोषणाएँ',
              icon: Icons.campaign,
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
                    child: const Text("Read"),
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

// -------------------- SECTION CARD --------------------

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
                builder: (_) => SectionDetailPage(title: title),
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
