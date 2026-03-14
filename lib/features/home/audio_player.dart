import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../config/ui_state.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String title;
  final String audioUrl;

  const AudioPlayerScreen({
    super.key,
    required this.title,
    required this.audioUrl,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {

  final AudioPlayer _player = AudioPlayer();

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    UIState.showLanguageButton.value = false;
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {

      await _player.setUrl(widget.audioUrl);

      _player.play(); // autoplay

      _player.durationStream.listen((d) {
        if (d != null) setState(() => _duration = d);
      });

      _player.positionStream.listen((p) {
        setState(() => _position = p);
      });

      _player.playerStateStream.listen((state) {
        setState(() => isPlaying = state.playing);
      });

    } catch (e) {
      debugPrint("Audio error: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    UIState.showLanguageButton.value = true;
    super.dispose();
  }

  String formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  void skipForward() {
    _player.seek(_position + const Duration(seconds: 10));
  }

  void skipBackward() {
    _player.seek(_position - const Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(

      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Album Art
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: Container(
                height: 220,
                width: 220,
                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: const Icon(
                  Icons.music_note,
                  size: 100,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              widget.title,
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(_position)),
                Text(formatTime(_duration)),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.replay_10),
                  onPressed: skipBackward,
                ),

                const SizedBox(width: 10),

                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.black,

                  child: IconButton(
                    iconSize: 40,
                    color: Colors.white,
                    icon: Icon(
                      isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),

                    onPressed: () {
                      isPlaying
                          ? _player.pause()
                          : _player.play();
                    },
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.forward_10),
                  onPressed: skipForward,
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}