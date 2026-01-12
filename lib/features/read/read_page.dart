import 'package:flutter/material.dart';
import 'package:satya_sang/features/read/PDFViewerPage.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import './read_service.dart';

class ReadPage extends StatelessWidget {
  const ReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ReadService.fetchPDFs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading books'));
        }

        final pdfs = snapshot.data as List;

        if (pdfs.isEmpty) {
          return const Center(child: Text('No books found'));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: pdfs.length,
            itemBuilder: (context, index) {
              final pdf = pdfs[index];
              final title = pdf['name'];
              final url = "https://drive.google.com/uc?export=download&id=${pdf['id']}"; // direct download URL
              final thumb = pdf['thumbnailLink'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PDFViewerPage(url: url, title: title),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: thumb != null
                              ? Image.network(thumb, fit: BoxFit.cover)
                              : Container(
                                  color: Colors.grey.shade300,
                                  child: const Icon(
                                    Icons.picture_as_pdf,
                                    size: 50,
                                    color: Colors.red,
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ],
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
