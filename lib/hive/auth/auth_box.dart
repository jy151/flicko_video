import 'package:flicko_video/api/api.dart';
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
    await box.put(_memberIdKey, auth.memberId);
    await box.put(_source, source);
    return true;
  }

  static Future<void> logout() async {
    await Api.logout();
    await box.clear();
  }

  static Future<void> clear() async {
    await box.clear();
  }

  static bool get isLoggedIn => token.isNotEmpty;

  static String get token => box.get(_tokenKey) as String? ?? '';
  static String get memberId => box.get(_memberIdKey) as String? ?? '';
  static String get source => box.get(_source) as String? ?? '';

  static Future<void> init() async {
    await Hive.openBox<dynamic>(name);
  }
}
