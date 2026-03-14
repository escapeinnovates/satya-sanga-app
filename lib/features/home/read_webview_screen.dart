import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReadWebViewScreen extends StatefulWidget {
  final int bookId;

  const ReadWebViewScreen({super.key, required this.bookId});

  @override
  State<ReadWebViewScreen> createState() => _ReadWebViewScreenState();
}

class _ReadWebViewScreenState extends State<ReadWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // React flipbook URL (admin public route)
    const String reactBaseUrl = "http://192.168.31.207:5173/quick-flipbook";

    final String fullUrl = "$reactBaseUrl?bookId=${widget.bookId}";

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint("🌐 Loading: $url");
          },
          onPageFinished: (url) {
            debugPrint("✅ Loaded: $url");
          },
          onWebResourceError: (error) {
            debugPrint("❌ WebView Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(fullUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Read Book")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
