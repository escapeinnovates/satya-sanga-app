import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class GuruVandanaPDF extends StatelessWidget {
  const GuruVandanaPDF({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guru Vandana"),
        backgroundColor: Colors.orange.shade800,
      ),
      body: SfPdfViewer.asset(
        'assets/read/guru_vandana.pdf',
        enableTextSelection: false, // no copy
        canShowScrollHead: false,
        canShowScrollStatus: false,
      ),
    );
  }
}