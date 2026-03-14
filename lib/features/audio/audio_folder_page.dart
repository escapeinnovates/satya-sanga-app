import 'package:flutter/material.dart';
import 'package:satya_sang/app_layout.dart';
import 'audio_service.dart';
import 'audio_player.dart';

class AudioFolderPage extends StatelessWidget {
  final int folderId;
  final String folderName;

  const AudioFolderPage({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(folderName)),

      body: FutureBuilder(
        future: AudioService.fetchFolder(folderId.toString()),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No content"));
          }

          final data = snapshot.data as Map;

          final folders = data['folders'] ?? [];
          final audios = data['audios'] ?? [];

          final items = [
            ...folders.map((f) => {"type": "folder", "data": f}),
            ...audios.map((a) => {"type": "audio", "data": a}),
          ];

          if (items.isEmpty) {
            return const Center(child: Text("Empty folder"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,

            separatorBuilder: (_, __) => const SizedBox(height: 10),

            itemBuilder: (context, index) {
              final item = items[index];
              final type = item["type"];
              final data = item["data"];

              if (type == "folder") {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.folder, color: Colors.blue),

                    title: Text(data['name'] ?? "Folder"),

                    trailing: const Icon(Icons.arrow_forward_ios),

                    onTap: () {
                      AppLayout.of(context).open(
                        AudioFolderPage(
                          folderId: data['id'],
                          folderName: data['name'],
                        ),
                      );
                    },
                  ),
                );
              }

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.music_note, color: Colors.orange),

                  title: Text(data['title'] ?? "Audio"),

                  trailing: const Icon(
                    Icons.play_circle_fill,
                    color: Colors.orange,
                    size: 30,
                  ),

                  onTap: () {
                    AppLayout.of(context).open(
                      AudioPlayerScreen(
                        title: data['title'],
                        audioUrl: data['audio_url'],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
