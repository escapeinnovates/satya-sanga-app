import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:satya_sang/features/read/guruvandana_read.dart';

import '../../main.dart'; // for LanguageNotifier
import './section_detail_page.dart';

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

    return Column(
      children: [
        const SizedBox(height: 40),
        Center(
          child: Container(
            width: 400,
            constraints: const BoxConstraints(minHeight: 220),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      languageNotifier.currentLocale.languageCode == 'en'
                          ? 'Aaj Ka Shubh Vichar'
                          : "आज का शुभ विचार",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                      color: Colors.black26,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      quote,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        const Divider(
          height: 2,
          thickness: 1,
          indent: 40,
          endIndent: 40,
          color: Colors.black26,
        ),
        const SizedBox(height: 20),
        SectionCard(
          title: languageNotifier.currentLocale.languageCode == 'en'
              ? 'Guruvandana'
              : 'गुरुवंदना',
          icon: Icons.book_online,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GuruVandanaPDF()),
            );
          },
        ),
     
      ],
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;

final VoidCallback? onTap;
  const SectionCard({super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
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
