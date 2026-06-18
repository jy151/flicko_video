import 'dart:convert';

import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/page/web_content/view.dart';
import 'package:flicko_video/utils/member_access.dart';
import 'package:flicko_video/widgets/app_top_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebBridgeHandler {
  WebBridgeHandler({required this.context, required this.controller});

  final BuildContext context;
  final WebViewController controller;

  Future<void> handleMessage(JavaScriptMessage message) async {
    final decoded = _decodeMessage(message.message);
    if (decoded == null) {
      return;
    }

    final method = decoded['method'] as String?;
    final payload = decoded['payload'];
    if (method == null) {
      return;
    }

    switch (method) {
      case 'setH5Status':
        await sendSafeArea();
      case 'setStatusBarFontColor':
      case 'setStatusBarColor':
        break;
      case 'showToast':
        _showToast(_stringPayload(payload));
      case 'getUserAgent':
        await _sendUserAgent();
      case 'getAccountInfo':
        await sendAccountInfo();
      case 'logEvent':
        debugPrint('[WebViewBridge] logEvent: $payload');
      case 'closeActivity':
        _closePage();
      case 'openPrivacy':
        _openInAppWeb(_stringPayload(payload));
      case 'showWebview':
        break;
      case 'openWeb':
        await _openExternalWeb(_stringPayload(payload));
      case 'showLogin':
      case 'showLoginDialog':
        await _openLogin();
      case 'requestPay':
      case 'requestSingleSubsPay':
      case 'requestSubsPay':
      case 'requestNewSubsPay':
        debugPrint('[WebViewBridge] $method: $payload');
      case 'h5ScriptSubSuccess':
        await _refreshUserInfo();
      case 'openPersonalAct':
        break;
      default:
        debugPrint('[WebViewBridge] unsupported method: $method');
    }
  }

  Future<void> sendSafeArea() async {
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) {
      return;
    }
    final top = mediaQuery.padding.top;
    final bottom = mediaQuery.padding.bottom;
    await controller.runJavaScript('''
      if (window.setStatusBarHeight) window.setStatusBarHeight($top);
      if (window.setSafeAreaBottom) window.setSafeAreaBottom($bottom);
    ''');
  }

  Map<String, dynamic>? _decodeMessage(String message) {
    try {
      final json = jsonDecode(message);
      if (json is! Map<String, dynamic>) {
        return null;
      }
      return json;
    } catch (_) {
      return null;
    }
  }

  Future<void> _sendUserAgent() async {
    final packageInfo = await PackageInfo.fromPlatform();
    await _callbackToH5('getUserAgentCallback', {
      'platform': defaultTargetPlatform.name,
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
    });
  }

  Future<void> sendAccountInfo() async {
    final member = UserBox.member;
    final balance = UserBox.balance;
    final memberId = member?.memberId ?? balance?.memberId?.toString() ?? '';
    final email = member?.email ?? balance?.email ?? '';

    await _callbackToH5('getAccountInfoCallback', {
      'memberId': memberId,
      'token': AuthBox.token,
      'isVip': isActiveVipMember(member),
      'email': email,
      'source': AuthBox.source == 'guest' || AuthBox.token.isEmpty
          ? 'guest'
          : 'normal',
    });
  }

  Future<void> _callbackToH5(
    String functionName,
    Map<String, dynamic> data,
  ) async {
    final payload = jsonEncode(data);
    await controller.runJavaScript(
      'if (window.$functionName) window.$functionName($payload);',
    );
  }

  String _stringPayload(dynamic payload) {
    if (payload is String) {
      return payload;
    }
    if (payload is List && payload.isNotEmpty) {
      return payload.first?.toString() ?? '';
    }
    return payload?.toString() ?? '';
  }

  void _showToast(String message) {
    if (message.isEmpty || !context.mounted) {
      return;
    }
    showAppTopToast(context, message);
  }

  void _closePage() {
    if (!context.mounted || !context.canPop()) {
      return;
    }
    context.pop();
  }

  Future<void> _openLogin() async {
    if (!context.mounted) {
      return;
    }
    await context.push('/login');
    if (!context.mounted) {
      return;
    }
    try {
      await UserBox.syncUserInfo();
    } catch (_) {
      // Login already updates the cache; this is a best effort fresh sync.
    }
    await sendAccountInfo();
  }

  void _openInAppWeb(String url) {
    if (url.isEmpty || !context.mounted) {
      return;
    }
    context.push(
      '/web_content',
      extra: WebContentArgs(title: '', url: url, preferCloseOnBack: true),
    );
  }

  Future<void> _openExternalWeb(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      _openInAppWeb(url);
    }
  }

  Future<void> _refreshUserInfo() async {
    try {
      await UserBox.syncUserInfo();
    } catch (_) {
      // Best effort refresh after H5 reports a successful subscription.
    }
  }
}
