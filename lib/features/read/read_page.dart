import 'package:flutter/material.dart';
import 'read_service.dart';
import './read_webview_screen.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  late Future<List<dynamic>> _readItemsFuture;

  @override
  void initState() {
    super.initState();

    // ✅ Load books
    _readItemsFuture = ReadService.fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _readItemsFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No books found"));
          }

          final items = snapshot.data!
              .where((item) =>
                  item['title']
                      .toString()
                      .toLowerCase()
                      .contains(_query.toLowerCase()))
              .toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {

              final book = items[index];

              final title = book['title'] ?? '';

              final coverUrl = book['cover_url'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReadWebViewScreen(
                        bookId: book['id'],
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: coverUrl != null
                          ? Image.network(
                              coverUrl,
                              height: 120,
                              width: 90,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 120,
                              width: 90,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.menu_book),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}