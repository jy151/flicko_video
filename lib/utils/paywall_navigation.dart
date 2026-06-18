import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

void openMemberPage(BuildContext context) {
  context.push(UserBox.shouldUseWebPay ? '/web_member' : '/member');
}

void openRechargePage(BuildContext context) {
  context.push(UserBox.shouldUseWebPay ? '/web_recharge' : '/recharge');
}
