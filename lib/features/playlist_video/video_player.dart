import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoId;
  final String title;
  final String description;

  const VideoPlayerPage({
    super.key,
    required this.videoId,
    required this.title,
    required this.description,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        controlsVisibleAtStart: true,
        enableCaption: true,
        forceHD: true,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // ================= BANNER WITH BACK BUTTON =================
  Widget _satyaSangBanner(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          SizedBox(
            height: 70,
            width: double.infinity,
            child: Image.asset(
              'assets/images/banner.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 15,
            top: 22,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A00),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          // ================= CONTENT =================
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
            ),
            builder: (context, player) {
              final meta = controller.value.metaData;

              return SafeArea(
                top: false,
                child: Column(
                  children: [
                    const SizedBox(height: 70), // space for banner

                    // Video player
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: player,
                    ),

                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                meta.author,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            const Divider(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                widget.description,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // ================= TOP BANNER =================
          _satyaSangBanner(context),
        ],
      ),
    );
  }
}
