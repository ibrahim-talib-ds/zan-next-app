import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
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

import 'sign_up_model.dart';
export 'sign_up_model.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  static String routeName = 'SignUp';
  static String routePath = '/signUp';

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget>
    with TickerProviderStateMixin {
  late SignUpModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignUpModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'SignUp'});

    _model.txtnameTextController ??= TextEditingController();
    _model.txtnameFocusNode ??= FocusNode();

    _model.txtphoneTextController ??= TextEditingController();
    _model.txtphoneFocusNode ??= FocusNode();

    _model.txtemailTextController ??= TextEditingController();
    _model.txtemailFocusNode ??= FocusNode();

    _model.textPassortTextController ??= TextEditingController();
    _model.textPassortFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
                  // Back button top-left
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(8, topPad + 8, 16, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.safePop(),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // ---------- Title ----------
                  Column(
                    children: [
                      Text(
                        'Create Account',
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
                        'Join ZanNext in a few seconds',
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
                      .fadeIn(duration: 500.ms)
                      .moveY(begin: 20, end: 0),

                  const Spacer(flex: 1),

                  // ---------- Form card ----------
                  Expanded(
                    flex: 11,
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
                            // Name
                            _fieldLabel(context, 'Full name'),
                            const SizedBox(height: 8),
                            _textField(
                              context,
                              controller: _model.txtnameTextController!,
                              focusNode: _model.txtnameFocusNode!,
                              hint: 'Your name',
                              icon: Icons.person_outline_rounded,
                              textCapitalization: TextCapitalization.words,
                              validator: _model
                                  .txtnameTextControllerValidator
                                  .asValidator(context),
                            ),
                            const SizedBox(height: 16),

                            // Phone
                            _fieldLabel(context, 'Phone'),
                            const SizedBox(height: 8),
                            _textField(
                              context,
                              controller: _model.txtphoneTextController!,
                              focusNode: _model.txtphoneFocusNode!,
                              hint: '+255 ...',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              autofillHints: const [
                                AutofillHints.telephoneNumber
                              ],
                              validator: _model
                                  .txtphoneTextControllerValidator
                                  .asValidator(context),
                            ),
                            const SizedBox(height: 16),

                            // Email
                            _fieldLabel(context, 'Email'),
                            const SizedBox(height: 8),
                            _textField(
                              context,
                              controller: _model.txtemailTextController!,
                              focusNode: _model.txtemailFocusNode!,
                              hint: 'you@example.com',
                              icon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              validator: _model
                                  .txtemailTextControllerValidator
                                  .asValidator(context),
                            ),
                            const SizedBox(height: 16),

                            // Password
                            _fieldLabel(context, 'Password'),
                            const SizedBox(height: 8),
                            _passwordField(context),
                            const SizedBox(height: 16),

                            // Consent checkbox
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      value: _model.checkboxValue ??= true,
                                      onChanged: (v) => safeSetState(
                                          () => _model.checkboxValue = v!),
                                      activeColor: theme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      side: BorderSide(
                                        color: theme.alternate,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    textScaler:
                                        MediaQuery.of(context).textScaler,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'I agree to the ',
                                          style: theme.bodySmall.override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              fontStyle: theme
                                                  .bodySmall.fontStyle,
                                            ),
                                            color: theme.secondaryText,
                                            fontSize: 12,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w400,
                                            fontStyle:
                                                theme.bodySmall.fontStyle,
                                            lineHeight: 1.5,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Terms of Service',
                                          style: theme.bodySmall.override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontStyle: theme
                                                  .bodySmall.fontStyle,
                                            ),
                                            color: theme.primary,
                                            fontSize: 12,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                theme.bodySmall.fontStyle,
                                            lineHeight: 1.5,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' and ',
                                          style: theme.bodySmall.override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              fontStyle: theme
                                                  .bodySmall.fontStyle,
                                            ),
                                            color: theme.secondaryText,
                                            fontSize: 12,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w400,
                                            fontStyle:
                                                theme.bodySmall.fontStyle,
                                            lineHeight: 1.5,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: theme.bodySmall.override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontStyle: theme
                                                  .bodySmall.fontStyle,
                                            ),
                                            color: theme.primary,
                                            fontSize: 12,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                theme.bodySmall.fontStyle,
                                            lineHeight: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Sign Up button
                            _signUpButton(context),
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
                                    'or sign up with',
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

                            // Social buttons
                            Row(
                              children: [
                                Expanded(
                                  child: _socialButton(
                                    context,
                                    label: 'Google',
                                    icon: const FaIcon(
                                      FontAwesomeIcons.google,
                                      size: 18,
                                      color: Color(0xFFDB4437),
                                    ),
                                    onTap: () async {
                                      GoRouter.of(context)
                                          .prepareAuthEvent();
                                      final user = await authManager
                                          .signInWithGoogle(context);
                                      if (user == null) return;
                                      context.goNamedAuth(
                                          HomeWidget.routeName,
                                          context.mounted);
                                    },
                                  ),
                                ),
                                if (!isAndroid) ...[
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _socialButton(
                                      context,
                                      label: 'Apple',
                                      icon: const FaIcon(
                                        FontAwesomeIcons.apple,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      onTap: () async {
                                        GoRouter.of(context)
                                            .prepareAuthEvent();
                                        final user = await authManager
                                            .signInWithApple(context);
                                        if (user == null) return;
                                        context.goNamedAuth(
                                            HomeWidget.routeName,
                                            context.mounted);
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Sign In link
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  context.pushNamed(
                                    LogInWidget.routeName,
                                  );
                                },
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Already have an account?  ',
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
                                        text: 'Sign In',
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
                        .fadeIn(delay: 300.ms, duration: 500.ms)
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
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      textCapitalization: textCapitalization,
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
      controller: _model.textPassortTextController,
      focusNode: _model.textPassortFocusNode,
      obscureText: !_model.textPassortVisibility,
      autofillHints: const [AutofillHints.newPassword],
      validator:
          _model.textPassortTextControllerValidator.asValidator(context),
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
          onTap: () => safeSetState(() =>
              _model.textPassortVisibility = !_model.textPassortVisibility),
          child: Icon(
            _model.textPassortVisibility
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
  // SIGN UP BUTTON
  // ============================================================
  Widget _signUpButton(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return FFButtonWidget(
      onPressed: (_model.txtnameTextController.text.trim().isEmpty ||
              _model.txtemailTextController.text.trim().isEmpty ||
              _model.textPassortTextController.text.isEmpty)
          ? null
          : () async {
              logFirebaseEvent('SIGN_UP_PAGE_SIGN_UP_BTN_ON_TAP');
              GoRouter.of(context).prepareAuthEvent();

              final user = await authManager.createAccountWithEmail(
                context,
                _model.txtemailTextController.text.trim(),
                _model.textPassortTextController.text,
              );
              if (user == null) return;

              // Save name + phone to the Users record
              try {
                await UsersRecord.collection.doc(user.uid).update(
                      createUsersRecordData(
                        displayName:
                            _model.txtnameTextController.text.trim(),
                        phoneNumber:
                            _model.txtphoneTextController.text.trim(),
                      ),
                    );
              } catch (_) {}

              context.goNamedAuth(HomeWidget.routeName, context.mounted);
            },
      text: 'Create Account',
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
        disabledColor: theme.secondaryText,
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