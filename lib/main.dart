import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'pages/playlist_page.dart';
import 'drive_service.dart';
import 'audio_player_screen.dart';
import 'pages/shorts_page.dart';





class LanguageNotifier extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  void toggleLanguage() {
    _currentLocale = (_currentLocale.languageCode == 'en')
        ? const Locale('hi')
        : const Locale('en');
    notifyListeners();
  }
}

// Main Application
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);

    return MaterialApp(
      title: 'Bhakti App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      locale: languageNotifier.currentLocale,
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('hi', ''), // Hindi
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SplashScreen(),

    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
     VideosPage(),
    const AudioPage(),
    ShortsPage(),
  ];

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
title: Row(
  children: [
    CircleAvatar(
      radius: 16, // controls size
      backgroundImage: const AssetImage('assets/logo.jpeg'),
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
    onPressed: () {
      languageNotifier.toggleLanguage();
    },
    icon: Image.asset(
      'assets/icons/lang_icon.png',
      width: 24,
      height: 24,
    ),
  ),
],
        
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
     bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  showSelectedLabels: true,
  showUnselectedLabels: true,

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
)
    );

  }
}

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
    return Column(
      children: [
        const SizedBox(height: 40),
        Center(
          child: Container(
            width: 400,
            constraints: const BoxConstraints(
              minHeight: 220,
            ),
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
),

SectionCard(
  title: languageNotifier.currentLocale.languageCode == 'en'
      ? 'Hanuman Chalisa'
      : 'हनुमान चालीसा',
  icon: Icons.military_tech,
),

SectionCard(
  title: languageNotifier.currentLocale.languageCode == 'en'
      ? 'Bhajans'
      : 'भजन',
  icon: Icons.music_note,
),

      ],
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
          leading: Icon(
            icon,
            size: 40,
            color: Colors.orange.shade800,
          ),
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

Future<Map<String, dynamic>?> loadSectionContent(String title) async {
  final String response = await rootBundle.loadString('assets/sections.json');
  final List<dynamic> data = json.decode(response);

  // Find the section by title
  return data.firstWhere(
    (section) => section['title'] == title,
    orElse: () => null,
  );
}

class SectionDetailPage extends StatefulWidget {
  final String title;

  const SectionDetailPage({super.key, required this.title});

  @override
  State<SectionDetailPage> createState() => _SectionDetailPageState();
}

class _SectionDetailPageState extends State<SectionDetailPage> {
  dynamic section;
  String content = 'Loading...';
  double _fontSize = 18;

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  Future<void> loadContent() async {
    final result = await loadSectionContent(widget.title);
    if (result != null) {
      setState(() {
        section = result;
        content = result['content'] ?? 'No content available';
      });
    } else {
      setState(() {
        content = 'Section not found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange.shade800,
      ),
      body: section == null
          ? Center(child: Text(content))
          : section.containsKey('subsections')
              ? ListView.builder(
                  itemCount: section['subsections'].length,
                  itemBuilder: (context, index) {
                    var subsection = section['subsections'][index];
                    return ListTile(
                      title: Text(subsection['title']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SectionDetailPage(title: subsection['title']),
                          ),
                        );
                      },
                    );
                  },
                )
              : Column(
                  children: [
                    // 🔍 ZOOM SLIDER (TOP)
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      color: Colors.orange.shade50,
                      child: Row(
                        children: [
                          const Icon(Icons.zoom_out),
                          Expanded(
                            child: Slider(
                              min: 14,
                              max: 36,
                              divisions: 22,
                              value: _fontSize,
                              onChanged: (value) {
                                setState(() {
                                  _fontSize = value;
                                });
                              },
                            ),
                          ),
                          const Icon(Icons.zoom_in),
                        ],
                      ),
                    ),

                    // 📜 TEXT CONTENT
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          content,
                          style: TextStyle(
                            fontSize: _fontSize,
                            height: 1.8,
                            fontFamily: 'NotoSansDevanagari',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

 class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DriveService.fetchAudios(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Failed to load bhajans'));
        }

        final audios = snapshot.data as List;

        if (audios.isEmpty) {
          return const Center(child: Text('No bhajans found'));
        }

        return ListView.builder(
          itemCount: audios.length,
          itemBuilder: (context, index) {
            final audio = audios[index];

            return ListTile(
              leading: const Icon(Icons.music_note, color: Colors.orange),
              title: Text(audio['name']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AudioPlayerScreen(
                      title: audio['name'],
                      fileId: audio['id'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}






