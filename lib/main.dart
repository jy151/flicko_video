import 'package:flicko_video/hive/app/app_box.dart';
import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flicko_video/hive/blocked/blocked_work_box.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await initBoxes();
  runApp(const ProviderScope(child: AppView()));
}

Future<void> initBoxes() async {
  await AppBox.init();
  await AuthBox.init();
  await UserBox.init();
  await BlockedWorkBox.init();
}
