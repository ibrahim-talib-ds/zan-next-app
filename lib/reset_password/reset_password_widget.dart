import '/flutter_flow/flutter_flow_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/index.dart';

import 'reset_password_model.dart';
export 'reset_password_model.dart';

/// In-app password reset screen.
class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({
    super.key,
    required this.oobCode,
  });

  final String oobCode;

  static String routeName = 'ResetPassword';
  static String routePath = '/resetPassword';

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  late ResetPasswordModel _model;

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  String? _email;
  bool _verifying = true;
  String? _verifyError;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResetPasswordModel());
    _model.passwordController ??= TextEditingController();
    _model.confirmController ??= TextEditingController();
    _model.passwordFocus ??= FocusNode();
    _model.confirmFocus ??= FocusNode();
    _verifyCode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    try {
      final email = await FirebaseAuth.instance
          .verifyPasswordResetCode(widget.oobCode);
      if (!mounted) return;
      setState(() {
        _email = email;
        _verifying = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _verifyError = _friendlyError(e.toString());
        _verifying = false;
      });
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('expired-action-code')) {
      return 'This reset link has expired. Please request a new one.';
    }
    if (raw.contains('invalid-action-code')) {
      return 'This reset link is invalid or already used.';
    }
    return 'Could not verify the link. Please request a new one.';
  }

  Future<void> _submit() async {
    final pw = _model.passwordController!.text.trim();
    final cf = _model.confirmController!.text.trim();
    if (pw.isEmpty || pw.length < 8) {
      _snack('Password must be at least 8 characters', kRed);
      return;
    }
    if (pw != cf) {
      _snack('Passwords do not match', kRed);
      return;
    }

    setState(() => _model.isSaving = true);
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: widget.oobCode,
        newPassword: pw,
      );
      if (!mounted) return;
      _snack('Password updated successfully!', kGreen);
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        LogInWidget.routeName,
        (r) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _model.isSaving = false);
      _snack(_friendlyError(e.toString()), kRed);
    }
  }

  void _snack(String msg, Color bg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: _verifying
            ? _loading()
            : (_verifyError != null ? _error() : _form()),
      ),
    );
  }

  Widget _loading() => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kGreen),
        ),
      );

  Widget _error() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: kRed.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error_outline_rounded,
                    color: kRed, size: 40),
              ),
              const SizedBox(height: 18),
              Text(
                _verifyError!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _text,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    ForgotPasswordWidget.routeName,
                    (r) => false,
                  );
                },
                child: const Text('Request new link',
                    style: TextStyle(
                      color: kGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    )),
              ),
            ],
          ),
        ),
      );

  Widget _form() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kGreen, kGreenDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_reset_rounded,
                  color: Colors.white, size: 38),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Set New Password',
              style: GoogleFonts.interTight(
                color: _text,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              _email != null ? 'For $_email' : '',
              style: TextStyle(color: _muted, fontSize: 13),
            ),
          ),
          const SizedBox(height: 32),

          Text('NEW PASSWORD',
              style: TextStyle(
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              )),
          const SizedBox(height: 8),
          _field(
            controller: _model.passwordController!,
            focus: _model.passwordFocus!,
            hint: 'At least 8 characters',
            icon: Icons.lock_outline_rounded,
            obscure: !_model.showPassword,
            onToggle: () => setState(
                () => _model.showPassword = !_model.showPassword),
          ),
          const SizedBox(height: 18),

          Text('CONFIRM PASSWORD',
              style: TextStyle(
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              )),
          const SizedBox(height: 8),
          _field(
            controller: _model.confirmController!,
            focus: _model.confirmFocus!,
            hint: 'Re-enter password',
            icon: Icons.lock_outline_rounded,
            obscure: !_model.showConfirm,
            onToggle: () => setState(
                () => _model.showConfirm = !_model.showConfirm),
          ),
          const SizedBox(height: 32),

          GestureDetector(
            onTap: _model.isSaving ? null : _submit,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kGreen, kGreenDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: kGreen.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: _model.isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_rounded,
                              color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Update Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required FocusNode focus,
    required String hint,
    required IconData icon,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 6, 0),
      child: Row(
        children: [
          Icon(icon, color: kGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focus,
              obscureText: obscure,
              style: TextStyle(color: _text, fontSize: 14.5),
              cursorColor: kGreen,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: hint,
                hintStyle: TextStyle(color: _muted, fontSize: 14),
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
              ),
            ),
          ),
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: _muted,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
