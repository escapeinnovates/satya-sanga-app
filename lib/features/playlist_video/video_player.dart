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

  @override
  Widget build(BuildContext context) {
        
    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(
  toolbarHeight: 70, // adjust height if needed
  elevation: 0,
  backgroundColor: Colors.transparent,
  automaticallyImplyLeading: true,
  iconTheme: const IconThemeData(color: Colors.red),

  flexibleSpace: SafeArea(
    bottom: false,
    child: SizedBox.expand(
      child: Image.asset(
        'assets/images/banner.jpg', // 👈 your image
        fit: BoxFit.cover,
      ),
    ),
  ),
),

      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) {
          final meta = controller.value.metaData;

          return SafeArea(
            child: Column(
              children: [
                // Fixed video area (portrait mode)
                AspectRatio(aspectRatio: 16 / 9, child: player),

                // Everything below becomes scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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

                        // Channel / Author
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            meta.author,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ),

                        const Divider(height: 20),

                        // Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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
    );
  }
}
