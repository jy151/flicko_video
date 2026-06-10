import 'package:flutter/material.dart';

enum AppTopToastType { success, error, info }

void showAppTopToast(
  BuildContext context,
  String message, {
  AppTopToastType type = AppTopToastType.info,
  Duration duration = const Duration(milliseconds: 2600),
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  var removed = false;
  late final OverlayEntry entry;

  void remove() {
    if (removed) {
      return;
    }
    removed = true;
    entry.remove();
  }

  entry = OverlayEntry(
    builder: (context) {
      final top = MediaQuery.of(context).padding.top + 14;
      return Positioned(
        top: top,
        left: 16,
        right: 16,
        child: _AppTopToast(message: message, type: type, onDismiss: remove),
      );
    },
  );

  overlay.insert(entry);
  Future<void>.delayed(duration, remove);
}

class _AppTopToast extends StatelessWidget {
  const _AppTopToast({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  final String message;
  final AppTopToastType type;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = switch (type) {
      AppTopToastType.success => (
        const Color(0xFF12B76A),
        const Color(0xFF067647),
        Icons.check_circle_rounded,
      ),
      AppTopToastType.error => (
        const Color(0xFFFF4D6D),
        const Color(0xFFB42335),
        Icons.error_rounded,
      ),
      AppTopToastType.info => (
        const Color(0xFFC83EF4),
        const Color(0xFFFF3F91),
        Icons.info_rounded,
      ),
    };

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [colors.$1, colors.$2]),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          boxShadow: [
            BoxShadow(
              color: colors.$2.withValues(alpha: 0.42),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(colors.$3, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
