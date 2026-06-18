import 'package:flicko_video/app_controller.dart';
import 'package:flicko_video/hive/app/app_box.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/i18n/locale_controller.dart';
import 'package:flicko_video/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AppView extends ConsumerStatefulWidget {
  const AppView({super.key});

  @override
  ConsumerState<AppView> createState() => _AppViewState();
}

class _AppViewState extends ConsumerState<AppView> {
  @override
  void initState() {
    super.initState();
    if (!AppBox.isFirstLaunch) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(appControllerProvider.notifier).init();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeState = ref.watch(appLocaleControllerProvider);
    return RefreshConfiguration(
      headerBuilder: () =>
          WaterDropHeader(), // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
      footerBuilder: () =>
          ClassicFooter(), // Configure default bottom indicator
      headerTriggerDistance: 80.0, // header trigger refresh trigger distance
      springDescription: SpringDescription(
        stiffness: 170,
        damping: 16,
        mass: 1.9,
      ), // custom spring back animate,the props meaning see the flutter api
      maxOverScrollExtent:
          100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
      maxUnderScrollExtent: 0, // Maximum dragging range at the bottom
      enableScrollWhenRefreshCompleted:
          true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
      enableLoadingWhenFailed:
          true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
      hideFooterWhenNotFull:
          false, // Disable pull-up to load more functionality when Viewport is less than one screen
      enableBallisticLoad: true, // trigger load more by BallisticScrollActivity
      child: MaterialApp.router(
        title: 'FlickoVideo',
        routerConfig: appRouter,
        builder: EasyLoading.init(),
        locale: localeState.locale,
        debugShowCheckedModeBanner: false,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
