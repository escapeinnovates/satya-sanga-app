import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/ui_state.dart';
import 'app_layout.dart';
import 'splash_screen.dart';
import 'features/home/home_page.dart';
import 'features/playlist/playlist_page.dart';
import 'features/audio/audio_page.dart';
import 'features/youtube_shorts/shorts_page.dart';
import 'features/read/read_page.dart';

final GlobalKey<ShortsPageState> shortsKey =
    GlobalKey<ShortsPageState>();

// ---------------- LANGUAGE PROVIDER ----------------

class LanguageNotifier extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  void toggleLanguage() {
    _currentLocale =
        _currentLocale.languageCode == 'en'
            ? const Locale('hi')
            : const Locale('en');
    notifyListeners();
  }
}

// ---------------- MAIN ----------------

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageNotifier(),
      child: const MyApp(),
    ),
  );
}

// ---------------- APP ----------------

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
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _ready = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier =
        Provider.of<LanguageNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: languageNotifier.currentLocale,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ✅ UI OVERLAY LAYER (TRANSLATE BUTTON)
      builder: (context, child) {
        return Stack(
          children: [
            child!,

            ValueListenableBuilder<bool>(
              valueListenable: UIState.showLanguageButton,
              builder: (context, isVisible, _) {
                if (!isVisible) {
                  return const SizedBox.shrink();
                }

                return Positioned(
                  bottom: 150,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed:
                        languageNotifier.toggleLanguage, // ✅ ONLY toggle
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/icons/lang_icon.png',
                      width: 26,
                      height: 26,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },

      // ✅ HOME MUST BE HERE (NOT INSIDE BUILDER)
      home: _ready
          ? AppLayout(
              pages: [
                HomeScreen(),
                VideosPage(),
                AudioPage(),
                ShortsPage(key: shortsKey),
                ReadPage(),
              ],
            )
          : const SplashScreen(),
    );
  }
}
