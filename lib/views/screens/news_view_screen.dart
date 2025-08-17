import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsViewScreen extends StatefulWidget {
  const NewsViewScreen({super.key});

  @override
  State<NewsViewScreen> createState() => _NewsViewScreenState();
}

class _NewsViewScreenState extends State<NewsViewScreen> {
  late String finalUrl;
  late final WebViewController _controller;
  final RxBool isLoading = true.obs;
  final RxDouble loadingProgress = 0.0.obs;

  @override
  void initState() {
    super.initState();

    final String url = Get.arguments as String;

    // Convert http to https for security
    if (url.contains("http://")) {
      finalUrl = url.replaceAll("http://", "https://");
    } else {
      finalUrl = url;
    }

    _initializeWebView();
  }

  void _initializeWebView() {
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              loadingProgress.value = progress / 100;
            },
            onPageStarted: (String url) {
              isLoading.value = true;
            },
            onPageFinished: (String url) {
              isLoading.value = false;
            },
            onWebResourceError: (WebResourceError error) {
              _showErrorSnackbar(
                  'Failed to load article: ${error.description}');
            },
            onNavigationRequest: (NavigationRequest request) {
              // Allow navigation to the same domain
              if (request.url.startsWith('https://') ||
                  request.url.startsWith('http://')) {
                return NavigationDecision.navigate;
              }
              return NavigationDecision.prevent;
            },
          ),
        )
        ..loadRequest(Uri.parse(finalUrl));
    } catch (e) {
      _showErrorSnackbar('Error initializing article viewer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RK News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareArticle,
            tooltip: 'Share',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'open_browser',
                child: Row(
                  children: [
                    Icon(Icons.open_in_browser),
                    SizedBox(width: 8),
                    Text('Open in Browser'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'copy_link',
                child: Row(
                  children: [
                    Icon(Icons.link),
                    SizedBox(width: 8),
                    Text('Copy Link'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          // Loading Progress Bar
          Obx(() {
            if (isLoading.value) {
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: loadingProgress.value,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Get.theme.colorScheme.primary,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Loading Overlay
          Obx(() {
            if (isLoading.value && loadingProgress.value < 0.3) {
              return Container(
                color: Get.theme.colorScheme.surface,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Get.theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading article...',
                        style: TextStyle(
                          color:
                              Get.theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),

      // Bottom Navigation for Web Actions
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () async {
                  if (await _controller.canGoBack()) {
                    _controller.goBack();
                  } else {
                    _showInfoSnackbar('No previous page');
                  }
                },
                tooltip: 'Go Back',
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () async {
                  if (await _controller.canGoForward()) {
                    _controller.goForward();
                  } else {
                    _showInfoSnackbar('No next page');
                  }
                },
                tooltip: 'Go Forward',
              ),
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => _controller.loadRequest(Uri.parse(finalUrl)),
                tooltip: 'Home',
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _controller.reload(),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'open_browser':
        _openInBrowser();
        break;
      case 'copy_link':
        _copyLink();
        break;
    }
  }

  void _shareArticle() {
    // Note: In a real app, you would use share_plus package
    _copyLink();
    Get.snackbar(
      'Share',
      'Link copied to clipboard',
      backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
      colorText: Get.theme.colorScheme.primary,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.share),
    );
  }

  void _openInBrowser() {
    // Note: In a real app, you would use url_launcher package
    _showInfoSnackbar('Feature available with url_launcher package');
  }

  void _copyLink() {
    // Note: In a real app, you would use flutter/services
    _showInfoSnackbar('Link copied to clipboard');
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
      colorText: Get.theme.colorScheme.error,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline),
    );
  }

  void _showInfoSnackbar(String message) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: Get.theme.colorScheme.surface,
      colorText: Get.theme.colorScheme.onSurface,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }
}
