import 'package:flutter/material.dart';
import 'package:satya_sang/app_layout.dart';
import 'audio_service.dart';
import 'audio_folder_page.dart';

class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AudioService.fetchRootFolders(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("No audio folders found"));
        }

        final folders = snapshot.data as List;

        if (folders.isEmpty) {
          return const Center(child: Text("No folders"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: folders.length,

          separatorBuilder: (_, __) => const SizedBox(height: 10),

          itemBuilder: (context, index) {
            final folder = folders[index];

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: ListTile(
                leading: const Icon(Icons.folder, color: Colors.blue, size: 28),

                title: Text(
                  folder['name'] ?? "Folder",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                trailing: const Icon(Icons.arrow_forward_ios_rounded),

                onTap: () {
                  AppLayout.of(context).open(
                    AudioFolderPage(
                      folderId: folder['id'],
                      folderName: folder['name'],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
