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

import 'logout_model.dart';
export 'logout_model.dart';

class LogoutWidget extends StatefulWidget {
  const LogoutWidget({super.key});

  @override
  State<LogoutWidget> createState() => _LogoutWidgetState();
}

class _LogoutWidgetState extends State<LogoutWidget> {
  late LogoutModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LogoutModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- Drag handle ----------
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.alternate,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ---------- Icon ----------
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: theme.error.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: theme.error,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ---------- Title ----------
              Text(
                'Log out?',
                textAlign: TextAlign.center,
                style: theme.headlineSmall.override(
                  font: GoogleFonts.interTight(
                    fontWeight: FontWeight.w700,
                    fontStyle: theme.headlineSmall.fontStyle,
                  ),
                  color: theme.primaryText,
                  fontSize: 22,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: theme.headlineSmall.fontStyle,
                ),
              ),
              const SizedBox(height: 8),

              // ---------- Body ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Are you sure you want to log out of your account?',
                  textAlign: TextAlign.center,
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontStyle: theme.bodyMedium.fontStyle,
                    ),
                    color: theme.secondaryText,
                    fontSize: 14,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w400,
                    fontStyle: theme.bodyMedium.fontStyle,
                    lineHeight: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ---------- Buttons ----------
              Row(
                children: [
                  // Cancel
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () => Navigator.pop(context),
                      text: 'Cancel',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 48,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 0, 16, 0),
                        color: theme.secondaryBackground,
                        textStyle: theme.titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w600,
                            fontStyle: theme.titleSmall.fontStyle,
                          ),
                          color: theme.primaryText,
                          fontSize: 15,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle: theme.titleSmall.fontStyle,
                        ),
                        elevation: 0,
                        borderSide: BorderSide(
                          color: theme.alternate,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Logout
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async {
                        // Sign out first
                        GoRouter.of(context).prepareAuthEvent();
                        await authManager.signOut();
                        GoRouter.of(context).clearRedirectLocation();

                        // Then navigate to Welcome
                        if (!context.mounted) return;
                        context.goNamedAuth(
                          WelcomeWidget.routeName,
                          context.mounted,
                        );
                      },
                      text: 'Log out',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 48,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 0, 16, 0),
                        color: theme.error,
                        textStyle: theme.titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700,
                            fontStyle: theme.titleSmall.fontStyle,
                          ),
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w700,
                          fontStyle: theme.titleSmall.fontStyle,
                        ),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 250.ms)
          .moveY(begin: 40, end: 0),
    );
  }
}