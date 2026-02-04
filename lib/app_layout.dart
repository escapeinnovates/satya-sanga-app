import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // LanguageNotifier & shortsKey

class AppLayout extends StatefulWidget {
  final List<Widget> pages;

  const AppLayout({super.key, required this.pages});

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
    if (_selectedIndex == 3 && index != 3) {
      shortsKey.currentState?.pauseAllVideos();
    }

    setState(() {
      _selectedIndex = index;
      _overridePage = null;
    });
  }

  Widget _navItem(IconData icon, String label, int index) {
    final selected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: selected ? 6 : 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: selected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                size: 26,
                color:
                    selected ? Colors.orange.shade800 : Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color:
                    selected ? Colors.orange.shade800 : Colors.black54,
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
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      // ================= APP BAR =================
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              SizedBox.expand(
                child: Image.asset(
                  'assets/images/banner.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              if (_overridePage != null)
                Positioned(
                  bottom: 9,
                  left: 0,
                  child: InkWell(
                    onTap: closeOverride,
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.red,
                        size: 28,
                        weight: 900,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      // ================= BODY =================
      body: _overridePage ??
          IndexedStack(
            index: _selectedIndex,
            children: widget.pages,
          ),

      // ================= FLOATING BOTTOM NAV =================
      bottomNavigationBar: _overridePage != null
          ? null
          : AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                // 🔥 THIS IS THE CORE LOGIC (INSTAGRAM STYLE)
                bottom: bottomInset > 0 ? bottomInset : 8,
              ),
              child: Container(
                margin:
                    const EdgeInsets.fromLTRB(14, 0, 14, 14),
                padding:
                    const EdgeInsets.symmetric(vertical: 10),
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
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: [
                    _navItem(
                      Icons.home,
                      languageNotifier.currentLocale.languageCode ==
                              'en'
                          ? 'Home'
                          : 'होम',
                      0,
                    ),
                    _navItem(
                      Icons.video_library_outlined,
                      languageNotifier.currentLocale.languageCode ==
                              'en'
                          ? 'Video'
                          : 'वीडियो',
                      1,
                    ),
                    _navItem(
                      Icons.music_note_outlined,
                      languageNotifier.currentLocale.languageCode ==
                              'en'
                          ? 'Audio'
                          : 'ऑडियो',
                      2,
                    ),
                    _navItem(
                      Icons.play_circle_outline,
                      languageNotifier.currentLocale.languageCode ==
                              'en'
                          ? 'Shorts'
                          : 'शॉर्ट्स',
                      3,
                    ),
                    _navItem(
                      Icons.menu_book_outlined,
                      languageNotifier.currentLocale.languageCode ==
                              'en'
                          ? 'Read'
                          : 'रीड',
                      4,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
