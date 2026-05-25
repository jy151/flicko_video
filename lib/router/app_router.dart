import 'package:go_router/go_router.dart';
import 'package:flicko_video/page/tabs/view.dart';
import 'package:flicko_video/page/setting/view.dart';
import 'package:flicko_video/page/tabs/me/view.dart';
import 'package:flicko_video/page/tabs/home/view.dart';
import 'package:flicko_video/page/auth/login/view.dart';
import 'package:flicko_video/page/tabs/effects/view.dart';
import 'package:flicko_video/page/tabs/discover/view.dart';
import 'package:flicko_video/page/effects_create/view.dart';
import 'package:flicko_video/page/member/view.dart';
import 'package:flicko_video/page/recharge/view.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return TabView(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) {
            return NoTransitionPage(child: HomeView());
          },
          routes: const [],
        ),
        GoRoute(
          path: '/effects',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: EffectsView());
          },
        ),
        GoRoute(
          path: '/discover',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: DiscoverView());
          },
        ),
        GoRoute(
          path: '/me',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: MeView());
          },
        ),
      ],
    ),
    GoRoute(path: '/setting', builder: (context, state) => SettingView()),
    GoRoute(path: '/login', builder: (context, state) => LoginView()),
    GoRoute(
      path: '/effects_create',
      builder: (context, state) => const EffectsCreateView(),
    ),
    GoRoute(
      path: '/member',
      builder: (context, state) => const MemberView(),
    ),
    GoRoute(
      path: '/recharge',
      builder: (context, state) => const RechargeView(),
    ),
  ],
);
