import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/app_controller.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _OrderResultStatus { checking, success, failure }

class OrderResultView extends ConsumerStatefulWidget {
  const OrderResultView({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderResultView> createState() => _OrderResultViewState();
}

class _OrderResultViewState extends ConsumerState<OrderResultView> {
  _OrderResultStatus _status = _OrderResultStatus.checking;
  String? _message;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOrder());
  }

  Future<void> _checkOrder() async {
    final orderId = widget.orderId.trim();
    if (orderId.isEmpty) {
      if (mounted) {
        context.go('/home');
      }
      return;
    }

    setState(() {
      _status = _OrderResultStatus.checking;
      _message = null;
    });

    try {
      try {
        await ref.read(appControllerProvider.notifier).init();
      } catch (_) {
        // The order check below is the source of truth for this screen.
      }

      final res = await Api.checkAigcModelOrder(orderId);
      final isSuccess = res.code == 1 || res.code == 200;

      if (isSuccess) {
        try {
          await UserBox.syncBalance();
        } catch (_) {
          // Keep the success result visible even if cache refresh fails.
        }
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _status = isSuccess
            ? _OrderResultStatus.success
            : _OrderResultStatus.failure;
        _message = res.message.isEmpty ? null : res.message;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = _OrderResultStatus.failure;
        _message = '$error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isChecking = _status == _OrderResultStatus.checking;
    final isSuccess = _status == _OrderResultStatus.success;
    final primaryColor = isSuccess
        ? const Color(0xFF22C55E)
        : const Color(0xFFFF4D6D);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l10n),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatusMark(isChecking, isSuccess, primaryColor),
                      const SizedBox(height: 28),
                      Text(
                        _titleFor(l10n),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _descriptionFor(l10n),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFC8C8D4),
                          fontSize: 15,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildOrderId(l10n),
                    ],
                  ),
                ),
              ),
            ),
            _buildActions(context, l10n, isChecking, isSuccess),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.close, color: Colors.white, size: 26),
          ),
          Expanded(
            child: Text(
              l10n.orderResultTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStatusMark(bool isChecking, bool isSuccess, Color primaryColor) {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.13),
        shape: BoxShape.circle,
        border: Border.all(color: primaryColor.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.25),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Center(
        child: isChecking
            ? const SizedBox(
                width: 38,
                height: 38,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xFF6C63FF),
                ),
              )
            : Icon(
                isSuccess ? Icons.check_rounded : Icons.close_rounded,
                color: primaryColor,
                size: 64,
              ),
      ),
    );
  }

  Widget _buildOrderId(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF171728),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A4A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.orderId,
            style: const TextStyle(color: Color(0xFF7C7C91), fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            widget.orderId,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    AppLocalizations l10n,
    bool isChecking,
    bool isSuccess,
  ) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isChecking ? null : () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF3A3A4A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isSuccess ? l10n.startCreating : l10n.backHome,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (!isChecking && !isSuccess) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _checkOrder,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF4F4F70)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    l10n.retry,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _titleFor(AppLocalizations l10n) {
    return switch (_status) {
      _OrderResultStatus.checking => l10n.paymentChecking,
      _OrderResultStatus.success => l10n.paymentSuccess,
      _OrderResultStatus.failure => l10n.paymentFailed,
    };
  }

  String _descriptionFor(AppLocalizations l10n) {
    final message = _message;
    if (_status == _OrderResultStatus.failure &&
        message != null &&
        message.isNotEmpty) {
      return message;
    }

    return switch (_status) {
      _OrderResultStatus.checking => l10n.paymentCheckingDesc,
      _OrderResultStatus.success => l10n.paymentSuccessDesc,
      _OrderResultStatus.failure => l10n.paymentFailedDesc,
    };
  }
}
