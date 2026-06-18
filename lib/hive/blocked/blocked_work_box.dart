import 'package:hive/hive.dart';

class BlockedWorkBox {
  static const String name = 'blocked_work';
  static const String _workIdsKey = 'workIds';

  static Box<dynamic> get box => Hive.box<dynamic>(name);

  static Future<void> init() async {
    await Hive.openBox<dynamic>(name);
  }

  static Set<int> get workIds {
    final value = box.get(_workIdsKey);
    if (value is List) {
      return value
          .map((item) => int.tryParse(item.toString()))
          .whereType<int>()
          .toSet();
    }
    return <int>{};
  }

  static bool contains(int? workId) {
    return workId != null && workIds.contains(workId);
  }

  static Future<void> add(int workId) async {
    final updatedIds = workIds..add(workId);
    await box.put(_workIdsKey, updatedIds.toList(growable: false));
  }
}
