import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satya_sang/app_layout.dart';

import '../../main.dart';
import '../read/read_page.dart';
import './shubh_vichar_section.dart';
import './quote_service.dart';
import './quote_model.dart';
import './quick_access_service.dart';
import './quick_access_model.dart';
import './read_webview_screen.dart';
import './audio_player.dart';
import './video_player_screen.dart';

import './announcement_model.dart';
import './announcement_service.dart';

import '../../pages/announcements_page.dart';
import '../../widgets/announcement_modal.dart';

import 'package:intl/intl.dart';

////////////////////////////////////////////////////////
/// HOME SCREEN
////////////////////////////////////////////////////////

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String quote = 'Loading...';
  String author = '';

  List<QuickAccessModel> quickItems = [];
  List<Announcement> announcements = [];

  @override
  void initState() {
    super.initState();
    loadQuoteFromSheet();
    loadQuickAccess();
    loadAnnouncements();
  }

  ////////////////////////////////////////////////////////
  /// LOAD QUOTE
  ////////////////////////////////////////////////////////

  Future<void> loadQuoteFromSheet() async {
    final QuoteModel? todayQuote = await QuoteService.fetchTodayQuote();

    if (!mounted) return;

    if (todayQuote == null || todayQuote.content.isEmpty) {
      setState(() {
        quote = 'No quote for today';
        author = '';
      });
      return;
    }

    setState(() {
      quote = todayQuote.content;
      author = todayQuote.author;
    });
  }

  ////////////////////////////////////////////////////////
  /// LOAD QUICK ACCESS
  ////////////////////////////////////////////////////////

  Future<void> loadQuickAccess() async {
    final items = await QuickAccessService.fetchQuickAccess();

    if (!mounted) return;

    setState(() {
      quickItems = items;
    });
  }

  ////////////////////////////////////////////////////////
  /// LOAD ANNOUNCEMENTS
  ////////////////////////////////////////////////////////

  Future<void> loadAnnouncements() async {
    final data = await AnnouncementService.getAnnouncements();

    if (!mounted) return;

    setState(() {
      announcements = data;
    });
  }

  ////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////

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
            /// QUOTE
            ShubhVicharSection(quote: quote, author: author),

            const SizedBox(height: 20),

            /// FEATURED CONTENT
            FeaturedContentSection(items: quickItems),

            const SizedBox(height: 20),

            /// ANNOUNCEMENTS
            AnnouncementsSection(
              title: languageNotifier.currentLocale.languageCode == 'en'
                  ? 'Announcements'
                  : 'घोषणाएँ',
              announcements: announcements,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// FEATURED CONTENT SECTION
////////////////////////////////////////////////////////

class FeaturedContentSection extends StatelessWidget {
  final List<QuickAccessModel> items;

  const FeaturedContentSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: Text("No content available")),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FEATURED CONTENT",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: Color(0xFF7A7090),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "आज के लिए चुना गया",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFF4EFE6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Text(
                    "सभी देखें",
                    style: TextStyle(color: Color(0xFFD4AF37), fontSize: 12),
                  ),
                  Icon(Icons.chevron_right, color: Color(0xFFD4AF37)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return QuickAccessCard(item: items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// QUICK ACCESS CARD
////////////////////////////////////////////////////////

class QuickAccessCard extends StatelessWidget {
  final QuickAccessModel item;

  const QuickAccessCard({super.key, required this.item});

  void openContent(BuildContext context) {
    switch (item.contentType) {
      case "book":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReadWebViewScreen(bookId: item.id)),
        );
        break;

      case "audio":
        AppLayout.of(context).open(
          AudioPlayerScreen(title: item.title, audioUrl: item.mediaUrl ?? ""),
        );
        break;

      case "video":
        AppLayout.of(context).open(
          VideoPlayerScreen(title: item.title, videoUrl: item.mediaUrl ?? ""),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = item.thumbnailUrl ?? item.previewPage ?? item.mediaUrl ?? "";

    final isMedia = item.contentType == "audio" || item.contentType == "video";

    return GestureDetector(
      onTap: () => openContent(context),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(child: Image.network(image, fit: BoxFit.cover)),

              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xF20C0A18),
                        Color(0x330C0A18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              if (isMedia)
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Color(0xFF0C0A18),
                      size: 20,
                    ),
                  ),
                ),

              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFF4EFE6),
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),

                    if (item.totalPages != null)
                      Text(
                        "${item.totalPages} pages",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFC4B8D8),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// ANNOUNCEMENTS SECTION
////////////////////////////////////////////////////////

class AnnouncementsSection extends StatelessWidget {
  final String title;
  final List<Announcement> announcements;

  const AnnouncementsSection({
    super.key,
    required this.title,
    required this.announcements,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, color: Color(0xFFF4EFE6)),
              ),
              GestureDetector(
                onTap: () {
                  AppLayout.of(context).open(const AnnouncementsPage());
                },
                child: const Row(
                  children: [
                    Text(
                      "सभी देखें",
                      style: TextStyle(color: Color(0xFFD4AF37), fontSize: 12),
                    ),
                    Icon(Icons.chevron_right, color: Color(0xFFD4AF37)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Column(
            children: announcements.map((ann) {
              return GestureDetector(
                onTap: () => showAnnouncementModal(context, ann),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1A36),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ann.title,
                              style: const TextStyle(
                                color: Color(0xFFF4EFE6),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ann.publishAt != null
                                  ? DateFormat(
                                      'dd MMM yyyy',
                                    ).format(ann.publishAt!)
                                  : "",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF7A7090),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(Icons.chevron_right, color: Color(0xFF7A7090)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
