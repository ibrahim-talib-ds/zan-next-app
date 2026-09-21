import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'welcome_model.dart';
export 'welcome_model.dart';

class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({super.key});

  static String routeName = 'Welcome';
  static String routePath = '/welcome';

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget>
    with TickerProviderStateMixin {
  late WelcomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WelcomeModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Welcome'});
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primary, const Color(0xFF053020)],
              stops: const [0, 1],
              begin: AlignmentDirectional(-1, -1),
              end: AlignmentDirectional(1, 1),
            ),
          ),
          child: Stack(
            children: [
              // ---------- Decorative circles ----------
              Positioned(
                top: -100,
                right: -80,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 200,
                left: -120,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // ---------- Main content ----------
              SafeArea(
                top: true,
                child: Column(
                  children: [
                    const Spacer(flex: 3),

                    // Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/zannext_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .scale(begin: const Offset(0.7, 0.7)),

                    const SizedBox(height: 28),

                    // Title
                    Text(
                      'ZanNext',
                      textAlign: TextAlign.center,
                      style: theme.headlineLarge.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FontWeight.w800,
                          fontStyle: theme.headlineLarge.fontStyle,
                        ),
                        color: Colors.white,
                        fontSize: 40,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w800,
                        fontStyle: theme.headlineLarge.fontStyle,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 500.ms)
                        .moveY(begin: 12, end: 0),

                    const SizedBox(height: 10),

                    // Tagline
                    Text(
                      'Buy. Sell. Connect.',
                      textAlign: TextAlign.center,
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontStyle: theme.bodyMedium.fontStyle,
                        ),
                        color: Colors.white70,
                        fontSize: 15,
                        letterSpacing: 3.0,
                        fontWeight: FontWeight.w400,
                        fontStyle: theme.bodyMedium.fontStyle,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 350.ms, duration: 500.ms),

                    const Spacer(flex: 4),

                    // ---------- Bottom card ----------
                    Container(
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
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24, 32, 24, 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Header
                              Text(
                                'Welcome',
                                textAlign: TextAlign.center,
                                style: theme.titleLarge.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: theme.titleLarge.fontStyle,
                                  ),
                                  color: theme.primaryText,
                                  fontSize: 22,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: theme.titleLarge.fontStyle,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Sign in or create a new account to get started',
                                textAlign: TextAlign.center,
                                style: theme.bodySmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: theme.bodySmall.fontStyle,
                                  ),
                                  color: theme.secondaryText,
                                  fontSize: 13,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: theme.bodySmall.fontStyle,
                                  lineHeight: 1.4,
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Sign In button — goes directly to LogIn
                              FFButtonWidget(
                                onPressed: () async {
                                  logFirebaseEvent(
                                      'WELCOME_PAGE_SIGN_IN_BTN_ON_TAP');
                                  context.pushNamed(
                                    LogInWidget.routeName,
                                    extra: <String, dynamic>{
                                      '__transition_info__': TransitionInfo(
                                        hasTransition: true,
                                        transitionType:
                                            PageTransitionType.rightToLeft,
                                        duration:
                                            const Duration(milliseconds: 250),
                                      ),
                                    },
                                  );
                                },
                                text: 'Sign In',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 52,
                                  padding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          16, 0, 16, 0),
                                  iconPadding: EdgeInsets.zero,
                                  color: theme.primary,
                                  textStyle: theme.titleSmall.override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FontWeight.w700,
                                      fontStyle:
                                          theme.titleSmall.fontStyle,
                                    ),
                                    color: Colors.white,
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w700,
                                    fontStyle:
                                        theme.titleSmall.fontStyle,
                                  ),
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Create Account button
                              FFButtonWidget(
                                onPressed: () async {
                                  logFirebaseEvent(
                                      'WELCOME_PAGE_SIGN_UP_BTN_ON_TAP');
                                  context.pushNamed(
                                    SignUpWidget.routeName,
                                    extra: <String, dynamic>{
                                      '__transition_info__': TransitionInfo(
                                        hasTransition: true,
                                        transitionType:
                                            PageTransitionType.rightToLeft,
                                        duration:
                                            const Duration(milliseconds: 250),
                                      ),
                                    },
                                  );
                                },
                                text: 'Create New Account',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 52,
                                  padding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          16, 0, 16, 0),
                                  iconPadding: EdgeInsets.zero,
                                  color: theme.primaryBackground,
                                  textStyle: theme.titleSmall.override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FontWeight.w700,
                                      fontStyle:
                                          theme.titleSmall.fontStyle,
                                    ),
                                    color: theme.primary,
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w700,
                                    fontStyle:
                                        theme.titleSmall.fontStyle,
                                  ),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color: theme.primary,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Legal footer
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Privacy Policy',
                                    style: theme.bodySmall.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontStyle:
                                            theme.bodySmall.fontStyle,
                                      ),
                                      color: theme.secondaryText,
                                      fontSize: 12,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w400,
                                      fontStyle:
                                          theme.bodySmall.fontStyle,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Container(
                                    width: 3,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: theme.secondaryText,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    'Terms of Service',
                                    style: theme.bodySmall.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontStyle:
                                            theme.bodySmall.fontStyle,
                                      ),
                                      color: theme.secondaryText,
                                      fontSize: 12,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w400,
                                      fontStyle:
                                          theme.bodySmall.fontStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 500.ms)
                        .moveY(begin: 40, end: 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}