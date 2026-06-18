import 'package:flicko_video/app_controller.dart';
import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/i18n/locale_controller.dart';
import 'package:flicko_video/gen/assets.gen.dart';
import 'package:flicko_video/page/web_content/view.dart';
import 'package:flicko_video/core/legal_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'controller.dart';
import 'state.dart';

class SettingView extends ConsumerWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingControllerProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeader(context, l10n),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: List.generate(state.items.length, (index) {
                    final item = state.items[index];
                    final isLast = index == state.items.length - 1;
                    return _buildSettingItem(
                      context,
                      ref,
                      item,
                      isLast: isLast,
                      l10n: l10n,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          l10n.settings,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    WidgetRef ref,
    SettingItem item, {
    required bool isLast,
    required AppLocalizations l10n,
  }) {
    final titleColor = item.isDestructive
        ? const Color(0xFFFF6B6B)
        : Colors.white;

    return InkWell(
      onTap: () => _handleTap(context, ref, item, l10n),
      borderRadius: BorderRadius.vertical(
        top: item.type == SettingItemType.language
            ? const Radius.circular(16)
            : Radius.zero,
        bottom: isLast ? const Radius.circular(16) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFF2A2A4A), width: 0.6),
                ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _resolveItemTitle(item.type, l10n),
                style: TextStyle(
                  color: titleColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (item.subtitle != null) ...[
              Text(
                item.subtitle!,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              item.type == SettingItemType.logout
                  ? Icons.logout_rounded
                  : Icons.chevron_right,
              color: item.isDestructive ? const Color(0xFFFF6B6B) : Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  String _resolveItemTitle(SettingItemType type, AppLocalizations l10n) {
    switch (type) {
      case SettingItemType.language:
        return l10n.language;
      case SettingItemType.termsOfService:
        return l10n.termsOfService;
      case SettingItemType.privacyPolicy:
        return l10n.privacyPolicy;
      case SettingItemType.aboutApp:
        return l10n.aboutApp;
      case SettingItemType.deleteAccount:
        return l10n.deleteAccount;
      case SettingItemType.logout:
        return l10n.logOut;
    }
  }

  Future<void> _handleTap(
    BuildContext context,
    WidgetRef ref,
    SettingItem item,
    AppLocalizations l10n,
  ) async {
    switch (item.type) {
      case SettingItemType.language:
        await _showLanguageSheet(context, ref, l10n);
      case SettingItemType.termsOfService:
        _openWebContent(
          context,
          title: l10n.termsOfService,
          url: termsOfServiceUrl,
        );
      case SettingItemType.privacyPolicy:
        _openWebContent(
          context,
          title: l10n.privacyPolicy,
          url: privacyPolicyUrl,
        );
      case SettingItemType.aboutApp:
        await _showAboutAppDialog(context, l10n);
      case SettingItemType.deleteAccount:
        context.push('/delete_account');
      case SettingItemType.logout:
        _showLogoutDialog(context, ref, l10n);
    }
  }

  void _openWebContent(
    BuildContext context, {
    required String title,
    required String url,
  }) {
    context.push(
      '/web_content',
      extra: WebContentArgs(title: title, url: url),
    );
  }

  Future<void> _showLanguageSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final currentLanguageCode = ref
        .read(appLocaleControllerProvider)
        .languageCode;
    final systemLanguageCode = ref
        .read(appLocaleControllerProvider)
        .systemLanguageCode;
    final languages = AppLocale.prioritized(
      currentLanguageCode: currentLanguageCode,
      systemLanguageCode: systemLanguageCode,
    );
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final maxHeight = MediaQuery.of(context).size.height * 0.72;

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.chooseLanguage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: languages.length,
                      separatorBuilder: (context, index) =>
                          const Divider(color: Color(0xFF2A2A4A), height: 1),
                      itemBuilder: (context, index) {
                        final language = languages[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            language.nativeName,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            language.englishName,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: language.code == currentLanguageCode
                              ? const Icon(
                                  Icons.check,
                                  color: Color(0xFF6C63FF),
                                )
                              : const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                          onTap: () => context.pop(language.code),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result != null && context.mounted) {
      await ref.read(appLocaleControllerProvider.notifier).updateLocale(result);
      await ref.read(settingControllerProvider.notifier).updateLanguage(result);
    }
  }

  Future<void> _showAboutAppDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Assets.icon.appLogo.image(width: 72, height: 72),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.appTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.version}: ${packageInfo.version} (${packageInfo.buildNumber})',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Color(0xFF6C63FF)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          title: Text(
            l10n.logoutConfirmTitle,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            l10n.logoutConfirmContent,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () => _logout(context, dialogContext, ref, l10n),
              child: Text(
                l10n.logOut,
                style: const TextStyle(color: Color(0xFFFF6B6B)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(
    BuildContext context,
    BuildContext dialogContext,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    Navigator.of(dialogContext).pop();
    var loggedInAsGuest = false;
    await EasyLoading.show();
    try {
      loggedInAsGuest = await AuthBox.logoutAndLoginGuest();
      if (loggedInAsGuest) {
        await ref.read(appControllerProvider.notifier).refreshAiModelConfig();
      }
    } finally {
      await EasyLoading.dismiss();
    }
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A1A2E),
        content: Text(
          loggedInAsGuest ? l10n.logoutSuccess : l10n.createTaskFailed,
        ),
      ),
    );
    if (loggedInAsGuest) {
      context.go('/me');
    }
  }
}
