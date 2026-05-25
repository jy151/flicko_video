import 'state.dart';
import 'controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemberView extends ConsumerWidget {
  const MemberView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        Row(
                          children: [
                            const Text(
                              '✓',
                              style: TextStyle(
                                color: Color(0xFF00E676),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(text: '${l10n.instantBonus}: '),
                                    TextSpan(text: state.bonusDiamonds),
                                    const TextSpan(text: '💎'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
        const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 22),
        const SizedBox(width: 12),
        const Text('💎', style: TextStyle(fontSize: 18)),
        const SizedBox(width: 4),
        const Text('0', style: TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        color: const Color(0xFF2F2A28),
        borderRadius: BorderRadius.circular(85),
      ),
      child: const Center(
        child: Icon(Icons.person, size: 92, color: Colors.white24),
      ),
    );
  }

  Widget _buildPlans(
    MemberState state,
    MemberController controller,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      height: 164,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
        itemCount: state.plans.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final plan = state.plans[index];
          return SizedBox(
            width: 132,
            child: _buildPlanCard(plan, state, controller, l10n),
          );
        },
      ),
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
      onTap: () => controller.selectPlan(plan.id),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
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
                if (isSelected) ...[
                  const SizedBox(height: 6),
                  Text(
                    state.countdown,
                    style: const TextStyle(
                      color: Color(0xFFFF4D4F),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else
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
            Text(
              l10n.untilPriceGoesUp(state.countdown),
              style: const TextStyle(
                color: Color(0xFFFF4D4F),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
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
                    width: 96,
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
                        onTap: state.isLoading
                            ? null
                            : () => controller.unlockVipService(),
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
      case 'quarterlyPlan':
        return l10n.quarterlyPlan;
      case 'annualPlan':
        return l10n.annualPlan;
      case 'lifetimePlan':
        return l10n.lifetimePlan;
      default:
        return plan.title;
    }
  }
}
