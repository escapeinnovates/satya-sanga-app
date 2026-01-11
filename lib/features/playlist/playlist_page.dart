import 'package:flutter/material.dart';
import './playlist_service.dart';
import '../playlist_video/playlist_video.dart';
import '../../app_layout.dart';

class VideosPage extends StatelessWidget {
  VideosPage({super.key});

  final PlaylistService playlistService = PlaylistService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: playlistService.fetchPlaylist(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final playlists = snapshot.data as List;

        if (playlists.isEmpty) {
          return const Center(child: Text("No playlists found"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.9,
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

              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(thumbnail, fit: BoxFit.cover),
                    ),
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
                              Colors.black.withOpacity(0.75),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        "$title • $count videos",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
