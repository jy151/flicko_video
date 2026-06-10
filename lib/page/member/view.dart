import 'state.dart';
import 'controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/widgets/app_feedback_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemberView extends ConsumerStatefulWidget {
  const MemberView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MemberViewState();
}

class _MemberViewState extends ConsumerState<MemberView> {
  @override
  initState() {
    super.initState();

    final controller = ref.read(memberControllerProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await controller.init(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<MemberState>(memberControllerProvider, (previous, next) {
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

    final state = ref.watch(memberControllerProvider);
    final controller = ref.read(memberControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF262626), Color(0xFF000000)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _buildHeader(context, state, l10n),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      children: [
                        // _buildAvatarPlaceholder(),
                        const SizedBox(height: 168),
                        _buildPlans(state, controller, l10n),
                        const SizedBox(height: 18),
                        Text(
                          l10n.oneTimePayment(state.paymentAmount),
                          style: const TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.unlockAllPremiumFeatures,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFFFA800),
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _buildPremiumBenefits(state, l10n),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(state, controller, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBenefits(MemberState state, AppLocalizations l10n) {
    final bonusDiamonds = _plainDiamondAmount(
      state.bonusDiamonds.isNotEmpty
          ? state.bonusDiamonds
          : state.selectedPlan?.diamonds ?? '',
    );
    final weeklyDiamonds = _weeklyRefreshDiamonds(state);
    final rows = [
      _buildBenefitRow([
        TextSpan(text: '${l10n.instantBonus}: '),
        TextSpan(text: bonusDiamonds),
        const TextSpan(text: ' 💎'),
      ]),
      _buildBenefitRow([
        TextSpan(text: weeklyDiamonds),
        const TextSpan(text: ' 💎 '),
        TextSpan(text: l10n.refreshWeekly),
      ]),
      _buildBenefitRow([TextSpan(text: l10n.unlockAllTemplates)]),
      _buildBenefitRow([TextSpan(text: l10n.skipQueueNoWatermark)]),
      _buildBenefitRow([TextSpan(text: l10n.standardMediaBenefits)]),
    ];

    return Column(
      children: [
        for (var index = 0; index < rows.length; index++) ...[
          rows[index],
          if (index != rows.length - 1) const SizedBox(height: 14),
        ],
      ],
    );
  }

  Widget _buildBenefitRow(List<InlineSpan> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '✓',
          style: TextStyle(
            color: Color(0xFF00E676),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.15,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Color(0xFFE8E8E8),
                fontSize: 14,
                height: 1.35,
              ),
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  String _weeklyRefreshDiamonds(MemberState state) {
    final planText =
        '${state.selectedPlanId} ${state.selectedPlan?.title ?? ''}'
            .toLowerCase();
    if (planText.contains('annual') ||
        planText.contains('year') ||
        planText.contains('年度')) {
      return '200';
    }
    if (planText.contains('quarter') ||
        planText.contains('季度') ||
        planText.contains('季')) {
      return '100';
    }
    return '50';
  }

  String _plainDiamondAmount(String value) {
    return value.replaceAll(',', '').trim();
  }

  Widget _buildHeader(
    BuildContext context,
    MemberState state,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close, color: Colors.white, size: 30),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => showAppFeedbackDialog(context),
          icon: const Icon(
            Icons.chat_bubble_outline,
            color: Colors.white,
            size: 22,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => context.push('/recharge'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💎', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 4),
              Text(
                '${state.currentCredits}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: state.isLoading || state.isRestoring
              ? null
              : () => _onRestorePurchases(
                  ref.read(memberControllerProvider.notifier),
                ),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white54,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(44, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: state.isRestoring
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  '恢复购买',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
        ),
      ],
    );
  }

  Widget _buildPlans(
    MemberState state,
    MemberController controller,
    AppLocalizations l10n,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;
            const cardWidth = 108.0;
            final itemCount = state.plans.length;
            final totalSpacing = spacing * (itemCount - 1).clamp(0, 2);
            final contentWidth = itemCount == 0
                ? constraints.maxWidth
                : (cardWidth * itemCount) + totalSpacing;
            final rowWidth = contentWidth < constraints.maxWidth
                ? constraints.maxWidth
                : contentWidth;

            return SizedBox(
              height: 164,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: contentWidth > constraints.maxWidth
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: rowWidth,
                  height: 164,
                  child: Row(
                    mainAxisAlignment: contentWidth < constraints.maxWidth
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      for (var index = 0; index < itemCount; index++) ...[
                        SizedBox(
                          width: cardWidth,
                          height: 164,
                          child: _buildPlanCard(
                            state.plans[index],
                            state,
                            controller,
                            l10n,
                          ),
                        ),
                        if (index != itemCount - 1)
                          const SizedBox(width: spacing),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (state.isProductLoading)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x66000000),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFFFA800),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlanCard(
    MemberPlan plan,
    MemberState state,
    MemberController controller,
    AppLocalizations l10n,
  ) {
    final isSelected = state.selectedPlanId == plan.id;

    return GestureDetector(
      onTap: state.isProductLoading
          ? null
          : () => controller.selectPlan(plan.id),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              width: double.infinity,
              height: double.infinity,
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1A33),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFFB000)
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? const [
                        BoxShadow(
                          color: Color(0x33FFB000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ]
                    : const [],
              ),
              child: Column(
                children: [
                  Text(
                    _resolvePlanTitle(plan, l10n),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFFFB000)
                          : const Color(0xFFFFC14A),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: plan.price,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: plan.unit,
                          style: const TextStyle(
                            color: Color(0xFF8B8B99),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${plan.diamonds}💎',
                    style: const TextStyle(
                      color: Color(0xFF8B8B99),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 22),
                ],
              ),
            ),
            Positioned(
              top: -8,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA800),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  plan.saveLabel,
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
      ),
    );
  }

  Widget _buildBottomBar(
    MemberState state,
    MemberController controller,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        decoration: const BoxDecoration(
          color: Color(0xFF111111),
          border: Border(top: BorderSide(color: Color(0x22FFFFFF))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                color: const Color(0xFFFFA800),
              ),
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3F7BFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(27),
                        bottomLeft: Radius.circular(27),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      state.paymentAmount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(27),
                          bottomRight: Radius.circular(27),
                        ),
                        onTap:
                            state.isLoading ||
                                state.isProductLoading ||
                                !state.isStoreAvailable ||
                                state.selectedPlan?.productDetails == null
                            ? null
                            : () => _onUnlockVipService(controller),
                        child: Center(
                          child: state.isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  l10n.unlockVipService,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolvePlanTitle(MemberPlan plan, AppLocalizations l10n) {
    switch (plan.title) {
      case 'monthlyPlan':
        return l10n.monthlyPlan;
      case 'quarterlyPlan':
        return l10n.quarterlyPlan;
      case 'annualPlan':
        return l10n.annualPlan;
      default:
        return plan.title;
    }
  }

  Future<void> _onUnlockVipService(MemberController controller) async {
    await controller.unlockVipService();
  }

  Future<void> _onRestorePurchases(MemberController controller) async {
    await controller.restorePurchases();
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
