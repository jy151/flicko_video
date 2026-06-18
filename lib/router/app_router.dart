import 'package:go_router/go_router.dart';
import 'package:flicko_video/hive/app/app_box.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/page/discover_detail/state.dart';
import 'package:flicko_video/page/discover_detail/view.dart';
import 'package:flicko_video/page/delete_account/view.dart';
import 'package:flicko_video/page/initial/view.dart';
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
import 'package:flicko_video/page/create_result/state.dart';
import 'package:flicko_video/page/create_result/view.dart';
import 'package:flicko_video/page/web_content/view.dart';

final appRouter = GoRouter(
  initialLocation: AppBox.isFirstLaunch ? '/initial' : '/home',
  routes: [
    GoRoute(path: '/initial', builder: (context, state) => const InitialView()),
    ShellRoute(
      builder: (context, state, child) {
        return TabView(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) {
            final extra = state.extra;
            return NoTransitionPage(
              child: HomeView(initialPrompt: extra is String ? extra : null),
            );
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
      path: '/delete_account',
      builder: (context, state) => const DeleteAccountView(),
    ),
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
    GoRoute(
      path: '/member',
      redirect: (context, state) =>
          UserBox.shouldUseWebPay ? '/web_member' : null,
      builder: (context, state) => const MemberView(),
    ),
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
      redirect: (context, state) =>
          UserBox.shouldUseWebPay ? '/web_recharge' : null,
      builder: (context, state) => const RechargeView(),
    ),
    GoRoute(
      path: '/create_result',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is CreateResultArgs) {
          return CreateResultView(args: extra);
        }
        return const CreateResultView();
      },
    ),
    GoRoute(
      path: '/web_content',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is WebContentArgs) {
          return WebContentView(
            title: extra.title,
            url: extra.url,
            showAppBar: extra.showAppBar,
            preferCloseOnBack: extra.preferCloseOnBack,
            localEntry: extra.localEntry,
          );
        }
        return const WebContentView(title: '');
      },
    ),
    GoRoute(
      path: '/web_pay',
      builder: (context, state) {
        return const WebContentView(
          title: '',
          showAppBar: false,
          localEntry: 'member',
        );
      },
    ),
    GoRoute(
      path: '/web_member',
      builder: (context, state) {
        return const WebContentView(
          title: '',
          showAppBar: false,
          localEntry: 'member',
        );
      },
    ),
    GoRoute(
      path: '/web_recharge',
      builder: (context, state) {
        return const WebContentView(
          title: '',
          showAppBar: false,
          localEntry: 'recharge',
        );
      },
    ),
  ],
);
