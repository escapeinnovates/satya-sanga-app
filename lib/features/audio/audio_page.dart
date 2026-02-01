import 'package:flutter/material.dart';
import 'package:satya_sang/features/audio/audio_folder_page.dart';
import 'audio_service.dart';
import 'audio_player.dart';
import '../../config/drive_config.dart';

class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DriveService.fetchAudios(DriveConfig.folderId),
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

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.separated(
            itemCount: audios.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final audio = audios[index];
              final bool isFolder =
                  audio['mimeType'] == 'application/vnd.google-apps.folder';

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    if (isFolder) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AudioFolderPage(
                            folderId: audio['id'],
                            folderName: audio['name'],
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AudioPlayerScreen(
                            title: audio['name'],
                            fileId: audio['id'],
                          ),
                        ),
                      );
                    }
                  },

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        // LEFT ICON
                        Container(
                          decoration: BoxDecoration(
                            color: isFolder
                                ? Colors.blue.shade100
                                : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            isFolder ? Icons.folder : Icons.music_note,
                            color: isFolder ? Colors.blue : Colors.orange,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // TITLE
                        Expanded(
                          child: Text(
                            audio['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // RIGHT ICON
                        Icon(
                          isFolder
                              ? Icons.arrow_forward_ios_rounded
                              : Icons.play_circle_fill,
                          color: isFolder ? Colors.blue : Colors.orange,
                          size: isFolder ? 22 : 32,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
