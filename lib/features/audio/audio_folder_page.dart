import 'package:flutter/material.dart';
import 'audio_service.dart';     // Google Drive API service
import 'audio_player.dart';     // Your existing audio player screen

// This page represents ONE folder inside Google Drive
// Example: Hanuman, Shiva, Ramayan etc.
class AudioFolderPage extends StatelessWidget {
  final String folderId;    // Google Drive folder ID
  final String folderName;  // Name shown in AppBar

  const AudioFolderPage({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Shows the current folder name on top
      appBar: AppBar(title: Text(folderName)),

      // Loads all items inside this folder from Google Drive
      body: FutureBuilder(
        future: DriveService.fetchFolderItems(folderId), // API call
        builder: (context, snapshot) {
          // While loading, show spinner
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // This list contains both:
          // - Subfolders
          // - Audio files
          final items = snapshot.data as List;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              // Check if this item is a folder
              final isFolder =
                  item['mimeType'] == 'application/vnd.google-apps.folder';

              return ListTile(
                // Folder icon for folders, music icon for audio files
                leading: Icon(isFolder ? Icons.folder : Icons.music_note),

                // File or folder name
                title: Text(item['name']),

                // What happens when user taps this row
                onTap: () {
                  if (isFolder) {
                    // 📁 If user taps a folder → open it
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AudioFolderPage(
                          folderId: item['id'],   // Open this folder
                          folderName: item['name'],
                        ),
                      ),
                    );
                  } else {
                    // 🎵 If user taps an audio file → play it
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AudioPlayerScreen(
                          title: item['name'], // Song name
                          fileId: item['id'],  // Google Drive file ID
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
