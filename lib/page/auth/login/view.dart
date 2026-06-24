import 'state.dart';
import 'controller.dart';
import 'package:flutter/material.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/gen/assets.gen.dart';
import 'package:flicko_video/widgets/terms_agreement_checkbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              const SizedBox(height: 18),
              TermsAgreementCheckbox(
                agreed: state.agreedToTerms,
                onChanged: controller.setAgreedToTerms,
              ),
              const SizedBox(height: 8),
              _buildTermsRequiredHint(state, l10n),
              const SizedBox(height: 16),
              _buildSignInButton(context, state, controller, l10n),
              const SizedBox(height: 16),
              _buildGoogleSignInButton(context, state, controller, l10n),
              const SizedBox(height: 12),
              _buildAppleSignInButton(context, state, controller, l10n),
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
      "Aivaro Video",
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
          backgroundColor: state.agreedToTerms
              ? const Color(0xFF2196F3)
              : const Color(0xFF315F8F),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF315F8F),
          disabledForegroundColor: Colors.white70,
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

  Widget _buildTermsRequiredHint(LoginState state, AppLocalizations l10n) {
    if (state.agreedToTerms) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        l10n.readAndAgreeToTerms,
        style: const TextStyle(color: Color(0xFFFFC56D), fontSize: 12),
      ),
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
          disabledBackgroundColor: const Color(0xFF1A1A1A),
          disabledForegroundColor: Colors.white54,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 1.4),
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A1A2E),
        content: Text(l10n.readAndAgreeToTerms),
      ),
    );
    return false;
  }
}
