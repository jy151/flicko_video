import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalPaymentLaunchView extends StatefulWidget {
  const ExternalPaymentLaunchView({super.key, required this.url});

  final String url;

  @override
  State<ExternalPaymentLaunchView> createState() =>
      _ExternalPaymentLaunchViewState();
}

class _ExternalPaymentLaunchViewState extends State<ExternalPaymentLaunchView> {
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _openExternalBrowser());
  }

  Future<void> _openExternalBrowser() async {
    if (!mounted) {
      return;
    }
    setState(() => _failed = false);

    final uri = Uri.tryParse(widget.url);
    if (uri == null) {
      _markFailed();
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) {
      return;
    }
    if (!launched) {
      _markFailed();
      return;
    }

    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  void _markFailed() {
    if (!mounted) {
      return;
    }
    setState(() => _failed = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_failed)
                  const Icon(
                    Icons.error_outline,
                    color: Color(0xFFFF4D6D),
                    size: 42,
                  )
                else
                  const SizedBox(
                    width: 34,
                    height: 34,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                const SizedBox(height: 18),
                Text(
                  _failed ? 'Unable to open browser' : 'Opening browser...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _failed
                      ? 'Please try again or return to the home page.'
                      : widget.url,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF9A9AAF),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                if (_failed) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _openExternalBrowser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Retry'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Back Home'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
