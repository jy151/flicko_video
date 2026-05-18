import 'package:flicko_video/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppView extends ConsumerWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'FlickoVideo',
      routerConfig: appRouter,
    );
  }
}
