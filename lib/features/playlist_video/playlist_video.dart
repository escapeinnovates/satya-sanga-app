import 'package:flutter/material.dart';
import './playlist_video_service.dart';
import './video_player.dart';

class YoutubePlaylistPage extends StatefulWidget {
  final String playlistId;

  const YoutubePlaylistPage({super.key, required this.playlistId});

  @override
  State<YoutubePlaylistPage> createState() => _YoutubePlaylistPageState();
}

class _YoutubePlaylistPageState extends State<YoutubePlaylistPage> {
  final YouTubeService youtubeService = YouTubeService();
  List videos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    videos = await youtubeService.fetchPlaylistVideos(widget.playlistId);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: Colors.white,
      child: GridView.builder(
        padding: const EdgeInsets.all(6),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 14,
          childAspectRatio: 1, // makes each tile taller
        ),
        itemCount: videos.length,
        itemBuilder: (context, i) {
          final v = videos[i]['snippet'];
          final title = v['title'];
          final description = v['description'];
          final thumb = v['thumbnails']['medium']['url'];
          final videoId = v['resourceId']['videoId'];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPlayerPage(
                    videoId: videoId,
                    title: title,
                    description: description,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(thumb, fit: BoxFit.cover),
                        const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            size: 68,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  v['title'],
                  maxLines: 3, // allow more lines
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.3,
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
