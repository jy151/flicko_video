import 'package:flicko_video/app_controller.dart';
import 'package:flicko_video/core/legal_urls.dart';
import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flicko_video/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DeleteAccountView extends ConsumerStatefulWidget {
  const DeleteAccountView({super.key});

  @override
  ConsumerState<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends ConsumerState<DeleteAccountView> {
  late final WebViewController _controller;
  var _progress = 0;
  var _hasError = false;
  var _hasFinishedLoading = false;
  var _isDeleting = false;

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
              _hasFinishedLoading = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) {
              return;
            }
            setState(() {
              _progress = 100;
              _hasFinishedLoading = true;
            });
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == false || !mounted) {
              return;
            }
            setState(() {
              _hasError = true;
              _hasFinishedLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(deleteAccountAgreementUrl));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l10n),
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
                  if (_hasError) _buildErrorView(l10n),
                ],
              ),
            ),
            _buildActionBar(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 4),
          IconButton(
            onPressed: _isDeleting ? null : () => context.pop(),
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          ),
          Expanded(
            child: Text(
              l10n.deleteAccount,
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
            onPressed: _isDeleting ? null : () => _controller.reload(),
            icon: const Icon(Icons.refresh, color: Colors.white70, size: 22),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildActionBar(BuildContext context, AppLocalizations l10n) {
    final canDelete = _hasFinishedLoading && !_hasError && !_isDeleting;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.deleteAccountReadAgreementHint,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: canDelete ? () => _confirmDelete(context, l10n) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4D5E),
                disabledBackgroundColor: const Color(0xFF3A3040),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      l10n.confirmDeleteAccount,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(AppLocalizations l10n) {
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
              Text(
                l10n.deleteAccountAgreementLoadFailed,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _controller.reload(),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          title: Text(
            l10n.deleteAccountConfirmTitle,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            l10n.deleteAccountConfirmContent,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                l10n.confirmDeleteAccount,
                style: const TextStyle(color: Color(0xFFFF6B6B)),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await _deleteAccount(l10n);
    }
  }

  Future<void> _deleteAccount(AppLocalizations l10n) async {
    setState(() => _isDeleting = true);
    try {
      final loggedInAsGuest = await AuthBox.deleteAccountAndLoginGuest();
      if (loggedInAsGuest) {
        await ref.read(appControllerProvider.notifier).refreshAiModelConfig();
      }
      if (!mounted) {
        return;
      }
      _showMessage(
        loggedInAsGuest ? l10n.deleteAccountSuccess : l10n.deleteAccountFailed,
      );
      if (loggedInAsGuest) {
        context.go('/me');
      }
    } catch (_) {
      if (mounted) {
        _showMessage(l10n.deleteAccountFailed);
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A1A2E),
        content: Text(message),
      ),
    );
  }
}
