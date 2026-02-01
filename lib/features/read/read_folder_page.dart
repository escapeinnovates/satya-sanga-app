import 'package:flutter/material.dart';
import '../../app_layout.dart';
import 'read_service.dart';
import 'PDFViewerPage.dart';

class ReadFolderPage extends StatelessWidget {
  final String folderId;
  final String folderName;

  const ReadFolderPage({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(folderName)),
      body: FutureBuilder(
        future: ReadService.fetchReadItems(folderId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data as List;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isFolder =
                  item['mimeType'] == 'application/vnd.google-apps.folder';

              return ListTile(
                leading: Icon(
                  isFolder ? Icons.folder : Icons.picture_as_pdf,
                  color: isFolder ? Colors.blue : Colors.red,
                ),
                title: Text(item['name']),
                trailing: Icon(
                  isFolder ? Icons.arrow_forward_ios : Icons.picture_as_pdf,
                ),
                onTap: () {
                  final isFolder =
                      item['mimeType'] == 'application/vnd.google-apps.folder';

                  if (isFolder) {
                    // 📁 Open sub-folder
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReadFolderPage(
                          folderId: item['id'],
                          folderName: item['name'],
                        ),
                      ),
                    );
                  } else {
                    // 📄 Open PDF (FULL SCREEN, no language button)

                    final String url =
                        "https://drive.google.com/uc?export=download&id=${item['id']}";

                    final String title = item['name']
                        .toString()
                        .replaceAll('.pdf', '')
                        .replaceAll('.PDF', '');

                    AppLayout.of(
                      context,
                    ).open(PDFViewerPage(url: url, title: title));
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
