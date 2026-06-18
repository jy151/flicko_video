import 'package:flicko_video/core/legal_urls.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/page/web_content/view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsAgreementCheckbox extends StatelessWidget {
  const TermsAgreementCheckbox({
    super.key,
    required this.agreed,
    required this.onChanged,
  });

  final bool agreed;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: agreed,
            onChanged: (value) => onChanged(value ?? false),
            shape: const CircleBorder(),
            side: const BorderSide(color: Colors.white54, width: 1.5),
            activeColor: const Color(0xFF6C63FF),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              children: [
                TextSpan(text: l10n.agreeToThe),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _openWebContent(
                      context,
                      title: l10n.privacyPolicy,
                      url: privacyPolicyUrl,
                    ),
                    child: const _TermsLink(textKey: _TermsLinkKey.privacy),
                  ),
                ),
                TextSpan(text: l10n.and),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _openWebContent(
                      context,
                      title: l10n.termsOfService,
                      url: termsOfServiceUrl,
                    ),
                    child: const _TermsLink(textKey: _TermsLinkKey.terms),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
}

enum _TermsLinkKey { privacy, terms }

class _TermsLink extends StatelessWidget {
  const _TermsLink({required this.textKey});

  final _TermsLinkKey textKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = switch (textKey) {
      _TermsLinkKey.privacy => l10n.privacyPolicy,
      _TermsLinkKey.terms => l10n.termsOfService,
    };

    return Text(
      text,
      style: const TextStyle(color: Color(0xFF7DCBFA), fontSize: 13),
    );
  }
}
