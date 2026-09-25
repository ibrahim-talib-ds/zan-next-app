import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/logout_widget.dart';
import '/components/dark_light_switch_small_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  static String routeName = 'Profile';
  static String routePath = '/profile';

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);

  // Theme-aware helpers
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF121212) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E7EB);

  String _imgUrl(String? url) {
    final u = (url ?? '').trim();
    if (u.isEmpty) return '';
    return u.startsWith('http://') ? u.replaceFirst('http://', 'https://') : u;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _bg,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserCard(),
                      const SizedBox(height: 16),
                      _buildQuickActions(),
                      const SizedBox(height: 16),
                      _buildDeliveryStatus(),
                      const SizedBox(height: 24),
                      _buildSection('General', [
                        _tile(
                          icon: Icons.person_outline_rounded,
                          title: 'Edit Profile',
                          onTap: () => context.pushNamed(ProfileEditWidget.routeName),
                        ),
                        _tile(
                          icon: Icons.luggage_rounded,
                          title: 'My Orders',
                          onTap: () => context.pushNamed(OrderDetailsWidget.routeName),
                        ),
                        _tile(
                          icon: Icons.favorite_border_rounded,
                          title: 'My Favorites',
                          onTap: () => context.pushNamed(WishlistWidget.routeName),
                        ),
                      ]),
                      const SizedBox(height: 24),
                      _buildSection('Account Settings', [
                        _tile(
                          icon: Icons.location_on_outlined,
                          title: 'Addresses',
                          onTap: () => context.pushNamed(MyAdressWidget.routeName),
                        ),
                        _tile(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          onTap: () => context.pushNamed(NotificationWidget.routeName),
                        ),
                        _tile(
                          icon: Icons.language_outlined,
                          title: 'Language',
                          trailing: 'Swahili',
                          onTap: () => _showLanguageSheet(),
                        ),
                      ]),
                      const SizedBox(height: 24),
                      _buildSection('Other', [
                        _tile(
                          icon: Icons.star_rate_outlined,
                          title: 'Rate the App',
                          onTap: () => context.pushNamed(
                            RatePageWidget.routeName,
                            queryParameters: {
                              'sourceName': serializeParam('review', ParamType.String),
                            }.withoutNulls,
                          ),
                        ),
                        _tile(
                          icon: Icons.person_add_outlined,
                          title: 'Invite Friends',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Share coming soon')),
                            );
                          },
                        ),
                      ]),
                      const SizedBox(height: 24),
                      _buildSection('App & Legal', [
                        _tile(
                          icon: Icons.live_help_outlined,
                          title: 'Help Center',
                          onTap: () => context.pushNamed(HelpCenterWidget.routeName),
                        ),
                        _tile(
                          icon: Icons.info_outlined,
                          title: 'About the App',
                          trailing: '1.02.135',
                          onTap: () => context.pushNamed(AboutAppWidget.routeName),
                        ),
                      ]),
                      const SizedBox(height: 24),
                      // ─── ADMIN ONLY SECTION ───
                      AuthUserStreamWidget(
                        builder: (context) {
                          final isAdmin =
                              valueOrDefault<bool>(
                                    currentUserDocument?.isAdmin,
                                    false,
                                  ) ==
                                  true;
                          if (!isAdmin) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSection('Admin Tools', [
                                _tile(
                                  icon: Icons.support_agent_rounded,
                                  title: 'Support Inbox',
                                  trailing: 'Admin',
                                  onTap: () => context.pushNamed(
                                    AdminSupportInboxWidget.routeName,
                                  ),
                                ),
                                _tile(
                                  icon: Icons.dashboard_customize_outlined,
                                  title: 'Admin Dashboard',
                                  trailing: 'Admin',
                                  onTap: () => context.pushNamed(
                                    AdminDashboardWidget.routeName,
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 24),
                            ],
                          );
                        },
                      ),
                      _buildLogoutButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeader() {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(8, topPad + 8, 16, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreen, kGreenDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 24,
            borderWidth: 1,
            buttonSize: 44,
            fillColor: Colors.white.withOpacity(0.18),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
            onPressed: () => context.safePop(),
          ),
          const Spacer(),
          const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: const DarkLightSwitchSmallWidget(),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // USER CARD
  // ═══════════════════════════════════════════════════════════
  Widget _buildUserCard() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kGreen, kGreenDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(2.5),
              child: Container(
                decoration: BoxDecoration(color: _card, shape: BoxShape.circle),
                padding: const EdgeInsets.all(2),
                child: AuthUserStreamWidget(
                  builder: (context) => ClipOval(
                    child: Image.network(
                      _imgUrl(valueOrDefault<String>(
                        currentUserPhoto,
                        '',
                      )),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.person_rounded,
                        color: _muted,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AuthUserStreamWidget(
                    builder: (context) => Text(
                      currentUserDisplayName.isEmpty
                          ? 'User'
                          : currentUserDisplayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _text,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    valueOrDefault<String>(currentUserEmail, 'no email'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _muted, fontSize: 12.5),
                  ),
                  AuthUserStreamWidget(
                    builder: (context) => Text(
                      valueOrDefault<String>(currentPhoneNumber, ''),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: _muted, fontSize: 12.5),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => context.pushNamed(ProfileEditWidget.routeName),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.edit_rounded, color: kGreen, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // QUICK ACTIONS
  // ═══════════════════════════════════════════════════════════
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _quickAction(
              icon: Icons.add_circle_outline_rounded,
              iconBg: const Color(0xFFE8F5EE),
              iconColor: const Color(0xFF1A6B4A),
              label: 'Add Product',
              onTap: () => context.pushNamed(SelectAdWidget.routeName),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _quickAction(
              icon: Icons.list_alt_rounded,
              iconBg: const Color(0xFFE8F0FF),
              iconColor: const Color(0xFF3D5AFE),
              label: 'My Products',
              onTap: () => context.pushNamed(SellerDashbordWidget.routeName),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _quickAction(
              icon: Icons.local_shipping_outlined,
              iconBg: const Color(0xFFFFF3E0),
              iconColor: const Color(0xFFFF8F00),
              label: 'Orders',
              onTap: () => context.pushNamed(OrderDetailsWidget.routeName),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _text,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // DELIVERY STATUS — real latest order for current user
  // ═══════════════════════════════════════════════════════════
  Widget _buildDeliveryStatus() {
    if (currentUserReference == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<List<OrdersRecord>>(
        stream: queryOrdersRecord(
          queryBuilder: (q) => q
              .where('buyer', isEqualTo: currentUserReference)
              .orderBy('date', descending: true),
          limit: 1,
        ),
        builder: (context, snap) {
          // No order yet → show empty hint
          if (!snap.hasData || snap.data!.isEmpty) {
            return Container(
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _border),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: kGreen.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shopping_bag_outlined,
                        color: kGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'No active orders',
                          style: TextStyle(
                            color: _text,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your orders will appear here',
                          style: TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          final order = snap.data!.first;
          final status = (order.status ?? 'Pending');

          // Status color + icon
          Color statusColor = kGreen;
          IconData statusIcon = Icons.hourglass_top_rounded;
          final lower = status.toLowerCase();
          if (lower.contains('confirm')) {
            statusColor = const Color(0xFF3B82F6);
            statusIcon = Icons.verified_rounded;
          } else if (lower.contains('way') || lower.contains('ship')) {
            statusColor = const Color(0xFFFFB300);
            statusIcon = Icons.delivery_dining_rounded;
          } else if (lower.contains('deliver')) {
            statusColor = kGreen;
            statusIcon = Icons.check_circle_rounded;
          } else if (lower.contains('cancel')) {
            statusColor = const Color(0xFFDC0F0F);
            statusIcon = Icons.cancel_rounded;
          }

          return GestureDetector(
            onTap: () => context.pushNamed(
              OrderDetailsWidget.routeName,
              queryParameters: {
                'initialTab': 'buyer',
              }.withoutNulls,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: statusColor.withOpacity(0.35), width: 1.2),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                status.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          order.productName ?? 'Order',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _text,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          order.address ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: _muted, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: _muted, size: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // BALANCE CARD
  // ═══════════════════════════════════════════════════════════
  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kGreen, kGreenDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kGreen.withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Stack(
          children: [
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -30,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your balance is',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 13,
                      ),
                    ),
                    Container(
                      height: 26,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'ZanNext',
                          style: TextStyle(
                            color: kGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'TZS 17,269',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SECTION CARD
  // ═══════════════════════════════════════════════════════════
  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _border),
            ),
            child: Column(
              children: List.generate(children.length, (i) {
                return Column(
                  children: [
                    children[i],
                    if (i < children.length - 1)
                      Divider(height: 1, color: _border, indent: 60),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    String? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: kGreen, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: _text,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) ...[
              Text(trailing, style: TextStyle(color: _muted, fontSize: 12)),
              const SizedBox(width: 4),
            ],
            Icon(Icons.chevron_right_rounded, color: _muted, size: 20),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // LANGUAGE SHEET (placeholder)
  // ═══════════════════════════════════════════════════════════
  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Language',
                style: TextStyle(
                  color: _text,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 12),
            ListTile(
              title: Text('Swahili', style: TextStyle(color: _text)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('English', style: TextStyle(color: _text)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // LOGOUT
  // ═══════════════════════════════════════════════════════════
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FFButtonWidget(
        onPressed: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: const Color(0x34000000),
            context: context,
            builder: (context) => GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Padding(
                padding: MediaQuery.viewInsetsOf(context),
                child: const LogoutWidget(),
              ),
            ),
          ).then((value) => safeSetState(() {}));
        },
        text: 'Logout',
        icon: const Icon(Icons.logout_rounded, size: 20),
        options: FFButtonOptions(
          width: double.infinity,
          height: 50,
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          iconAlignment: IconAlignment.start,
          iconColor: const Color(0xFFDC0F0F),
          color: const Color(0x1FDC0F0F),
          textStyle: const TextStyle(
            color: Color(0xFFDC0F0F),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
          borderSide: const BorderSide(color: Color(0x33DC0F0F)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
