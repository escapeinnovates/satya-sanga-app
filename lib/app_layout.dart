import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // for LanguageNotifier

class AppLayout extends StatefulWidget {
  final List<Widget> pages;

  const AppLayout({super.key, required this.pages});

  static _AppLayoutState of(BuildContext context) {
    final _AppLayoutState? state = context
        .findAncestorStateOfType<_AppLayoutState>();
    assert(state != null, 'AppLayout not found in widget tree');
    return state!;
  }

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;
  Widget? _overridePage;

  void open(Widget page) {
    setState(() {
      _overridePage = page;
    });
  }

  void closeOverride() {
    setState(() {
      _overridePage = null;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        leading: _overridePage != null
    ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: closeOverride,
      )
    : null,

        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/logo.jpeg'),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 10),
            Text(
              languageNotifier.currentLocale.languageCode == 'en'
                  ? 'Satya Sang'
                  : 'सत्य संग',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: languageNotifier.toggleLanguage,
            icon: Image.asset(
              'assets/icons/lang_icon.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: _overridePage ?? widget.pages[_selectedIndex],
      bottomNavigationBar: _overridePage != null
          ? null
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.orange.shade800,
              unselectedItemColor: Colors.black54,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: languageNotifier.currentLocale.languageCode == 'en'
                      ? 'Home'
                      : 'होम',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.video_library),
                  label: languageNotifier.currentLocale.languageCode == 'en'
                      ? 'Videos'
                      : 'वीडियो',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.music_note),
                  label: languageNotifier.currentLocale.languageCode == 'en'
                      ? 'Audio'
                      : 'ऑडियो',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.play_circle_fill),
                  label: languageNotifier.currentLocale.languageCode == 'en'
                      ? 'Shorts'
                      : 'शॉर्ट्स',
                ),
              ],
            ),
            
    );
  }
}
