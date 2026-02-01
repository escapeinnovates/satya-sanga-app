import 'package:flutter/material.dart';
import '../../config/drive_config.dart';
import '../../config/ui_state.dart';
import 'read_service.dart';
import 'read_folder_page.dart';
import 'PDFViewerPage.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _query = value.toLowerCase());
              },
              decoration: InputDecoration(
                hintText: 'Search books or folders...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📁 CONTENT
          Expanded(
            child: FutureBuilder(
              future: ReadService.fetchAllReadItemsRecursive(
                DriveConfig.pdfFolderId,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                  return const Center(child: Text('No books found'));
                }

                final List items = (snapshot.data as List)
                    .where(
                      (item) => item['name'].toString().toLowerCase().contains(
                        _query,
                      ),
                    )
                    .toList();

                if (items.isEmpty) {
                  return const Center(child: Text('No matching results'));
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.8,
                        ),
                    itemBuilder: (context, index) {
                      final item = items[index];

                      final bool isFolder =
                          item['mimeType'] ==
                          'application/vnd.google-apps.folder';

                      final String title = item['name']
                          .toString()
                          .replaceAll('.pdf', '')
                          .replaceAll('.PDF', '');

                      final String url =
                          "https://drive.google.com/uc?export=download&id=${item['id']}";

                      return GestureDetector(
                        onTap: () {
                          if (isFolder) {
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
                            // 🔴 Hide language button
                            UIState.showLanguageButton.value = false;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PDFViewerPage(url: url, title: title),
                              ),
                            ).then((_) {
                              // 🟢 Show again when user comes back
                              UIState.showLanguageButton.value = true;
                            });
                          }
                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              alignment: Alignment.center,
                              child: Icon(
                                isFolder ? Icons.folder : Icons.picture_as_pdf,
                                size: 64,
                                color: isFolder
                                    ? Colors.amber.shade700
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
