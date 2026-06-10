import 'package:flicko_video/app_controller.dart';
import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'state.dart';

class LoginResult {
  const LoginResult._({required this.success, this.errorMessage});

  const LoginResult.success() : this._(success: true);

  const LoginResult.failure(String message)
    : this._(success: false, errorMessage: message);

  final bool success;
  final String? errorMessage;
}

class LoginController extends StateNotifier<LoginState> {
  LoginController(this._ref) : super(const LoginState());

  final Ref _ref;

  static const _webClientId =
      '667306979952-1qvcj0qud2v4pmo0a525gtubm7vo013l.apps.googleusercontent.com';

  static const _googleSource = 'google';
  static const _appleSource = 'apple';
  Future<void>? _googleInitializeRequest;

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
    await signInWithPassword();
  }

  Future<LoginResult> signInWithPassword() async {
    final account = state.email.trim();
    final password = state.password;

    final validationMessage = _validateAccountPassword(
      account: account,
      password: password,
    );
    if (validationMessage != null) {
      return LoginResult.failure(validationMessage);
    }

    state = state.copyWith(isLoading: true);
    try {
      final loggedIn = await AuthBox.login(
        source: 'account',
        account: account,
        password: password,
      );

      if (!loggedIn) {
        return const LoginResult.failure('账号或密码错误，请检查后重试');
      }

      await _refreshAiModelConfig();
      return const LoginResult.success();
    } catch (error) {
      return LoginResult.failure('账号密码登录失败：$error');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  String? _validateAccountPassword({
    required String account,
    required String password,
  }) {
    if (account.isEmpty) {
      return '请输入邮箱地址';
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(account)) {
      return '请输入有效的邮箱地址';
    }

    if (password.isEmpty) {
      return '请输入密码';
    }

    if (password.length < 6) {
      return '密码至少需要 6 位';
    }

    if (password.length > 64) {
      return '密码不能超过 64 位';
    }

    return null;
  }

  Future<LoginResult> signInWithGoogle() async {
    if (!_isGoogleSignInPlatformSupported) {
      return const LoginResult.failure('Google 登录仅支持 iOS 和 Android');
    }

    state = state.copyWith(isLoading: true);
    try {
      final googleSignIn = GoogleSignIn.instance;
      _googleInitializeRequest ??= googleSignIn.initialize(
        serverClientId: _webClientId,
      );
      await _googleInitializeRequest;

      if (!googleSignIn.supportsAuthenticate()) {
        return const LoginResult.failure('当前平台不支持 Google 授权');
      }

      final account = await googleSignIn.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        return const LoginResult.failure('Google 授权成功，但没有返回 idToken');
      }

      final loggedIn = await AuthBox.login(
        source: _googleSource,
        accessToken: idToken,
      );
      if (!loggedIn) {
        return const LoginResult.failure('Google 授权成功，但服务端登录失败');
      }

      await _refreshAiModelConfig();
      return const LoginResult.success();
    } on GoogleSignInException catch (error) {
      return LoginResult.failure(_formatGoogleSignInError(error));
    } catch (error) {
      return LoginResult.failure('Google 登录失败：$error');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  String _formatGoogleSignInError(GoogleSignInException error) {
    if (defaultTargetPlatform == TargetPlatform.android &&
        _isNoCredentialError(error)) {
      return '未找到可用的 Google 凭据。请确认设备已登录 Google 账号、Google Play 服务可用；如果仍失败，请检查 Google Console 中 Android OAuth 的包名/SHA-1，以及 Web Client ID 配置。';
    }

    final reason = switch (error.code) {
      GoogleSignInExceptionCode.canceled => '用户取消了 Google 授权',
      GoogleSignInExceptionCode.interrupted => 'Google 授权被中断',
      GoogleSignInExceptionCode.clientConfigurationError => 'Google 客户端配置错误',
      GoogleSignInExceptionCode.providerConfigurationError => 'Google 授权服务配置错误',
      GoogleSignInExceptionCode.uiUnavailable => '无法显示 Google 授权界面',
      GoogleSignInExceptionCode.userMismatch => 'Google 授权用户不匹配',
      GoogleSignInExceptionCode.unknownError => 'Google 授权失败',
    };

    final details = [
      error.description,
      if (error.details != null) error.details.toString(),
      if (defaultTargetPlatform == TargetPlatform.android)
        'Web Client ID: $_webClientId',
    ].where((value) => value != null && value.isNotEmpty).join(' - ');

    if (details.isEmpty) {
      return reason;
    }
    return '$reason：$details';
  }

  bool _isNoCredentialError(GoogleSignInException error) {
    final message = [
      error.description,
      if (error.details != null) error.details.toString(),
    ].whereType<String>().join(' ').toLowerCase();

    return message.contains('no credential');
  }

  bool get _isGoogleSignInPlatformSupported {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  Future<LoginResult> signInWithApple() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return const LoginResult.failure('Apple 登录仅支持 iOS');
    }

    state = state.copyWith(isLoading: true);
    try {
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        return const LoginResult.failure(
          '当前设备不支持 Apple 登录，请确认系统版本为 iOS 13 或更高',
        );
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final accessToken = credential.identityToken?.isNotEmpty == true
          ? credential.identityToken
          : credential.authorizationCode;
      if (accessToken == null || accessToken.isEmpty) {
        return const LoginResult.failure(
          'Apple 授权成功，但没有返回 identityToken 或 authorizationCode',
        );
      }

      final loggedIn = await AuthBox.login(
        source: _appleSource,
        accessToken: accessToken,
      );
      if (!loggedIn) {
        return const LoginResult.failure('Apple 授权成功，但服务端登录失败');
      }

      await _refreshAiModelConfig();
      return const LoginResult.success();
    } on SignInWithAppleAuthorizationException catch (error) {
      return LoginResult.failure(_formatAppleAuthorizationError(error));
    } on SignInWithAppleNotSupportedException catch (error) {
      return LoginResult.failure('当前设备不支持 Apple 登录：${error.message}');
    } on SignInWithAppleException catch (error) {
      return LoginResult.failure('Apple 登录失败：$error');
    } catch (error) {
      return LoginResult.failure('Apple 登录失败：$error');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  String _formatAppleAuthorizationError(
    SignInWithAppleAuthorizationException error,
  ) {
    final reason = switch (error.code) {
      AuthorizationErrorCode.canceled => '用户取消了 Apple 授权',
      AuthorizationErrorCode.failed => 'Apple 授权失败',
      AuthorizationErrorCode.invalidResponse => 'Apple 授权返回无效响应',
      AuthorizationErrorCode.notHandled => 'Apple 授权请求未被处理',
      AuthorizationErrorCode.notInteractive => 'Apple 授权无法交互',
      AuthorizationErrorCode.unknown => 'Apple 授权发生未知错误',
      AuthorizationErrorCode.credentialExport => 'Apple 凭据导出失败',
      AuthorizationErrorCode.credentialImport => 'Apple 凭据导入失败',
      AuthorizationErrorCode.matchedExcludedCredential => 'Apple 凭据不符合要求',
    };

    if (error.message.isEmpty) {
      return reason;
    }
    return '$reason：${error.message}';
  }

  Future<void> _refreshAiModelConfig() async {
    await _ref.read(appControllerProvider.notifier).refreshAiModelConfig();
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
      return LoginController(ref);
    });
