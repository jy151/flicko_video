import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'local_web_asset_server.dart';
import 'web_bridge_handler.dart';

class WebContentArgs {
  const WebContentArgs({
    required this.title,
    this.url,
    this.showAppBar = true,
    this.preferCloseOnBack = false,
    this.localEntry,
  });

  const WebContentArgs.local({
    this.title = '',
    this.url,
    this.showAppBar = true,
    this.preferCloseOnBack = false,
    this.localEntry,
  });

  final String title;
  final String? url;
  final bool showAppBar;
  final bool preferCloseOnBack;
  final String? localEntry;
}

class WebContentView extends StatefulWidget {
  const WebContentView({
    super.key,
    required this.title,
    this.url,
    this.showAppBar = true,
    this.preferCloseOnBack = false,
    this.localEntry,
  });

  final String title;
  final String? url;
  final bool showAppBar;
  final bool preferCloseOnBack;
  final String? localEntry;

  @override
  State<WebContentView> createState() => _WebContentViewState();
}

class _WebContentViewState extends State<WebContentView>
    with WidgetsBindingObserver {
  static final _localServer = LocalWebAssetServer();

  late final WebViewController _controller;
  late final WebBridgeHandler _bridgeHandler;
  var _progress = 0;
  var _hasError = false;
  var _isPreparingLocalServer = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setOnConsoleMessage(_handleConsoleMessage)
      ..addJavaScriptChannel(
        'FlickoWebBridge',
        onMessageReceived: _handleBridgeMessage,
      )
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
            _bridgeHandler.sendSafeArea();
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
      );

    _bridgeHandler = WebBridgeHandler(
      context: context,
      controller: _controller,
    );
    _loadInitialRequest();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshH5AccountInfo();
    }
  }

  Future<void> _handleBridgeMessage(JavaScriptMessage message) async {
    await _bridgeHandler.handleMessage(message);
  }

  Future<void> _refreshH5AccountInfo() async {
    if (!mounted) {
      return;
    }
    await _bridgeHandler.sendAccountInfo();
  }

  void _handleConsoleMessage(JavaScriptConsoleMessage message) {
    debugPrint('[WebView console][${message.level.name}] ${message.message}');
  }

  Future<void> _loadInitialRequest() async {
    final remoteUrl = widget.url?.trim();
    if (remoteUrl != null && remoteUrl.isNotEmpty) {
      await _controller.loadRequest(Uri.parse(remoteUrl));
      return;
    }

    if (!mounted) {
      return;
    }
    setState(() => _isPreparingLocalServer = true);

    try {
      final serverUri = await _localServer.start();
      final localEntry = widget.localEntry?.trim();
      final initialUri = localEntry == null || localEntry.isEmpty
          ? serverUri
          : serverUri.replace(queryParameters: {'entry': localEntry});
      if (!mounted) {
        return;
      }
      setState(() => _isPreparingLocalServer = false);
      await _controller.loadRequest(initialUri);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isPreparingLocalServer = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _notifyH5Back();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D1A),
        body: SafeArea(
          top: widget.showAppBar,
          child: Column(
            children: [
              if (widget.showAppBar)
                SizedBox(
                  height: 56,
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: _notifyH5Back,
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
                    if (_isPreparingLocalServer) _buildLoadingView(),
                    if (_hasError) _buildErrorView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _notifyH5Back() async {
    final remoteUrl = widget.url?.trim();
    if (widget.preferCloseOnBack ||
        (remoteUrl != null && remoteUrl.isNotEmpty)) {
      _closePage();
      return;
    }

    try {
      await _controller.runJavaScript(
        'if (window.gotoBack) { window.gotoBack(); }',
      );
    } catch (_) {
      if (mounted && context.canPop()) {
        context.pop();
      }
    }
  }

  void _closePage() {
    if (mounted && context.canPop()) {
      context.pop();
    }
  }

  Widget _buildLoadingView() {
    return const ColoredBox(
      color: Color(0xFF0D0D1A),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF6C63FF),
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
