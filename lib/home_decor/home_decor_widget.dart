import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'home_decor_model.dart';
export 'home_decor_model.dart';

class HomeDecorWidget extends StatefulWidget {
  const HomeDecorWidget({super.key});

  static String routeName = 'HomeDecor';
  static String routePath = '/HomeDecor';

  @override
  State<HomeDecorWidget> createState() => _HomeDecorWidgetState();
}

class _HomeDecorWidgetState extends State<HomeDecorWidget> {
  late HomeDecorModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // ------------------------------------------------------------
  // Every Home Decor subcategory. Adding a new one = one line.
  // Every tile routes to AddProductWidget with FFAppState set.
  // ------------------------------------------------------------
  static const List<_Sub> _subs = [
    _Sub(
      label: 'Lighting',
      subtitle: 'Lamps, bulbs, chandeliers',
      icon: Icons.lightbulb_outline_rounded,
    ),
    _Sub(
      label: 'Wall Art',
      subtitle: 'Frames, posters, decals',
      icon: Icons.image_outlined,
    ),
    _Sub(
      label: 'Furniture',
      subtitle: 'Sofas, chairs, tables',
      icon: Icons.chair_rounded,
    ),
    _Sub(
      label: 'Bedding',
      subtitle: 'Sheets, duvets, pillows',
      icon: Icons.bed_rounded,
    ),
    _Sub(
      label: 'Rugs & Carpets',
      subtitle: 'Area rugs, runners, mats',
      icon: Icons.texture_rounded,
    ),
    _Sub(
      label: 'Curtains & Blinds',
      subtitle: 'Window treatments',
      icon: Icons.blinds_rounded,
    ),
    _Sub(
      label: 'Kitchen & Dining',
      subtitle: 'Cookware, dishes, utensils',
      icon: Icons.restaurant_rounded,
    ),
    _Sub(
      label: 'Storage & Organizers',
      subtitle: 'Baskets, shelves, boxes',
      icon: Icons.inventory_2_outlined,
    ),
    _Sub(
      label: 'Bathroom',
      subtitle: 'Towels, mats, accessories',
      icon: Icons.bathtub_rounded,
    ),
    _Sub(
      label: 'Outdoor & Garden',
      subtitle: 'Planters, patio, décor',
      icon: Icons.yard_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeDecorModel());
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'HomeDecor'});
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
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              _buildHeader(context),

              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 4),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: theme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Choose a category',
                      style: theme.titleMedium.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FontWeight.w700,
                          fontStyle: theme.titleMedium.fontStyle,
                        ),
                        color: theme.primaryText,
                        fontSize: 16,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w700,
                        fontStyle: theme.titleMedium.fontStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 14),
                child: Text(
                  'Tap a category to start adding your product.',
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
              ),

              Expanded(
                child: ListView.separated(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
                  itemCount: _subs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _subTile(context, _subs[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _buildHeader(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(0, topPad + 8, 0, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primary, const Color(0xFF053020)],
          stops: const [0, 1],
          begin: AlignmentDirectional(0, -1),
          end: AlignmentDirectional(0, 1),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 16, 0),
        child: Row(
          children: [
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 24,
              borderWidth: 1,
              buttonSize: 44,
              fillColor: Colors.white.withOpacity(0.15),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Home Decor',
                  style: theme.titleLarge.override(
                    font: GoogleFonts.interTight(
                      fontWeight: FontWeight.w700,
                      fontStyle: theme.titleLarge.fontStyle,
                    ),
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
                    fontStyle: theme.titleLarge.fontStyle,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_subs.length} categories',
                  style: theme.bodySmall.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontStyle: theme.bodySmall.fontStyle,
                    ),
                    color: Colors.white70,
                    fontSize: 11,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w400,
                    fontStyle: theme.bodySmall.fontStyle,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const SizedBox(width: 44),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ONE SUBCATEGORY TILE
  // ============================================================
  Widget _subTile(BuildContext context, _Sub sub) {
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        logFirebaseEvent('HOME_DECOR_subcategory_ON_TAP');

        FFAppState().categories = sub.label;
        safeSetState(() {});

        try {
          context.pushNamed(
            AddProductWidget.routeName,
            extra: <String, dynamic>{
              '__transition_info__': TransitionInfo(
                hasTransition: true,
                transitionType: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 250),
              ),
            },
          );
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot open Add Product')),
          );
        }
      },
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.alternate, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(sub.icon, color: theme.primary, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sub.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.bodyLarge.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle: theme.bodyLarge.fontStyle,
                      ),
                      color: theme.primaryText,
                      fontSize: 14,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle: theme.bodyLarge.fontStyle,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.bodySmall.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontStyle: theme.bodySmall.fontStyle,
                      ),
                      color: theme.secondaryText,
                      fontSize: 11,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w400,
                      fontStyle: theme.bodySmall.fontStyle,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.secondaryText,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DATA MODEL
// ============================================================
class _Sub {
  final String label;
  final String subtitle;
  final IconData icon;

  const _Sub({
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}