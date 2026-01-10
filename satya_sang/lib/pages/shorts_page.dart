import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../services/youtube_service.dart';

class ShortsPage extends StatefulWidget {
  const ShortsPage({super.key});

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage>
    with SingleTickerProviderStateMixin {
  final YouTubeService youtubeService = YouTubeService();
  final PageController _pageController = PageController();

  final List<YoutubePlayerController> _controllers = [];
  int _currentIndex = 0;
  bool _initialized = false;

  // 🔥 Swipe hint animation
  late AnimationController _hintController;
  late Animation<double> _hintAnimation;
  bool _showHint = true;

  @override
  void initState() {
    super.initState();

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _hintAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );

    _hintController.repeat(reverse: true);

    // Auto hide hint after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showHint = false);
        _hintController.stop();
      }
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    _pageController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔥 Shorts content
          FutureBuilder(
            future: youtubeService.fetchShorts(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final shorts = snapshot.data as List;

              if (shorts.isEmpty) {
                return const Center(child: Text("No Shorts found"));
              }

              // Initialize controllers only once
              if (!_initialized) {
                for (var item in shorts) {
                  final videoId = item['id']['videoId'];

                  _controllers.add(
                    YoutubePlayerController(
                      initialVideoId: videoId,
                      flags: const YoutubePlayerFlags(
                        autoPlay: false,
                        mute: false,
                        disableDragSeek: true,
                        loop: true,
                      ),
                    ),
                  );
                }

                _controllers.first.play();
                _initialized = true;
              }

              return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: shorts.length,
                onPageChanged: (index) {
                  _controllers[_currentIndex].pause();
                  _controllers[index].play();
                  _currentIndex = index;

                  // Hide hint after first swipe
                  if (_showHint) {
                    setState(() => _showHint = false);
                    _hintController.stop();
                  }
                },
                itemBuilder: (context, index) {
                  return RepaintBoundary(
                    child: YoutubePlayer(
                      controller: _controllers[index],
                      showVideoProgressIndicator: true,
                    ),
                  );
                },
              );
            },
          ),

          // 👆 Swipe-Up Hint Overlay
          if (_showHint)
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _hintAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _hintAnimation.value),
                    child: child,
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 42,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Swipe up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
