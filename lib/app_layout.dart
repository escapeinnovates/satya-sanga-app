import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // Used to get LanguageNotifier for language toggle

class AppLayout extends StatefulWidget {
  final List<Widget> pages; // List of pages: Home, Video, Audio, Shorts, Read

  const AppLayout({super.key, required this.pages});

  // Allows child widgets to access AppLayout state
  // Used when opening full screen pages like PDF Viewer
  static _AppLayoutState of(BuildContext context) {
    final _AppLayoutState? state =
        context.findAncestorStateOfType<_AppLayoutState>();
    assert(state != null, 'AppLayout not found in widget tree');
    return state!;
  }

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;     // Which bottom tab is selected
  Widget? _overridePage;     // Used when opening pages over the main layout

  // Opens a page on top of bottom navigation (e.g., PDF, video player)
  void open(Widget page) {
    setState(() {
      _overridePage = page;
    });
  }

  // Closes the overlay page and returns to bottom navigation
  void closeOverride() {
    setState(() {
      _overridePage = null;
    });
  }

  // Called when user taps any bottom bar icon
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Changes the active tab
    });
  }

  // Builds one navigation item (icon + text)
  // This widget is reused for all 5 tabs
  Widget _navItem(IconData icon, String label, int index) {
    final bool selected = _selectedIndex == index; // Is this tab active?

    return GestureDetector(
      onTap: () => _onItemTapped(index), // Change tab when tapped
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: selected ? 6 : 8, // Slight lift when selected
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon zoom animation when selected
            AnimatedScale(
              scale: selected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                size: 26,
                color: selected
                    ? Colors.orange.shade800
                    : Colors.black54,
              ),
            ),

            const SizedBox(height: 4),

            // Text color animation when selected
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.orange.shade800
                    : Colors.black54,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Reads the current language (English / Hindi)
    final languageNotifier = Provider.of<LanguageNotifier>(context);

    return Scaffold(
      // 🔶 App bar at the top
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,

        // Back button appears only when an override page is open
        leading: _overridePage != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: closeOverride,
              )
            : null,

        // App logo + name
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/logo.jpeg'),
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

        // Language toggle button
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

      // Keeps all pages alive → prevents reload lag
      body: _overridePage ??
          IndexedStack(
            index: _selectedIndex,
            children: widget.pages,
          ),

      // Floating bottom navigation bar
      bottomNavigationBar: _overridePage != null
          ? null
          : Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              // Row of bottom navigation buttons
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home,
                      languageNotifier.currentLocale.languageCode == 'en'
                          ? 'Home'
                          : 'होम',
                      0),
                  _navItem(Icons.video_library_outlined,
                      languageNotifier.currentLocale.languageCode == 'en'
                          ? 'Video'
                          : 'वीडियो',
                      1),
                  _navItem(Icons.music_note_outlined,
                      languageNotifier.currentLocale.languageCode == 'en'
                          ? 'Audio'
                          : 'ऑडियो',
                      2),
                  _navItem(Icons.play_circle_outline,
                      languageNotifier.currentLocale.languageCode == 'en'
                          ? 'Shorts'
                          : 'शॉर्ट्स',
                      3),
                  _navItem(Icons.menu_book_outlined,
                      languageNotifier.currentLocale.languageCode == 'en'
                          ? 'Read'
                          : 'रीड',
                      4),
                ],
              ),
            ),
    );
  }
}
