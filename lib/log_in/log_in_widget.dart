import '/auth/firebase_auth/auth_util.dart';
import '/components/language_modal_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'log_in_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'log_in_model.dart';

class LogInWidget extends StatefulWidget {
  const LogInWidget({super.key});

  static String routeName = 'LogIn';
  static String routePath = '/logIn';

  @override
  State<LogInWidget> createState() => _LogInWidgetState();
}

class _LogInWidgetState extends State<LogInWidget>
    with TickerProviderStateMixin {
  late LogInModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LogInModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'LogIn'});

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    // 🔐 Load saved "Remember me" email
    _loadRememberedEmail();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  // ═══════════════════════════════════════════════════════════
  // REMEMBER ME — persist email via SharedPreferences
  // ═══════════════════════════════════════════════════════════
  Future<void> _loadRememberedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final remember = prefs.getBool('remember_me') ?? false;
      final savedEmail = prefs.getString('remembered_email') ?? '';

      if (remember && savedEmail.isNotEmpty && mounted) {
        safeSetState(() {
          _model.emailAddressTextController?.text = savedEmail;
          _model.checkboxValue = true;
        });
      } else if (mounted) {
        safeSetState(() => _model.checkboxValue = false);
      }
    } catch (_) {}
  }

  Future<void> _saveRememberedEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_model.checkboxValue == true) {
        await prefs.setBool('remember_me', true);
        await prefs.setString('remembered_email', email);
      } else {
        await prefs.setBool('remember_me', false);
        await prefs.remove('remembered_email');
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final topPad = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: Stack(
          children: [
            // ---------- Background gradient ----------
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.primary, const Color(0xFF053020)],
                  stops: const [0, 1],
                  begin: AlignmentDirectional(-1, -1),
                  end: AlignmentDirectional(1, 1),
                ),
              ),
            ),

            // ---------- Decorative circles ----------
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 120,
              left: -100,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // ---------- Main content ----------
            SafeArea(
              top: false,
              child: Column(
                children: [
                  // Language pill top-right
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16, topPad + 8, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: LanguageModalWidget(),
                                  ),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                          child: Container(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                14, 8, 14, 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.language_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  FFLocalizations.of(context).getText(
                                    '06953fwp' /* Language */,
                                  ),
                                  style: theme.bodySmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: theme.bodySmall.fontStyle,
                                    ),
                                    color: Colors.white,
                                    fontSize: 12,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: theme.bodySmall.fontStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // ---------- Logo + title ----------
                  Column(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/zannext_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .scale(begin: const Offset(0.7, 0.7)),
                      const SizedBox(height: 20),
                      Text(
                        'Welcome back',
                        textAlign: TextAlign.center,
                        style: theme.headlineMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w800,
                            fontStyle: theme.headlineMedium.fontStyle,
                          ),
                          color: Colors.white,
                          fontSize: 28,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w800,
                          fontStyle: theme.headlineMedium.fontStyle,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sign in to continue to ZanNext',
                        textAlign: TextAlign.center,
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontStyle: theme.bodyMedium.fontStyle,
                          ),
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                          fontStyle: theme.bodyMedium.fontStyle,
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 250.ms, duration: 500.ms)
                      .moveY(begin: 20, end: 0),

                  const Spacer(flex: 2),

                  // ---------- Form card ----------
                  Expanded(
                    flex: 9,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, -8),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24, 28, 24, 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _fieldLabel(context, 'Email'),
                                const SizedBox(height: 8),
                                _textField(
                                  context,
                                  controller:
                                      _model.emailAddressTextController!,
                                  focusNode: _model.emailAddressFocusNode!,
                                  hint: 'you@example.com',
                                  icon: Icons.alternate_email_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                  validator: _model
                                      .emailAddressTextControllerValidator
                                      .asValidator(context),
                                ),
                              ],
                            )
                                .animate()
                                .fadeIn(duration: 400.ms, delay: 100.ms)
                                .slideY(
                                  begin: 0.15,
                                  end: 0,
                                  duration: 400.ms,
                                  delay: 100.ms,
                                  curve: Curves.easeOutCubic,
                                ),
                            const SizedBox(height: 18),

                            // Password
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _fieldLabel(context, 'Password'),
                                const SizedBox(height: 8),
                                _passwordField(context),
                              ],
                            )
                                .animate()
                                .fadeIn(duration: 400.ms, delay: 200.ms)
                                .slideY(
                                  begin: 0.15,
                                  end: 0,
                                  duration: 400.ms,
                                  delay: 200.ms,
                                  curve: Curves.easeOutCubic,
                                ),
                            const SizedBox(height: 12),

                            // Remember + Forgot
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Checkbox(
                                        value: _model.checkboxValue ??= true,
                                        onChanged: (v) => safeSetState(
                                            () => _model.checkboxValue = v!),
                                        activeColor: theme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        side: BorderSide(
                                          color: theme.alternate,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Remember me',
                                      style: theme.bodySmall.override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              theme.bodySmall.fontStyle,
                                        ),
                                        color: theme.secondaryText,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: theme.bodySmall.fontStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                      ForgotPasswordWidget.routeName,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 4),
                                    child: Text(
                                      'Forgot password?',
                                      style: theme.bodySmall.override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              theme.bodySmall.fontStyle,
                                        ),
                                        color: theme.primary,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: theme.bodySmall.fontStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Sign In
                            _signInButton(context)
                                .animate()
                                .fadeIn(duration: 400.ms, delay: 300.ms)
                                .slideY(
                                  begin: 0.15,
                                  end: 0,
                                  duration: 400.ms,
                                  delay: 300.ms,
                                  curve: Curves.easeOutCubic,
                                ),
                            const SizedBox(height: 24),

                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: theme.alternate,
                                    height: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    'or continue with',
                                    style: theme.bodySmall.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: theme.bodySmall.fontStyle,
                                      ),
                                      color: theme.secondaryText,
                                      fontSize: 12,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: theme.bodySmall.fontStyle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: theme.alternate,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Social buttons — Google only (Apple removed)
                            _socialButton(
                              context,
                              label: 'Continue with Google',
                              icon: Image.asset(
                                'assets/images/google_logo.png',
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                              onTap: () async {
                                GoRouter.of(context).prepareAuthEvent();
                                final user = await authManager
                                    .signInWithGoogle(context);
                                if (user == null) return;
                                context.goNamedAuth(
                                    HomeWidget.routeName, context.mounted);
                              },
                            ),
                            const SizedBox(height: 24),

                            // Sign Up link
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  context.pushNamed(
                                    SignUpWidget.routeName,
                                  );
                                },
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Don't have an account?  ",
                                        style: theme.bodyMedium.override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontStyle:
                                                theme.bodyMedium.fontStyle,
                                          ),
                                          color: theme.secondaryText,
                                          fontSize: 13,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w400,
                                          fontStyle:
                                              theme.bodyMedium.fontStyle,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Sign Up',
                                        style: theme.bodyMedium.override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontStyle:
                                                theme.bodyMedium.fontStyle,
                                          ),
                                          color: theme.primary,
                                          fontSize: 13,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w700,
                                          fontStyle:
                                              theme.bodyMedium.fontStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 500.ms)
                        .moveY(begin: 40, end: 0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FIELD LABEL
  // ============================================================
  Widget _fieldLabel(BuildContext context, String text) {
    final theme = FlutterFlowTheme.of(context);
    return Text(
      text,
      style: theme.bodySmall.override(
        font: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontStyle: theme.bodySmall.fontStyle,
        ),
        color: theme.primaryText,
        fontSize: 12,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w700,
        fontStyle: theme.bodySmall.fontStyle,
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================
  Widget _textField(
    BuildContext context, {
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
    String? Function(String?)? validator,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      validator: validator,
      style: theme.bodyMedium.override(
        font: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontStyle: theme.bodyMedium.fontStyle,
        ),
        color: theme.primaryText,
        fontSize: 15,
        letterSpacing: 0.0,
        fontWeight: FontWeight.w500,
        fontStyle: theme.bodyMedium.fontStyle,
      ),
      cursorColor: theme.primary,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.bodyMedium.override(
          font: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontStyle: theme.bodyMedium.fontStyle,
          ),
          color: theme.secondaryText,
          fontSize: 14,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w400,
          fontStyle: theme.bodyMedium.fontStyle,
        ),
        prefixIcon: Icon(icon, color: theme.secondaryText, size: 20),
        filled: true,
        fillColor: theme.primaryBackground,
        contentPadding:
            const EdgeInsetsDirectional.fromSTEB(12, 18, 12, 18),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.alternate, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primary, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.error, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.error, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ============================================================
  // PASSWORD FIELD
  // ============================================================
  Widget _passwordField(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return TextFormField(
      controller: _model.passwordTextController,
      focusNode: _model.passwordFocusNode,
      obscureText: !_model.passwordVisibility,
      autofillHints: const [AutofillHints.password],
      validator: _model.passwordTextControllerValidator.asValidator(context),
      style: theme.bodyMedium.override(
        font: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontStyle: theme.bodyMedium.fontStyle,
        ),
        color: theme.primaryText,
        fontSize: 15,
        letterSpacing: 0.0,
        fontWeight: FontWeight.w500,
        fontStyle: theme.bodyMedium.fontStyle,
      ),
      cursorColor: theme.primary,
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: theme.bodyMedium.override(
          font: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontStyle: theme.bodyMedium.fontStyle,
          ),
          color: theme.secondaryText,
          fontSize: 14,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w400,
          fontStyle: theme.bodyMedium.fontStyle,
        ),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: theme.secondaryText,
          size: 20,
        ),
        suffixIcon: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => safeSetState(
              () => _model.passwordVisibility = !_model.passwordVisibility),
          child: Icon(
            _model.passwordVisibility
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: theme.secondaryText,
            size: 20,
          ),
        ),
        filled: true,
        fillColor: theme.primaryBackground,
        contentPadding:
            const EdgeInsetsDirectional.fromSTEB(12, 18, 12, 18),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.alternate, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primary, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.error, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.error, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ============================================================
  // SIGN IN BUTTON
  // ============================================================
  Widget _signInButton(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return FFButtonWidget(
      onPressed: () async {
        logFirebaseEvent('LOG_IN_PAGE_SIGN_IN_BTN_ON_TAP');
        GoRouter.of(context).prepareAuthEvent();

        final email = _model.emailAddressTextController.text.trim();
        // 🔐 Remember this email if checkbox is ticked
        await _saveRememberedEmail(email);

        final user = await authManager.signInWithEmail(
          context,
          email,
          _model.passwordTextController.text,
        );
        if (user == null) return;

        context.goNamedAuth(HomeWidget.routeName, context.mounted);
      },
      text: 'Sign In',
      options: FFButtonOptions(
        width: double.infinity,
        height: 52,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        iconPadding: EdgeInsets.zero,
        color: theme.primary,
        textStyle: theme.titleSmall.override(
          font: GoogleFonts.interTight(
            fontWeight: FontWeight.w700,
            fontStyle: theme.titleSmall.fontStyle,
          ),
          color: Colors.white,
          fontSize: 16,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w700,
          fontStyle: theme.titleSmall.fontStyle,
        ),
        elevation: 0,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  // ============================================================
  // SOCIAL BUTTON
  // ============================================================
  Widget _socialButton(
    BuildContext context, {
    required String label,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.alternate, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              label,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontStyle: theme.bodyMedium.fontStyle,
                ),
                color: theme.primaryText,
                fontSize: 14,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                fontStyle: theme.bodyMedium.fontStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}