import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flicko_video/hive/user/user_box.dart';

const iosPayMemberUrl = 'https://flicko.video/iospay/';
const iosPayRechargeUrl = 'https://flicko.video/iospay/points.html';

String buildIosPayMemberUrl() {
  return _appendPaymentUserParams(iosPayMemberUrl);
}

String buildIosPayRechargeUrl() {
  return _appendPaymentUserParams(iosPayRechargeUrl);
}

String _appendPaymentUserParams(String url) {
  final uri = Uri.parse(url);
  final member = UserBox.member;
  final balance = UserBox.balance;
  final memberId = _firstNonEmpty([
    member?.memberId,
    balance?.memberId?.toString(),
    AuthBox.memberId,
  ]);

  return uri
      .replace(
        queryParameters: {
          ...uri.queryParameters,
          'memberId': memberId,
          'token': AuthBox.token,
          'isVip': (member?.isVip == true).toString(),
        },
      )
      .toString();
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
