import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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

  @override
  void initState() {
    super.initState();

    _player.setUrl(
      'https://drive.google.com/uc?id=${widget.fileId}',
    );

    // Listen total duration
    _player.durationStream.listen((d) {
      if (d != null) {
        setState(() => _duration = d);
      }
    });

    // Listen position
    _player.positionStream.listen((p) {
      setState(() => _position = p);
    });

    // Listen play/pause state
    _player.playerStateStream.listen((state) {
      setState(() => isPlaying = state.playing);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Now Playing",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

            // ⏱ Slider
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

            // ⏰ Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(_position)),
                Text(formatTime(_duration)),
              ],
            ),

            const SizedBox(height: 30),

            // ▶️ Play / Pause (BLACK BUTTON)
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
    );
  }
}
