import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../config/ui_state.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String title;
  final String fileId;

  const AudioPlayerScreen({
    super.key,
    required this.title,
    required this.fileId,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool isPlaying = false;

  // ---------------- LIFECYCLE ----------------

  @override
  void initState() {
    super.initState();

    // ❌ Hide translate button when audio page opens
    UIState.showLanguageButton.value = false;

    // 🎵 Load audio
    _player.setUrl('https://drive.google.com/uc?id=${widget.fileId}');

    // ⏱ Total duration
    _player.durationStream.listen((d) {
      if (d != null) {
        setState(() => _duration = d);
      }
    });

    // ▶️ Current position
    _player.positionStream.listen((p) {
      setState(() => _position = p);
    });

    // ⏯ Play / Pause state
    _player.playerStateStream.listen((state) {
      setState(() => isPlaying = state.playing);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // ---------------- HELPERS ----------------

  String formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 🔥 GUARANTEED restore when leaving page
      onWillPop: () async {
        UIState.showLanguageButton.value = true;
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Column(
          children: [
            // 🔥 Banner + Custom Back Button
            _satyaSangBanner(context),

            // 🎧 Audio Player UI
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // 🎵 Album Art
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          height: 250,
                          width: 250,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.music_note,
                            size: 120,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 🎶 Title
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ⏱ Progress Slider
                      Slider(
                        activeColor: Colors.black,
                        inactiveColor: Colors.grey.shade300,
                        min: 0,
                        max: _duration.inSeconds.toDouble(),
                        value: _position.inSeconds
                            .clamp(0, _duration.inSeconds)
                            .toDouble(),
                        onChanged: (value) {
                          _player.seek(Duration(seconds: value.toInt()));
                        },
                      ),

                      // ⏰ Time Labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatTime(_position)),
                          Text(formatTime(_duration)),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // ▶️ Play / Pause Button
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.black,
                        child: IconButton(
                          iconSize: 50,
                          color: Colors.white,
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          onPressed: () {
                            isPlaying ? _player.pause() : _player.play();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BANNER ----------------

  Widget _satyaSangBanner(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // 🖼 Banner Image (status bar + banner height)
        SizedBox(
          height: statusBarHeight + 40,
          width: double.infinity,
          child: Image.asset("assets/images/banner.jpg", fit: BoxFit.cover),
        ),

        // 🔙 Custom Back Button (pushed below status bar)
        Positioned(
          left: 15,
          top: statusBarHeight + 4,
          child: GestureDetector(
            onTap: () {
              UIState.showLanguageButton.value = true;
              Navigator.pop(context);
            },
            child: Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A00),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
