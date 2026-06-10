import 'state.dart';
import 'controller.dart';
import 'package:flutter/material.dart';
import 'package:flicko_video/core/legal_urls.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/gen/assets.gen.dart';
import 'package:flicko_video/page/web_content/view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              _buildLogo(),
              const SizedBox(height: 24),
              _buildTryForFreeText(l10n),
              const SizedBox(height: 32),
              _buildEmailField(controller, l10n),
              const SizedBox(height: 16),
              _buildPasswordField(context, state, controller, l10n),
              const SizedBox(height: 24),
              _buildSignInButton(context, state, controller, l10n),
              const SizedBox(height: 16),
              _buildGoogleSignInButton(context, state, controller, l10n),
              const SizedBox(height: 12),
              _buildAppleSignInButton(context, state, controller, l10n),
              const SizedBox(height: 20),
              _buildTermsCheckbox(context, state, controller, l10n),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        image: DecorationImage(image: Assets.icon.appLogo.provider()),
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildTryForFreeText(AppLocalizations l10n) {
    return Text(
      "Flicko Video",
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
    );
  }

  Widget _buildEmailField(LoginController controller, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: controller.setEmail,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          hintText: l10n.emailAddress,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    LoginState state,
    LoginController controller,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: controller.setPassword,
        obscureText: state.obscurePassword,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _onSignIn(context, state, controller, l10n),
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          hintText: l10n.password,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              state.obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[500],
            ),
            onPressed: controller.toggleObscurePassword,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(
    BuildContext context,
    LoginState state,
    LoginController controller,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: state.isLoading
            ? null
            : () => _onSignIn(context, state, controller, l10n),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 0,
        ),
        child: state.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                l10n.signIn,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(
    BuildContext context,
    LoginState state,
    LoginController controller,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: state.isLoading
            ? null
            : () => _onGoogleSignIn(context, state, controller, l10n),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          side: BorderSide.none,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.images.guge.path, width: 24, height: 24),
            const SizedBox(width: 12),
            Text(
              l10n.signInWithGoogle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(
    BuildContext context,
    LoginState state,
    LoginController controller,
    AppLocalizations l10n,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: state.agreedToTerms,
            onChanged: (value) => controller.setAgreedToTerms(value ?? false),
            shape: const CircleBorder(),
            side: const BorderSide(color: Colors.white54, width: 1.5),
            activeColor: const Color(0xFF6C63FF),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              children: [
                TextSpan(text: l10n.agreeToThe),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _openWebContent(
                      context,
                      title: l10n.privacyPolicy,
                      url: privacyPolicyUrl,
                    ),
                    child: Text(
                      l10n.privacyPolicy,
                      style: const TextStyle(
                        color: Color(0xFF4f6dd9),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                TextSpan(text: l10n.and),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _openWebContent(
                      context,
                      title: l10n.termsOfService,
                      url: termsOfServiceUrl,
                    ),
                    child: Text(
                      l10n.termsOfService,
                      style: const TextStyle(
                        color: Color(0xFF4f6dd9),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openWebContent(
    BuildContext context, {
    required String title,
    required String url,
  }) {
    context.push(
      '/web_content',
      extra: WebContentArgs(title: title, url: url),
    );
  }

  Future<void> _onSignIn(
    BuildContext context,
    LoginState state,
    LoginController controller,
    AppLocalizations l10n,
  ) async {
    final agreed = await _ensureTermsAgreed(context, state, controller, l10n);
    if (!agreed || !context.mounted) {
      return;
    }

    try {
      final result = await controller.signInWithPassword();
      if (!context.mounted) {
        return;
      }

      if (result.success) {
        Navigator.of(context).maybePop();
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text(result.errorMessage ?? l10n.loadFailed),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text('账号密码登录失败：$error'),
        ),
      );
    }
  }

  Widget _buildAppleSignInButton(
    BuildContext context,
    LoginState state,
    LoginController controller,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: state.isLoading
            ? null
            : () => _onAppleSignIn(context, state, controller, l10n),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.apple, size: 24, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              l10n.signInWithApple,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onGoogleSignIn(
    BuildContext context,
    LoginState state,
    LoginController controller,
    AppLocalizations l10n,
  ) async {
    final agreed = await _ensureTermsAgreed(context, state, controller, l10n);
    if (!agreed || !context.mounted) {
      return;
    }

    try {
      final result = await controller.signInWithGoogle();
      if (!context.mounted) {
        return;
      }

      if (result.success) {
        Navigator.of(context).maybePop();
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text(result.errorMessage ?? l10n.loadFailed),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text('Google 登录失败：$error'),
        ),
      );
    }
  }

  Future<void> _onAppleSignIn(
    BuildContext context,
    LoginState state,
    LoginController controller,
    AppLocalizations l10n,
  ) async {
    final agreed = await _ensureTermsAgreed(context, state, controller, l10n);
    if (!agreed || !context.mounted) {
      return;
    }

    try {
      final result = await controller.signInWithApple();
      if (!context.mounted) {
        return;
      }

      if (result.success) {
        Navigator.of(context).maybePop();
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text(result.errorMessage ?? l10n.loadFailed),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text('Apple 登录失败：$error'),
        ),
      );
    }
  }

  Future<bool> _ensureTermsAgreed(
    BuildContext context,
    LoginState state,
    LoginController controller,
    AppLocalizations l10n,
  ) async {
    if (state.agreedToTerms) {
      return true;
    }

    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.pleaseAgreeToTerms,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            l10n.termsConsentContent,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                l10n.disagree,
                style: const TextStyle(color: Colors.white60),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                l10n.agree,
                style: const TextStyle(
                  color: Color(0xFF6C63FF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (accepted != true) {
      return false;
    }

    controller.setAgreedToTerms(true);
    return true;
  }
}
