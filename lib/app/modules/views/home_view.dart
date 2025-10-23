import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/web_controller';
import 'webview_page.dart';
import 'portfolio_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final WebController controller = Get.put(WebController());
  final TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 600 : double.infinity,
            ),
            padding: EdgeInsets.all(isWeb ? 32 : 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hero Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[600]!, Colors.purple[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.web,
                        size: isWeb ? 80 : 60,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Website to App',
                        style: TextStyle(
                          fontSize: isWeb ? 32 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Transform any website into a native app experience',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isWeb ? 16 : 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Input Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Website URL',
                        style: TextStyle(
                          fontSize: isWeb ? 20 : 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: urlController,
                        decoration: InputDecoration(
                          hintText: 'https://example.com',
                          prefixIcon: const Icon(Icons.link, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.blue, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.rocket_launch),
                          label: const Text(
                            'Launch App',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          onPressed: () {
                            if (urlController.text.isNotEmpty) {
                              controller.loadWebsite(urlController.text);
                              Get.to(() => const WebViewPage());
                            } else {
                              Get.snackbar(
                                'Error',
                                'Please enter a valid URL',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red[100],
                                colorText: Colors.red[800],
                                icon: const Icon(Icons.error, color: Colors.red),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.person),
                          label: const Text(
                            'View Portfolio',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue[600],
                            side: BorderSide(color: Colors.blue[600]!, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Get.to(() => const PortfolioView()),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Quick Access
                Text(
                  'Quick Access',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildQuickAccessChip('Portfolio', '${Uri.base.origin}/portfolio.html'),
                    _buildQuickAccessChip('Google', 'https://google.com'),
                    _buildQuickAccessChip('GitHub', 'https://github.com'),
                    _buildQuickAccessChip('YouTube', 'https://youtube.com'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildQuickAccessChip(String label, String url) {
    return ActionChip(
      label: Text(label),
      avatar: const Icon(Icons.language, size: 16),
      onPressed: () {
        urlController.text = url;
        controller.loadWebsite(url);
        Get.to(() => const WebViewPage());
      },
      backgroundColor: Colors.blue[50],
      labelStyle: TextStyle(color: Colors.blue[700]),
    );
  }
}
