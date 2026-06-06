import 'package:go_router/go_router.dart';
import 'package:flicko_video/page/discover_detail/state.dart';
import 'package:flicko_video/page/discover_detail/view.dart';
import 'package:flicko_video/page/tabs/view.dart';
import 'package:flicko_video/page/setting/view.dart';
import 'package:flicko_video/page/tabs/me/view.dart';
import 'package:flicko_video/page/tabs/home/view.dart';
import 'package:flicko_video/page/auth/login/view.dart';
import 'package:flicko_video/page/tabs/effects/view.dart';
import 'package:flicko_video/page/tabs/discover/view.dart';
import 'package:flicko_video/page/effects_all/view.dart';
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
      path: '/discover_detail',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is DiscoverDetailArgs) {
          return DiscoverDetailView(work: extra.work);
        }
        return const DiscoverView();
      },
    ),
    GoRoute(
      path: '/effects_create',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is EffectsCreateArgs) {
          return EffectsCreateView(
            templates: extra.templates,
            selectedTemplateId: extra.selectedTemplateId,
          );
        }
        return const EffectsCreateView(templates: []);
      },
    ),
    GoRoute(path: '/member', builder: (context, state) => const MemberView()),
    GoRoute(
      path: '/effects_all',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is EffectsAllArgs) {
          return EffectsAllView(templates: extra.templates);
        }

        final categoryId = int.tryParse(
          state.uri.queryParameters['categoryId'] ?? '',
        );
        return EffectsAllView(selectedCategoryId: categoryId);
      },
    ),
    GoRoute(
      path: '/recharge',
      builder: (context, state) => const RechargeView(),
    ),
  ],
);
