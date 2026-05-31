import 'package:flicko_video/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabView extends StatelessWidget {
  final Widget child;
  const TabView({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/effects')) return 1;
    if (location.startsWith('/discover')) return 2;
    if (location.startsWith('/me')) return 3;
    return 0;
  }

  

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        context.go('/effects');
      case 2:
        context.go('/discover');
      case 3:
        context.go('/me');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: child,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onTap(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0D0D1A),
          selectedItemColor: const Color(0xFF6C63FF),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.lightbulb_outline, size: 22),
              activeIcon: const Icon(Icons.lightbulb_outline, size: 22),
              label: l10n.creation,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.auto_awesome_outlined, size: 22),
              activeIcon: const Icon(Icons.auto_awesome_outlined, size: 22),
              label: l10n.effects,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.travel_explore_outlined, size: 22),
              activeIcon: const Icon(Icons.travel_explore_outlined, size: 22),
              label: l10n.discover,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded, size: 22),
              activeIcon: const Icon(Icons.person_rounded, size: 22),
              label: l10n.me,
            ),
          ],
        ),
      ),
    );
  }
}
