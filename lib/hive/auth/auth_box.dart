import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/member_model.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:hive/hive.dart';

class AuthBox {
  static const String name = 'auth';
  static const String _tokenKey = 'token';
  static const String _memberIdKey = 'memberId';
  static const String _source = "user_source";

  static Box<dynamic> get box => Hive.box<dynamic>(name);

  static Future<bool> login({
    required String source,
    String? accessToken,
    String? account,
    String? password,
    int? gender,
    String? inviterCode,
    String? inviterChannel,
    String? inviterApp,
  }) async {
    final auth = await Api.activation(
      source: source,
      accessToken: accessToken,
      account: account,
      password: password,
      gender: gender,
      inviterCode: inviterCode,
      inviterChannel: inviterChannel,
      inviterApp: inviterApp,
    );
    if (auth == null) {
      return false;
    }

    await box.put(_tokenKey, auth.token);
    await box.put(_memberIdKey, auth.memberId?.toString());
    await box.put(_source, source);
    await _syncUserBoxAfterLogin(
      auth.memberId?.toString(),
      auth.name,
      auth.portrait,
    );
    return true;
  }

  static Future<void> logout() async {
    try {
      await Api.logout();
    } finally {
      await box.clear();
      await UserBox.clear();
    }
  }

  static Future<bool> logoutAndLoginGuest() async {
    await logout();
    return login(source: 'guest');
  }

  static Future<bool> deleteAccountAndLoginGuest() async {
    final res = await Api.deleteAccount();
    if (!res.isSuccess) {
      return false;
    }

    await clear();
    return login(source: 'guest');
  }

  static Future<void> clear() async {
    await box.clear();
    await UserBox.clear();
  }

  static bool get isLoggedIn => token.isNotEmpty;

  static String get token => box.get(_tokenKey) as String? ?? '';
  static String get memberId => box.get(_memberIdKey)?.toString() ?? '';
  static String get source => box.get(_source) as String? ?? '';

  static Future<void> init() async {
    await Hive.openBox<dynamic>(name);
  }

  static Future<void> _syncUserBoxAfterLogin(
    String? memberId,
    String? name,
    String? portrait,
  ) async {
    if (memberId != null && memberId.isNotEmpty) {
      await UserBox.saveMember(
        Member(memberId: memberId, name: name, portrait: portrait),
      );
    }

    try {
      await UserBox.syncUserInfo();
    } catch (_) {
      try {
        await UserBox.syncBalance(memberId: memberId);
      } catch (_) {
        // Keep the cached login identity even if follow-up profile requests fail.
      }
    }
  }
}
