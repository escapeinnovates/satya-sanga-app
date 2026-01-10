import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../services/youtube_service.dart';

class YoutubePlaylistPage extends StatefulWidget {
  final String playlistId;

  const YoutubePlaylistPage({super.key, required this.playlistId});

  @override
  State<YoutubePlaylistPage> createState() => _YoutubePlaylistPageState();
}

class _YoutubePlaylistPageState extends State<YoutubePlaylistPage> {
  final YouTubeService youtubeService = YouTubeService();

  YoutubePlayerController? controller;
  List videos = [];
  int current = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    videos = await youtubeService.fetchPlaylistVideos(widget.playlistId);
    final firstId = videos[0]['snippet']['resourceId']['videoId'];

    controller = YoutubePlayerController(
      initialVideoId: firstId,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );

    setState(() {});
  }

  void play(int index) {
    final id = videos[index]['snippet']['resourceId']['videoId'];
    controller!.load(id);
    setState(() => current = index);
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          YoutubePlayer(controller: controller!),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 16 / 9,
              ),
              itemCount: videos.length,
              itemBuilder: (context, i) {
                final v = videos[i]['snippet'];
                final thumb = v['thumbnails']['medium']['url'];

                return GestureDetector(
                  onTap: () => play(i),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          thumb,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // dark gradient
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // title
                      Positioned(
                        bottom: 6,
                        left: 6,
                        right: 6,
                        child: Text(
                          v['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // playing indicator
                      if (i == current)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(
                            Icons.play_circle,
                            color: Colors.red,
                            size: 26,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
