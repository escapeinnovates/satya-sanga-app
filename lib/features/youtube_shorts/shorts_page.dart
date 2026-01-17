import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import './shorts_service.dart';

class ShortsPage extends StatefulWidget {
  const ShortsPage({super.key});

  @override
  State<ShortsPage> createState() => ShortsPageState();
}

class ShortsPageState extends State<ShortsPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final YouTubeService youtubeService = YouTubeService();
  final PageController _pageController = PageController();

  final Map<int, YoutubePlayerController> _controllers = {};
  int _currentIndex = 0;
  bool _initialized = false;

  // 👆 Swipe hint
  late AnimationController _hintController;
  late Animation<double> _hintAnimation;
  bool _showHint = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _hintAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );

    _hintController.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showHint = false);
        _hintController.stop();
      }
    });
  }

  // 🔴 Called from AppLayout when leaving Shorts tab
  void pauseAllVideos() {
    for (final controller in _controllers.values) {
      controller.pause();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      pauseAllVideos();
    }
  }

  YoutubePlayerController _createController(
    String videoId, {
    bool muted = false,
  }) {
    return YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false, // manual control only
        mute: muted,
        disableDragSeek: true,
        loop: true,
        controlsVisibleAtStart: false,
      ),
    );
  }

  void _initControllers(List shorts) {
    if (_initialized) return;

    _controllers[0] =
        _createController(shorts[0]['id']['videoId']);

    if (shorts.length > 1) {
      _controllers[1] = _createController(
        shorts[1]['id']['videoId'],
        muted: true,
      );
    }

    _initialized = true;

    // ▶️ Auto-play first short
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllers[0]?.play();
    });
  }

  void _handlePageChange(int index, List shorts) {
    _controllers[_currentIndex]?.pause();
    _currentIndex = index;

    final current = _controllers[index];
    if (current != null) {
      current.unMute();
      current.play();
    }

    if (!_controllers.containsKey(index + 1) &&
        index + 1 < shorts.length) {
      _controllers[index + 1] = _createController(
        shorts[index + 1]['id']['videoId'],
        muted: true,
      );
    }

    _controllers.removeWhere((key, controller) {
      if ((key - index).abs() > 1) {
        controller.dispose();
        return true;
      }
      return false;
    });

    if (_showHint) {
      setState(() => _showHint = false);
      _hintController.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    for (final controller in _controllers.values) {
      controller.dispose();
    }

    _pageController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: youtubeService.fetchShorts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final shorts = snapshot.data as List;

          if (shorts.isEmpty) {
            return const Center(
              child: Text(
                'No Shorts Found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          _initControllers(shorts);

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: shorts.length,
                onPageChanged: (index) =>
                    _handlePageChange(index, shorts),
                itemBuilder: (context, index) {
                  final controller = _controllers[index];
                  if (controller == null) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  return YoutubePlayer(
                    controller: controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                  );
                },
              ),

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
                        Icon(Icons.keyboard_arrow_up,
                            color: Colors.white, size: 42),
                        SizedBox(height: 6),
                        Text(
                          'Swipe up',
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
          );
        },
      ),
    );
  }
}
