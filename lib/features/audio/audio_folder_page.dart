import 'package:flutter/material.dart';
import 'audio_service.dart'; // Google Drive API service
import 'audio_player.dart'; // Audio player screen

// This page represents ONE folder inside Google Drive
// Example: Hanuman, Shiva, Ramayan
class AudioFolderPage extends StatelessWidget {
  final String folderId; // Google Drive folder ID
  final String folderName; // Folder name (for navigation)

  const AudioFolderPage({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // 🔶 Header Banner with Back Button
          satyaSangBanner(context),

          // 🔶 Folder content
          Expanded(
            child: FutureBuilder(
              future: DriveService.fetchFolderItems(folderId),
              builder: (context, snapshot) {
                // Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // No data state
                if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                  return const Center(child: Text('No bhajans found'));
                }

                final items = snapshot.data as List;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    // Check if item is folder
                    final isFolder =
                        item['mimeType'] ==
                        'application/vnd.google-apps.folder';

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (isFolder) {
                            // 📁 Open sub-folder
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AudioFolderPage(
                                  folderId: item['id'],
                                  folderName: item['name'],
                                ),
                              ),
                            );
                          } else {
                            // 🎵 Play audio
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AudioPlayerScreen(
                                  title: item['name'],
                                  fileId: item['id'],
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
                              // 🔵 LEFT ICON (folder / music)
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

                              // 📝 TITLE
                              Expanded(
                                child: Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ), // 👈 spacing before right icon
                              // ▶️ RIGHT ICON
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔶 Reusable Satya-Sang banner with back arrow
Widget satyaSangBanner(BuildContext context) {
  return Stack(
    children: [
      // 🌼 Banner Image
      SizedBox(
        height: 70,
        width: double.infinity,
        child: Image.asset("assets/images/banner.jpg", fit: BoxFit.cover),
      ),

      // 🔴 Back Button (NO shadow)
      Positioned(
        left: 12,
        top: 18,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SizedBox(
            width: 36,
            height: 36,
            child: const Icon(Icons.arrow_back, color: Colors.red, size: 22),
          ),
        ),
      ),
    ],
  );
}
