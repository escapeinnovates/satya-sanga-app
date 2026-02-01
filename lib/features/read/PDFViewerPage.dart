import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatefulWidget {
  final String url;   // 🌐 Network PDF URL
  final String title;

  const PDFViewerPage({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  // 🎮 PDF controller
  final PdfViewerController _controller = PdfViewerController();

  // 📄 Page info
  int _currentPage = 1;
  int _totalPages = 1;

  // 🔍 Zoom
  double _zoom = 1.0;

  // ---------------- ZOOM ----------------

  void _zoomIn() {
    _zoom = (_zoom + 0.1).clamp(1.0, 2.5);
    _controller.zoomLevel = _zoom;
  }

  void _zoomOut() {
    _zoom = (_zoom - 0.1).clamp(1.0, 2.5);
    _controller.zoomLevel = _zoom;
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false, // 🔥 allows PDF to touch AppBar
        child: Stack(
          children: [
            // ================= PDF VIEW =================
            Padding(
              // 👇 small offset so PDF touches AppBar nicely
              padding: const EdgeInsets.only(top: kToolbarHeight + 8),
              child: SfPdfViewer.network(
                widget.url,
                controller: _controller,

                // ❌ remove Syncfusion UI
                canShowScrollHead: false,
                canShowScrollStatus: false,
                pageSpacing: 0,

                // ✅ CENTER ZOOM FIX (MOST IMPORTANT)
                onZoomLevelChanged: (details) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final screenWidth =
                        MediaQuery.of(context).size.width;

                    final scale =
                        details.newZoomLevel / details.oldZoomLevel;

                    _controller.jumpTo(
                      xOffset:
                          (_controller.scrollOffset.dx + screenWidth / 2) *
                                  scale -
                              screenWidth / 2,
                    );
                  });
                },

                // 📄 total pages
                onDocumentLoaded: (details) {
                  setState(() {
                    _totalPages = details.document.pages.count;
                  });
                },

                // 📄 current page
                onPageChanged: (details) {
                  setState(() {
                    _currentPage = details.newPageNumber;
                  });
                },
              ),
            ),

            // ================= TOP BAR =================
            _buildTopBar(context),

            // ================= BOTTOM BAR =================
            _buildBottomControlBar(),
          ],
        ),
      ),
    );
  }

  // ---------------- TOP BAR ----------------

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 12,
          right: 12,
        ),
        color: Colors.orange.shade800,
        child: Row(
          children: [
            // ⬅ back
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A00),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // 📄 title
            Expanded(
              child: Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BOTTOM BAR ----------------

  Widget _buildBottomControlBar() {
    return Positioned(
      bottom: 24,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 📄 page indicator
              Text(
                'Page $_currentPage / $_totalPages',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),

              const SizedBox(width: 16),

              // 🔍 zoom out
              GestureDetector(
                onTap: _zoomOut,
                child: const Icon(
                  Icons.zoom_out,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              // 🔍 zoom in
              GestureDetector(
                onTap: _zoomIn,
                child: const Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
