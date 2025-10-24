import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import '../controllers/web_controller';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final WebController controller = Get.find<WebController>();
  String viewId = 'webview-${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _registerWebView();
    }
  }

  void _registerWebView() {
    ui.platformViewRegistry.registerViewFactory(viewId, (int id) {
      final iframe = html.IFrameElement()
        ..src = controller.websiteUrl.value
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1e293b),
        foregroundColor: Colors.white,
        title: const Text(
          'Website Viewer',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                viewId = 'webview-${DateTime.now().millisecondsSinceEpoch}';
                _registerWebView();
              });
            },
          ),
        ],
      ),
      body: kIsWeb
          ? HtmlElementView(viewType: viewId)
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.web, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'WebView not supported on this platform',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}
