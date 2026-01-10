import 'package:flutter/material.dart';
import '../services/youtube_service.dart';
import 'video_player_page.dart';

class VideosPage extends StatelessWidget {
  VideosPage({super.key});

  final YouTubeService youtubeService = YouTubeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ WHITE background
      body: FutureBuilder(
        future: youtubeService.fetchVideos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final videos = snapshot.data as List;

          if (videos.isEmpty) {
            return const Center(child: Text("No videos found"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index]['snippet'];
              final videoId = videos[index]['id']['videoId'];
              final thumbnail = video['thumbnails']['medium']['url'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerPage(videoId: videoId),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Softer gradient for white UI
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
                                Colors.black.withOpacity(0.65),
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
                          video['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "New",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
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
      ),
    );
  }
}
