import 'state.dart';
import 'controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/gen/assets.gen.dart';
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
              _buildPasswordField(state, controller, l10n),
              // const SizedBox(height: 24),
              // _buildSignInButton(context, state, controller, l10n),
              const SizedBox(height: 16),
              _buildGoogleSignInButton(context, state, controller, l10n),
              const SizedBox(height: 12),
              _buildAppleSignInButton(context, state, controller, l10n),
              const SizedBox(height: 20),
              _buildTermsCheckbox(state, controller, l10n),
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
                TextSpan(
                  text: l10n.userAgreement,
                  style: const TextStyle(color: Color(0xFF4f6dd9)),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                TextSpan(text: l10n.and),
                TextSpan(
                  text: l10n.termsOfService,
                  style: const TextStyle(color: Color(0xFF4f6dd9)),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onSignIn(
    BuildContext context,
    LoginState state,
    LoginController controller,
    AppLocalizations l10n,
  ) {
    if (!state.agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text(l10n.pleaseAgreeToTerms),
        ),
      );
      return;
    }
    controller.signIn();
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

  void _onGoogleSignIn(
    BuildContext context,
    LoginState state,
    LoginController controller,
    AppLocalizations l10n,
  ) {
    if (!state.agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text(l10n.pleaseAgreeToTerms),
        ),
      );
      return;
    }
    controller.signInWithGoogle();
  }

  void _onAppleSignIn(
    BuildContext context,
    LoginState state,
    LoginController controller,
    AppLocalizations l10n,
  ) {
    if (!state.agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text(l10n.pleaseAgreeToTerms),
        ),
      );
      return;
    }
    controller.signInWithApple();
  }
}
