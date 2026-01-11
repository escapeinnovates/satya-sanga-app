import 'package:flutter/material.dart';
import 'audio_service.dart';
import 'audio_player.dart';

class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bhajans')),
      body: FutureBuilder(
        future: DriveService.fetchAudios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading bhajans'));
          }

          final audios = snapshot.data as List;

          if (audios.isEmpty) {
            return const Center(child: Text('No bhajans found'));
          }

          return ListView.builder(
            itemCount: audios.length,
            itemBuilder: (context, index) {
              final audio = audios[index];

              return ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(audio['name']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AudioPlayerScreen(
                        title: audio['name'],
                        fileId: audio['id'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
