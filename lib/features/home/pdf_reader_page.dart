import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFReaderPage extends StatefulWidget {
  final String title;
  final String pdfPath;

  const PDFReaderPage({super.key, required this.title, required this.pdfPath});

  @override
  State<PDFReaderPage> createState() => _PDFReaderPageState();
}

class _PDFReaderPageState extends State<PDFReaderPage> {
  final PdfViewerController _pdfController = PdfViewerController();
  double _zoomLevel = 1.0;

  void _zoomIn() {
    _setZoom(0.1);
  }

  void _zoomOut() {
    _setZoom(-0.1);
  }

  void _setZoom(double delta) {
    final double newZoom = (_zoomLevel + delta).clamp(1.0, 2.0);

    setState(() {
      _zoomLevel = newZoom;
      _pdfController.zoomLevel = _zoomLevel;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Re-fit page to screen width to keep center aligned
      _pdfController.zoomLevel = _zoomLevel;
      _pdfController.jumpTo(xOffset: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange.shade800,
      ),
      body: Stack(
        children: [
          // PDF
          SfPdfViewer.asset(
            widget.pdfPath,
            controller: _pdfController,
            pageLayoutMode: PdfPageLayoutMode.single,
            scrollDirection: PdfScrollDirection.vertical,
            enableDoubleTapZooming: false,
            enableTextSelection: false,
            canShowScrollHead: false,
            canShowScrollStatus: false,
          ),

          // Floating Zoom Controls
          Positioned(
            bottom: 50,
            right: 16,
            child: Column(
              children: [
                _ZoomButton(icon: Icons.add, onTap: _zoomIn),
                const SizedBox(height: 10),
                _ZoomButton(icon: Icons.remove, onTap: _zoomOut),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Zoom Button UI ----------------

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      color: Colors.orange.shade800,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
