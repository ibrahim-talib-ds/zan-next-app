import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'language_modal_model.dart';
export 'language_modal_model.dart';

class LanguageModalWidget extends StatefulWidget {
  const LanguageModalWidget({super.key});

  @override
  State<LanguageModalWidget> createState() => _LanguageModalWidgetState();
}

class _LanguageModalWidgetState extends State<LanguageModalWidget> {
  late LanguageModalModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LanguageModalModel());

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
    final currentLocale = FFLocalizations.of(context).languageCode;

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
              const SizedBox(height: 20),

              // ---------- Header ----------
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.translate_rounded,
                      color: theme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Language',
                          style: theme.titleLarge.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FontWeight.w700,
                              fontStyle: theme.titleLarge.fontStyle,
                            ),
                            color: theme.primaryText,
                            fontSize: 20,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w700,
                            fontStyle: theme.titleLarge.fontStyle,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Choose your preferred language',
                          style: theme.bodySmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontStyle: theme.bodySmall.fontStyle,
                            ),
                            color: theme.secondaryText,
                            fontSize: 12,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w400,
                            fontStyle: theme.bodySmall.fontStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: theme.primaryBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: theme.primaryText,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ---------- Language options ----------
              _languageTile(
                context,
                label: 'English',
                nativeLabel: 'English',
                flagWidget: _flagUK(),
                isSelected: currentLocale == 'en',
                onTap: () => setAppLanguage(context, 'en'),
              ),
              const SizedBox(height: 10),
              _languageTile(
                context,
                label: 'Swahili',
                nativeLabel: 'Kiswahili',
                flagWidget: _flagTanzania(),
                isSelected: currentLocale == 'sw',
                onTap: () => setAppLanguage(context, 'sw'),
              ),
              const SizedBox(height: 24),

              // ---------- Done button ----------
              FFButtonWidget(
                onPressed: () => Navigator.pop(context),
                text: 'Done',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 52,
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LANGUAGE TILE
  // ============================================================
  Widget _languageTile(
    BuildContext context, {
    required String label,
    required String nativeLabel,
    required Widget flagWidget,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primary.withOpacity(0.10)
              : theme.primaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.primary : theme.alternate,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.alternate,
                  width: 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: flagWidget,
            ),
            const SizedBox(width: 14),

            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: theme.bodyLarge.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontStyle: theme.bodyLarge.fontStyle,
                      ),
                      color: theme.primaryText,
                      fontSize: 15,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                      fontStyle: theme.bodyLarge.fontStyle,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    nativeLabel,
                    style: theme.bodySmall.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontStyle: theme.bodySmall.fontStyle,
                      ),
                      color: theme.secondaryText,
                      fontSize: 12,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w400,
                      fontStyle: theme.bodySmall.fontStyle,
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? theme.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? theme.primary : theme.alternate,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FLAGS — drawn in pure Flutter, no images
  // ============================================================
  Widget _flagUK() {
    // Simplified Union Jack — clean at small sizes
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: CustomPaint(
        painter: _UnionJackPainter(),
      ),
    );
  }

  Widget _flagTanzania() {
    // Tanzania: green top, black middle band, blue bottom,
    // yellow borders on the diagonal.
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1EB53A), // green
            Color(0xFF1EB53A),
            Color(0xFFFFCD00),
            Color(0xFF000000),
            Color(0xFF000000),
            Color(0xFFFFCD00),
            Color(0xFF00A3DD), // blue
            Color(0xFF00A3DD),
          ],
          stops: [0.0, 0.36, 0.42, 0.46, 0.54, 0.58, 0.64, 1.0],
        ),
      ),
    );
  }
}

// ============================================================
// UNION JACK PAINTER
// ============================================================
class _UnionJackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background — blue
    final blue = Paint()..color = const Color(0xFF012169);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), blue);

    // White diagonals
    final white = Paint()
      ..color = Colors.white
      ..strokeWidth = h * 0.20
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, 0), Offset(w, h), white);
    canvas.drawLine(Offset(w, 0), Offset(0, h), white);

    // Red diagonals (thinner)
    final red = Paint()
      ..color = const Color(0xFFC8102E)
      ..strokeWidth = h * 0.08
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, 0), Offset(w, h), red);
    canvas.drawLine(Offset(w, 0), Offset(0, h), red);

    // White cross
    final whiteCross = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, h * 0.35, w, h * 0.30), whiteCross);
    canvas.drawRect(Rect.fromLTWH(w * 0.40, 0, w * 0.20, h), whiteCross);

    // Red cross
    final redCross = Paint()..color = const Color(0xFFC8102E);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.42, w, h * 0.16), redCross);
    canvas.drawRect(Rect.fromLTWH(w * 0.45, 0, w * 0.10, h), redCross);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}