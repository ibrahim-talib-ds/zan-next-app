import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'forgot_password_model.dart';
export 'forgot_password_model.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  static String routeName = 'ForgotPassword';
  static String routePath = '/forgotPassword';

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget>
    with TickerProviderStateMixin {
  late ForgotPasswordModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ForgotPasswordModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'ForgotPassword'});

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

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

                  const Spacer(flex: 3),

                  // ---------- Icon + title ----------
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
                        child: Icon(
                          Icons.lock_reset_rounded,
                          color: theme.primary,
                          size: 44,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Forgot Password?',
                        textAlign: TextAlign.center,
                        style: theme.headlineMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w800,
                            fontStyle: theme.headlineMedium.fontStyle,
                          ),
                          color: Colors.white,
                          fontSize: 26,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w800,
                          fontStyle: theme.headlineMedium.fontStyle,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Enter the email tied to your account and we will send you a reset link.',
                          textAlign: TextAlign.center,
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontStyle: theme.bodyMedium.fontStyle,
                            ),
                            color: Colors.white70,
                            fontSize: 13,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w400,
                            fontStyle: theme.bodyMedium.fontStyle,
                            lineHeight: 1.5,
                          ),
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .moveY(begin: 20, end: 0),

                  const Spacer(flex: 2),

                  // ---------- Form card ----------
                  Expanded(
                    flex: 8,
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
                            // Email field
                            _fieldLabel(context, 'Email'),
                            const SizedBox(height: 8),
                            _buildEmailField(context),

                            const SizedBox(height: 24),

                            // Send reset button
                            _buildSendButton(context),

                            const SizedBox(height: 24),

                            // Back to sign-in link
                            Center(
                              child: GestureDetector(
                                onTap: () => context.safePop(),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Remember your password?  ',
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
  // EMAIL FIELD
  // ============================================================
  Widget _buildEmailField(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return TextFormField(
      controller: _model.emailTextController,
      focusNode: _model.emailFocusNode,
      autofocus: true,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      validator: _model.emailTextControllerValidator.asValidator(context),
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
        hintText: 'you@example.com',
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
          Icons.alternate_email_rounded,
          color: theme.secondaryText,
          size: 20,
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
  // SEND RESET BUTTON
  // ============================================================
  Widget _buildSendButton(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return FFButtonWidget(
      onPressed: () async {
        logFirebaseEvent('FORGOT_PASSWORD_PAGE_LOGIN_BTN_ON_TAP');
        logFirebaseEvent('Button_auth');

        final email = _model.emailTextController.text.trim();
        if (email.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter your email address'),
            ),
          );
          return;
        }

        try {
          await authManager.resetPassword(
            email: email,
            context: context,
          );

          if (!mounted) return;
          // Show success inline; no external page needed
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Reset link sent! Check your email inbox.\nIf it\'s not there, check spam.',
              ),
              backgroundColor: Color(0xFF1B7A4E),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 6),
            ),
          );
          await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return;
          Navigator.of(context).pop();

        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not send reset email: $e')),
          );
        }
      },
      text: 'Send Reset Link',
      icon: const Icon(Icons.mail_outline_rounded, size: 18),
      options: FFButtonOptions(
        width: double.infinity,
        height: 52,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
}