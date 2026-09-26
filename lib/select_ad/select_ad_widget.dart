import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'select_ad_model.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/admin_category/admin_category_editor.dart';
export 'select_ad_model.dart';

class SelectAdWidget extends StatefulWidget {
  const SelectAdWidget({super.key});

  static String routeName = 'SelectAd';
  static String routePath = '/selectAd';

  @override
  State<SelectAdWidget> createState() => _SelectAdWidgetState();
}

class _SelectAdWidgetState extends State<SelectAdWidget> {
  late SelectAdModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<_Category> _categories = [
    _Category(
      label: 'Fashion & Clothing',
      icon: Icons.checkroom_rounded,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_MNx0TnozvbP_hpY-OfWJLzNQYRc_ZHV87A&s',
      routeName: 'Fashion',
    ),
    _Category(
      label: 'Shoes & Footwear',
      icon: Icons.hiking_rounded,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSghdJuyTosDFdp-KDY_6eF8oTXYp1nLVZ9RA&s',
      routeName: 'Footwear',
    ),
    _Category(
      label: 'Electronics',
      icon: Icons.devices_other_rounded,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvxPTAV_Zp5cX1zooDqNeCFG992bQdgauCUg&s',
      routeName: 'Electronics',
    ),
    _Category(
      label: 'Beauty & Care',
      icon: Icons.spa_rounded,
      imageUrl:
          'https://img.freepik.com/free-psd/luxurious-ornate-blue-glass-perfume-bottle-with-golden-accents_84443-76575.jpg',
      routeName: 'Beauty',
    ),
    _Category(
      label: 'Home Decor',
      icon: Icons.chair_rounded,
      imageUrl:
          'https://media.istockphoto.com/id/1310577216/photo/large-leaf-house-plant-monstera-deliciosa-in-a-gray-pot-on-a-white-background-in-a-light.jpg',
      routeName: 'HomeDecor',
    ),
    _Category(
      label: 'Groceries',
      icon: Icons.local_grocery_store_rounded,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrohkCpdJtrvwev9pLMZNODzMdIdEtsai5kg&s',
      routeName: 'Groceries',
    ),
    _Category(
      label: 'Smart Tech',
      icon: Icons.smart_toy_rounded,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRK6vV3roYEphS0nCBEYhAXpPFUmJUpANg-nQ&s',
      routeName: 'SmartTech',
    ),
    _Category(
      label: 'Sports Gear',
      icon: Icons.sports_soccer_rounded,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT17elfw89hmAivC6re0vzkA7fdjEzbsxR95g&s',
      routeName: 'SportsGear',
    ),
    _Category(
      label: 'Watches',
      icon: Icons.watch_rounded,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScrc7Z6TXas2R9p8ZsI-ZqrzHNLfpTl3jXgw&s',
      routeName: 'Watches',
    ),
    _Category(
      label: 'Kids & Toys',
      icon: Icons.toys_rounded,
      imageUrl:
          'https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDI1LTA3L3NyLWltYWdlLTA1MDYyNS1nbGExMi1zLTEyNS1tY2xjc29nZy5qcGc.jpg',
      routeName: 'KidsToys',
    ),
    _Category(
      label: 'Health',
      icon: Icons.health_and_safety_rounded,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLh9zI6GUxFuOeqCyURfSVhnsG9hchXTWJXw&s',
      routeName: 'Health',
    ),
    _Category(
      label: 'Office Supply',
      icon: Icons.business_center_rounded,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkC2rcmlfNZ0CuQxBvzb-6vjMon1lMdj3ioQ&s',
      routeName: 'OfficeSupply',
    ),
    _Category(
      label: 'Automotive',
      icon: Icons.directions_car_rounded,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvzUneT1fnPA_C9W26Xx354-du-pdn-SQUgQ&s',
      routeName: 'Automotive',
    ),
    _Category(
      label: 'Appliances',
      icon: Icons.kitchen_rounded,
      imageUrl:
          'https://png.pngtree.com/png-clipart/20240227/original/pngtree-white-blender-png-image_14434219.png',
      routeName: 'Appliances',
    ),
    _Category(
      label: 'Jewelry',
      icon: Icons.diamond_rounded,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-EVyFhDb-oeT9GJUP9ZasjQWtPkvaA4bhow&s',
      routeName: 'Jewelry',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectAdModel());
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'SelectAd'});
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
                  'Pick where your product belongs — buyers will find it faster.',
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
                child: StreamBuilder<Map<String, Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('category_config')
                      .snapshots()
                      .map((snap) {
                    final map = <String, Map<String, dynamic>>{};
                    for (final doc in snap.docs) {
                      map[doc.id] = doc.data();
                    }
                    return map;
                  }),
                  builder: (context, overrideSnap) {
                    final overrides = overrideSnap.data ?? {};
                    return ListView.separated(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final override = overrides[cat.label];
                        return _categoryTile(
                          context,
                          cat,
                          overrideImage: override?['image_url'] as String?,
                          overrideLabel: override?['label'] as String?,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            Text(
              'Post Your Ad',
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
            const Spacer(),
            const SizedBox(width: 44),
          ],
        ),
      ),
    );
  }

  Widget _categoryTile(
    BuildContext context,
    _Category cat, {
    String? overrideImage,
    String? overrideLabel,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final displayImage = overrideImage ?? cat.imageUrl;
    final displayLabel = overrideLabel ?? cat.label;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        final isAdmin = valueOrDefault<bool>(
                currentUserDocument?.isAdmin, false) ==
            true;

        if (isAdmin) {
          await _showAdminCategoryMenu(displayLabel, displayImage, displayLabel);
          return;
        }

        logFirebaseEvent('SELECT_AD_category_ON_TAP');
        try {
          context.pushNamed(
            cat.routeName,
            extra: <String, dynamic>{
              '__transition_info__': TransitionInfo(
                hasTransition: true,
                transitionType: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 250),
              ),
            },
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cannot open ${cat.label}')),
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
                color: theme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                          displayImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(cat.icon, color: theme.primary, size: 26);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayLabel,
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
                    'Tap to choose subcategory',
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

  // ═══════════════════════════════════════════════════════════
  // ADMIN: Category menu (Edit / Continue)
  // ═══════════════════════════════════════════════════════════
  Future<void> _showAdminCategoryMenu(
    String categoryKey,
    String currentImage,
    String currentLabel,
  ) async {
    final theme = FlutterFlowTheme.of(context);

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44, height: 4,
              decoration: BoxDecoration(
                color: theme.alternate,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              categoryKey,
              style: TextStyle(color: theme.primaryText, fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              'What do you want to do?',
              style: TextStyle(color: theme.secondaryText, fontSize: 12),
            ),
            const SizedBox(height: 20),
            _adminMenuOption(
              ctx,
              icon: Icons.edit_rounded,
              label: 'Edit this category',
              subtitle: 'Change image or name',
              color: theme.primary,
              value: 'edit',
              theme: theme,
            ),
            const SizedBox(height: 10),
            _adminMenuOption(
              ctx,
              icon: Icons.arrow_forward_rounded,
              label: 'Continue to page',
              subtitle: 'Open category normally',
              color: const Color(0xFF3B82F6),
              value: 'continue',
              theme: theme,
            ),
          ],
        ),
      ),
    );

    if (!mounted || action == null) return;

    if (action == 'edit') {
      await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AdminCategoryEditor(
          categoryKey: categoryKey,
          currentImage: currentImage,
          currentLabel: currentLabel,
          currentRoute: categoryKey,
        ),
      );
    } else if (action == 'continue') {
      // Navigate using the stored route
      final cat = _categories.firstWhere(
        (c) => c.label == categoryKey,
        orElse: () => _categories.first,
      );
      try {
        context.pushNamed(
          cat.routeName,
          extra: <String, dynamic>{
            '__transition_info__': TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 250),
            ),
          },
        );
      } catch (_) {}
    }
  }

  Widget _adminMenuOption(
    BuildContext ctx, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required String value,
    required FlutterFlowTheme theme,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pop(ctx, value),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(color: theme.primaryText, fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(color: theme.secondaryText, fontSize: 11.5)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color, size: 22),
          ],
        ),
      ),
    );
  }
}

class _Category {
  final String label;
  final IconData icon;
  final String imageUrl;
  final String routeName;

  const _Category({
    required this.label,
    required this.icon,
    required this.imageUrl,
    required this.routeName,
  });
}
