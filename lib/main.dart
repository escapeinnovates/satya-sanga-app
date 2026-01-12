import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'splash_screen.dart';
import 'features/playlist/playlist_page.dart'; // contains VideosPage
import 'features/youtube_shorts/shorts_page.dart'; // contains ShortsPage
import 'features/audio/audio_page.dart';
import 'app_layout.dart';
import 'features/home/home_page.dart';
import 'features/read/read_page.dart';



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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      setState(() {
        _ready = true;
      });
    }
  }

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
      supportedLocales: const [Locale('en', ''), Locale('hi', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _ready
          ? AppLayout(
              pages: [HomeScreen(), VideosPage(), AudioPage(), ShortsPage(), ReadPage()],
            )
          : const SplashScreen(),
    );
  }
}


