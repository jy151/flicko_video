import 'package:flicko_video/app_controller.dart';
import 'package:flicko_video/gen/assets.gen.dart';
import 'package:flicko_video/hive/app/app_box.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/widgets/terms_agreement_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InitialView extends ConsumerStatefulWidget {
  const InitialView({super.key});

  @override
  ConsumerState<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends ConsumerState<InitialView> {
  bool _loading = false;
  bool _agreedToTerms = false;

  Future<void> _enterApp() async {
    if (_loading) {
      return;
    }

    if (!_agreedToTerms) {
      _showTermsRequiredMessage();
      return;
    }

    setState(() => _loading = true);

    try {
      await ref.read(appControllerProvider.notifier).init();
      await AppBox.setIsFirstLaunch(false);
      if (mounted) {
        context.go('/home');
      }
    } catch (_) {
      // Keep the welcome page available so the user can try entering again.
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildLogo(),
              const SizedBox(height: 24),
              const Text(
                'Flicko Video',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(flex: 3),
              TermsAgreementCheckbox(
                agreed: _agreedToTerms,
                onChanged: (value) => setState(() => _agreedToTerms = value),
              ),
              const SizedBox(height: 8),
              _buildTermsRequiredHint(),
              const SizedBox(height: 10),
              _buildEnterButton(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF2A2A4A)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.24),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Assets.icon.appLogo.image(fit: BoxFit.cover),
    );
  }

  Widget _buildEnterButton() {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _loading ? null : _enterApp,
        style: ElevatedButton.styleFrom(
          backgroundColor: _agreedToTerms
              ? const Color(0xFF6C63FF)
              : const Color(0xFF504BA6),
          disabledBackgroundColor: const Color(0xFF4D4D68),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
        ),
        child: _loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                l10n.enterApp,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildTermsRequiredHint() {
    if (_agreedToTerms) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        l10n.readAndAgreeToTerms,
        style: const TextStyle(color: Color(0xFFFFC56D), fontSize: 12),
      ),
    );
  }

  void _showTermsRequiredMessage() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A1A2E),
        content: Text(l10n.readAndAgreeToTerms),
      ),
    );
  }
}
