import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

void openMemberPage(BuildContext context) {
  final path = UserBox.shouldUseWebPay ? '/web_member' : '/member';
  _openPaywallPath(context, path);
}

void openRechargePage(BuildContext context) {
  final path = UserBox.shouldUseWebPay ? '/web_recharge' : '/recharge';
  _openPaywallPath(context, path);
}

void _openPaywallPath(BuildContext context, String path) {
  if (_isExternalPaymentPath(path) && isCurrentGuestUser()) {
    context.push('/login');
    return;
  }

  context.push(path);
}

bool isCurrentGuestUser() {
  final source = _firstNonEmpty([
    UserBox.member?.source,
    UserBox.balance?.source,
    AuthBox.source,
  ]);
  return source.toLowerCase() == 'guest';
}

bool _isExternalPaymentPath(String path) {
  return path == '/web_pay' || path == '/web_member' || path == '/web_recharge';
}

String _firstNonEmpty(Iterable<String?> values) {
  for (final value in values) {
    final text = value?.trim();
    if (text != null && text.isNotEmpty) {
      return text;
    }
  }
  return '';
}
