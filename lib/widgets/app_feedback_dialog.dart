import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/widgets/app_top_toast.dart';
import 'package:flutter/material.dart';

Future<bool?> showAppFeedbackDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.72),
    builder: (context) => const AppFeedbackDialog(),
  );
}

class AppFeedbackDialog extends StatefulWidget {
  const AppFeedbackDialog({super.key});

  @override
  State<AppFeedbackDialog> createState() => _AppFeedbackDialogState();
}

class _AppFeedbackDialogState extends State<AppFeedbackDialog> {
  static const _maxLength = 1000;
  static const _reportTypeValues = [
    'Membership & Billing',
    'Sensitive or Pornographic',
    'Suicide or Self-harm',
    'Hate or Violence',
    'Harassment or Bullying',
    'Fraud or Scam',
    'Harmful to Minors',
    'Privacy Invasion',
    'Other',
  ];

  final _emailController = TextEditingController();
  final _contentController = TextEditingController();
  String? _reportType;
  var _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 31),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 23, 24, 24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A33),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.feedback,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.feedbackSubtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            _buildEmailField(l10n),
            const SizedBox(height: 12),
            _buildReportTypeDropdown(l10n),
            const SizedBox(height: 12),
            _buildContentField(l10n),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedBuilder(
                animation: _contentController,
                builder: (context, child) {
                  return Text(
                    '${_contentController.text.length}/$_maxLength',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.68),
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildCancelButton(l10n)),
                const SizedBox(width: 10),
                Expanded(child: _buildSubmitButton(l10n)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(AppLocalizations l10n) {
    return TextField(
      controller: _emailController,
      enabled: !_isSubmitting,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: _fieldDecoration(l10n.feedbackEmailHint),
    );
  }

  Widget _buildReportTypeDropdown(AppLocalizations l10n) {
    final labels = l10n.reportTypeLabels;

    return DropdownButtonFormField<String>(
      initialValue: _reportType,
      isExpanded: true,
      dropdownColor: const Color(0xFF1A1A33),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.white.withValues(alpha: 0.58),
      ),
      decoration: _fieldDecoration(l10n.reportTypeHint),
      hint: Text(
        l10n.reportTypeHint,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.42),
          fontSize: 14,
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      menuMaxHeight: 320,
      items: List.generate(_reportTypeValues.length, (index) {
        final value = _reportTypeValues[index];
        final label = labels.length > index ? labels[index] : value;
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: _isSubmitting
          ? null
          : (value) {
              setState(() => _reportType = value);
            },
    );
  }

  Widget _buildContentField(AppLocalizations l10n) {
    return TextField(
      controller: _contentController,
      enabled: !_isSubmitting,
      maxLines: 5,
      minLines: 5,
      maxLength: _maxLength,
      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.25),
      decoration: _fieldDecoration(l10n.feedbackContentHint).copyWith(
        counterText: '',
        contentPadding: const EdgeInsets.fromLTRB(12, 13, 12, 13),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.42),
        fontSize: 14,
      ),
      filled: true,
      fillColor: const Color(0xFF08080B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFFF3F91), width: 1),
      ),
    );
  }

  Widget _buildCancelButton(AppLocalizations l10n) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: _isSubmitting
            ? null
            : () => Navigator.of(context).pop(false),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF343449),
          disabledBackgroundColor: const Color(0xFF343449),
          foregroundColor: Colors.white.withValues(alpha: 0.72),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(l10n.cancel),
      ),
    );
  }

  Widget _buildSubmitButton(AppLocalizations l10n) {
    return SizedBox(
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFC83EF4), Color(0xFFFF3F91)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  l10n.submit,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final content = _contentController.text.trim();
    final email = _emailController.text.trim();
    final reportType = _reportType?.trim();

    if (content.isEmpty) {
      _showMessage(l10n.enterFeedbackFirst, isError: true);
      return;
    }
    if (email.isNotEmpty && !_isEmail(email)) {
      _showMessage(l10n.enterValidEmail, isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    final memberId = UserBox.member?.memberId ?? UserBox.balance?.memberId ?? 0;
    final response = await Api.submitFeedback(
      memberId: int.parse(memberId.toString()),
      feedbackContent: content,
      feedbackEmail: email.isEmpty ? null : email,
      reportType: reportType == null || reportType.isEmpty ? null : reportType,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (response.isSuccess) {
      _showMessage(l10n.feedbackSubmitted);
      Navigator.of(context).pop(true);
      return;
    }

    _showMessage(
      response.message.isNotEmpty
          ? response.message
          : l10n.feedbackSubmitFailed,
      isError: true,
    );
  }

  bool _isEmail(String value) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
  }

  void _showMessage(String message, {bool isError = false}) {
    showAppTopToast(
      context,
      message,
      type: isError ? AppTopToastType.error : AppTopToastType.success,
    );
  }
}
