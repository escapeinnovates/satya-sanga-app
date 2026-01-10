import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatelessWidget {
  final String videoId;

  const VideoPlayerPage({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        forceHD: true,
      ),
    );

    return Scaffold(
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) {
          return SafeArea(child: player);
        },
      ),
    );
  }
}
