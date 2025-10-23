import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/web_controller';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final WebController controller = Get.find<WebController>();
  late WebViewController webViewController;
  bool isLoading = true;
  String currentUrl = '';

  @override
  void initState() {
    super.initState();
    currentUrl = controller.websiteUrl.value;
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => isLoading = true),
          onPageFinished: (url) => setState(() {
            isLoading = false;
            currentUrl = url;
          }),
        ),
      )
      ..loadRequest(Uri.parse(controller.websiteUrl.value));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock,
                size: 16,
                color: currentUrl.startsWith('https') ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _formatUrl(currentUrl),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (isLoading)
            Container(
              margin: const EdgeInsets.all(16),
              width: 20,
              height: 20,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black87),
              onPressed: () => webViewController.reload(),
            ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
          if (isWeb) const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: webViewController),
          if (isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading website...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: isWeb ? null : Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                if (await webViewController.canGoBack()) {
                  webViewController.goBack();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () async {
                if (await webViewController.canGoForward()) {
                  webViewController.goForward();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => webViewController.reload(),
            ),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatUrl(String url) {
    if (url.isEmpty) return controller.websiteUrl.value;
    return url.replaceAll(RegExp(r'^https?://'), '').split('/')[0];
  }
}
