import 'package:flutter_riverpod/legacy.dart';

import 'state.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController() : super(const LoginState());

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void setAgreedToTerms(bool agreed) {
    state = state.copyWith(agreedToTerms: agreed);
  }

  Future<void> signIn() async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO: Implement sign in logic
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO: Implement Google sign in logic
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO: Implement Apple sign in logic
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController();
});
