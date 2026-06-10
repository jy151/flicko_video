import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebContentArgs {
  const WebContentArgs({required this.title, required this.url});

  final String title;
  final String url;
}

class WebContentView extends StatefulWidget {
  const WebContentView({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  State<WebContentView> createState() => _WebContentViewState();
}

class _WebContentViewState extends State<WebContentView> {
  late final WebViewController _controller;
  var _progress = 0;
  var _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) {
              return;
            }
            setState(() => _progress = progress);
          },
          onPageStarted: (_) {
            if (!mounted) {
              return;
            }
            setState(() {
              _progress = 0;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) {
              return;
            }
            setState(() => _progress = 100);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == false) {
              return;
            }
            if (!mounted) {
              return;
            }
            setState(() => _hasError = true);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _controller.reload(),
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white70,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            if (_progress < 100)
              LinearProgressIndicator(
                value: _progress <= 0 ? null : _progress / 100,
                minHeight: 2,
                color: const Color(0xFF6C63FF),
                backgroundColor: Colors.white.withValues(alpha: 0.08),
              )
            else
              const SizedBox(height: 2),
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_hasError) _buildErrorView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return ColoredBox(
      color: const Color(0xFF0D0D1A),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.white70, size: 38),
              const SizedBox(height: 12),
              const Text(
                '页面加载失败',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _controller.reload(),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
