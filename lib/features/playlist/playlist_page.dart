import 'package:flutter/material.dart';
import './playlist_service.dart';
import '../playlist_video/playlist_video.dart';
import '../../app_layout.dart';

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

    // API call happens once
    _playlistFuture = playlistService.fetchPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _playlistFuture,

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final playlists = snapshot.data!;

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
              final playlist = playlists[index];

              final int playlistId = playlist['id'];
              final String thumbnail = playlist['thumbnail_url'] ?? '';
              final String title = playlist['title'] ?? '';
              final int count = playlist['video_count'] ?? 0;

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
