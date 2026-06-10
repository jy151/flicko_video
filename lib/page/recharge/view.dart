import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/widgets/app_feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'controller.dart';
import 'state.dart';

class RechargeView extends ConsumerStatefulWidget {
  const RechargeView({super.key});

  @override
  createState() => _RechargeViewState();
}

class _RechargeViewState extends ConsumerState<RechargeView> {
  @override
  void initState() {
    super.initState();

    final controller = ref.read(rechargeControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await controller.init(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RechargeState>(rechargeControllerProvider, (previous, next) {
      final errorMessage = next.errorMessage;
      if (errorMessage != null && errorMessage != previous?.errorMessage) {
        _showMessage(context, errorMessage);
      }

      final successMessage = next.successMessage;
      if (successMessage != null &&
          successMessage != previous?.successMessage) {
        _showMessage(context, successMessage);
      }
    });

    final state = ref.watch(rechargeControllerProvider);
    final controller = ref.read(rechargeControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l10n),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildCreditsInfo(state, l10n),
                    const SizedBox(height: 24),
                    _buildPackagesGrid(state, controller),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        l10n.moreCreditFeatures,
                        style: const TextStyle(
                          color: Color(0xFF6B6B7B),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildRechargeButton(state, controller, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close, color: Colors.white, size: 26),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => showAppFeedbackDialog(context),
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditsInfo(RechargeState state, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.myCredits,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${state.currentCredits}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Text('💎', style: TextStyle(fontSize: 48)),
      ],
    );
  }

  Widget _buildPackagesGrid(
    RechargeState state,
    RechargeController controller,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: state.packages.length,
          itemBuilder: (context, index) {
            final pkg = state.packages[index];
            final isSelected = pkg.id == state.selectedPackageId;
            return _buildPackageCard(pkg, isSelected, state, controller);
          },
        ),
        if (state.isProductLoading)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x660D0D1A),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFFF4081),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPackageCard(
    RechargePackage pkg,
    bool isSelected,
    RechargeState state,
    RechargeController controller,
  ) {
    return GestureDetector(
      onTap: state.isProductLoading
          ? null
          : () => controller.selectPackage(pkg.id),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFFFA800)
                    : const Color(0xFF2A2A4A),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${pkg.diamonds}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text('💎', style: TextStyle(fontSize: 16)),
                  ],
                ),
                if (pkg.giftAmount > 0) ...[
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 11),
                      children: [
                        TextSpan(
                          text: '${pkg.baseAmount} + ',
                          style: const TextStyle(color: Colors.white54),
                        ),
                        TextSpan(
                          text: '${pkg.giftAmount} Gift',
                          style: const TextStyle(color: Color(0xFFFF6B9D)),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  pkg.price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (pkg.badge != null)
            Positioned(
              top: -6,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: pkg.badge == 'ultimate'
                      ? const Color(0xFFFFA800)
                      : const Color(0xFFFF6B9D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pkg.badge == 'ultimate' ? '🏆 Ultimate' : '🔥 Best Popular',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRechargeButton(
    RechargeState state,
    RechargeController controller,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed:
                state.isLoading ||
                    state.isProductLoading ||
                    !state.isStoreAvailable ||
                    state.selectedPackage?.productDetails == null
                ? null
                : () => _onRecharge(controller),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4081),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFF3A3A4A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 0,
            ),
            child: state.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    l10n.recharge,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRecharge(RechargeController controller) async {
    await controller.recharge();
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A1A2E),
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
