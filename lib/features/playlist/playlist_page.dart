import 'package:flutter/material.dart';
import './playlist_service.dart';
import '../playlist_video/playlist_video.dart';
import '../../app_layout.dart';
import '../../config/youtube_config.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final PlaylistService playlistService = PlaylistService();

  late Future<List<dynamic>> _playlistFuture;

  @override
  void initState() {
    super.initState();

    // ✅ API call happens ONLY when VideosPage is created
    _playlistFuture = playlistService.fetchPlaylist(YouTubeConfig.channelId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _playlistFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final playlists = snapshot.data as List;

        if (playlists.isEmpty) {
          return const Center(child: Text("No playlists found"));
        }

        return Container(
          color: Colors.white,
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final p = playlists[index]['snippet'];
              final playlistId = playlists[index]['id'];
              final thumbnail = p['thumbnails']['medium']['url'];
              final title = p['title'];
              final count = playlists[index]['contentDetails']['itemCount'];

              return GestureDetector(
                onTap: () {
                  AppLayout.of(
                    context,
                  ).open(YoutubePlaylistPage(playlistId: playlistId));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(thumbnail, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$count videos",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
