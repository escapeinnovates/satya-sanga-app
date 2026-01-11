import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:satya_sang/features/read/guruvandana_read.dart';

import '../../main.dart';
import './section_detail_page.dart';
import './shubh_vichar_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String quote = 'Loading...';

  @override
  void initState() {
    super.initState();
    loadQuote();
  }

  Future<void> loadQuote() async {
    final String response =
        await rootBundle.loadString('assets/daily_quotes.json');
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
          children: [
            // 🌼 Banner + Quote (Sadhguru style)
            ShubhVicharSection(quote: quote),

           
            const Divider(
              height: 2,
              thickness: 1,
              indent: 40,
              endIndent: 40,
              color: Colors.black26,
            ),

            const SizedBox(height: 20),

            // 📖 Guruvandana
            SectionCard(
              title: languageNotifier.currentLocale.languageCode == 'en'
                  ? 'Guruvandana'
                  : 'गुरुवंदना',
              icon: Icons.book_online,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GuruVandanaPDF(),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ------------------ Section Card ------------------

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
      onTap: onTap ??
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
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
