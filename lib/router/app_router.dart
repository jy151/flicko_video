import 'package:go_router/go_router.dart';
import 'package:flicko_video/core/payment_urls.dart';
import 'package:flicko_video/hive/app/app_box.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/page/discover_detail/state.dart';
import 'package:flicko_video/page/discover_detail/view.dart';
import 'package:flicko_video/page/delete_account/view.dart';
import 'package:flicko_video/page/external_payment/view.dart';
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
import 'package:flicko_video/page/order_result/view.dart';
import 'package:flicko_video/page/recharge/view.dart';
import 'package:flicko_video/page/create_result/state.dart';
import 'package:flicko_video/page/create_result/view.dart';
import 'package:flicko_video/page/web_content/view.dart';
import 'package:flicko_video/utils/paywall_navigation.dart';
import 'package:flutter/widgets.dart';

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
      redirect: (context, state) => _redirectWebPay('/web_member'),
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
      redirect: (context, state) => _redirectWebPay('/web_recharge'),
      builder: (context, state) => const RechargeView(),
    ),
    GoRoute(
      path: '/order_result',
      redirect: _redirectOrderResultWithoutOrderId,
      builder: _buildOrderResultView,
    ),
    GoRoute(
      path: '/app/callback',
      redirect: _redirectOrderResultWithoutOrderId,
      builder: _buildOrderResultView,
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
      redirect: _redirectGuestExternalPaymentToLogin,
      builder: (context, state) {
        return ExternalPaymentLaunchView(url: buildIosPayMemberUrl());
      },
    ),
    GoRoute(
      path: '/web_member',
      redirect: _redirectGuestExternalPaymentToLogin,
      builder: (context, state) {
        return ExternalPaymentLaunchView(url: buildIosPayMemberUrl());
      },
    ),
    GoRoute(
      path: '/web_recharge',
      redirect: _redirectGuestExternalPaymentToLogin,
      builder: (context, state) {
        return ExternalPaymentLaunchView(url: buildIosPayRechargeUrl());
      },
    ),
  ],
);

String? _redirectWebPay(String webPayPath) {
  if (!UserBox.shouldUseWebPay) {
    return null;
  }
  return isCurrentGuestUser() ? '/login' : webPayPath;
}

String? _redirectGuestExternalPaymentToLogin(
  BuildContext context,
  GoRouterState state,
) {
  return isCurrentGuestUser() ? '/login' : null;
}

String? _redirectOrderResultWithoutOrderId(
  BuildContext context,
  GoRouterState state,
) {
  return _orderIdFromState(state).isEmpty ? '/home' : null;
}

OrderResultView _buildOrderResultView(
  BuildContext context,
  GoRouterState state,
) {
  return OrderResultView(orderId: _orderIdFromState(state));
}

String _orderIdFromState(GoRouterState state) {
  final orderId =
      state.uri.queryParameters['orderId'] ??
      state.uri.queryParameters['order_id'] ??
      '';
  return orderId.trim();
}
