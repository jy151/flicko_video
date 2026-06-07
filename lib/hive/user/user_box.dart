import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/member_model.dart';
import 'package:hive/hive.dart';

class UserBox {
  static const String name = 'user';
  static const String _memberKey = 'member';
  static const String _balanceKey = 'balance';

  static Box<dynamic> get box => Hive.box<dynamic>(name);

  static Future<void> init() async {
    await Hive.openBox<dynamic>(name);
  }

  static Member? get member {
    final value = box.get(_memberKey);
    if (value is Map) {
      return Member.fromJson(Map<String, dynamic>.from(value));
    }
    return null;
  }

  static Balance? get balance {
    final value = box.get(_balanceKey);
    if (value is Map) {
      return Balance.fromJson(Map<String, dynamic>.from(value));
    }
    return null;
  }

  static int get credit => balance?.credit ?? 0;

  static Future<Member?> syncUserInfo() async {
    final member = await Api.getMember();
    if (member == null) {
      return null;
    }

    await saveMember(member);
    return member;
  }

  static Future<Balance?> syncBalance({String? memberId}) async {
    final cachedBalance = balance;
    final id = memberId ?? member?.memberId ?? cachedBalance?.memberId;
    if (id == null) {
      return null;
    }

    final latestBalance = await Api.getBalance(int.parse(id.toString()));
    if (latestBalance == null) {
      return null;
    }

    await saveBalance(latestBalance);
    return latestBalance;
  }

  static Future<void> saveMember(Member member) async {
    await box.put(_memberKey, member.toJson());
  }

  static Future<void> saveBalance(Balance balance) async {
    await box.put(_balanceKey, balance.toJson());
  }

  static Future<void> clear() async {
    await box.clear();
  }
}
