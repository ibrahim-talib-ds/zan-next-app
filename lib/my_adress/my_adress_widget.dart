import '/auth/firebase_auth/auth_util.dart';
import '/services/api_client.dart' as zannext_api;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_adress_model.dart';
export 'my_adress_model.dart';

/// My Addresses — 100% Postgres via GET/DELETE /addresses.
class MyAdressWidget extends StatefulWidget {
  const MyAdressWidget({super.key});

  static String routeName = 'myAdress';
  static String routePath = '/myAdress';

  @override
  State<MyAdressWidget> createState() => _MyAdressWidgetState();
}

class _MyAdressWidgetState extends State<MyAdressWidget> {
  late MyAdressModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _addresses = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyAdressModel());
    _load();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _s(Map m, List<String> keys, [String fb = '']) {
    for (final k in keys) {
      final v = m[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return fb;
  }

  Future<void> _load() async {
    if (currentUserUid.isEmpty) {
      if (mounted) safeSetState(() => _loading = false);
      return;
    }
    try {
      final raw =
          await zannext_api.ApiClient.get('/addresses?user_id=$currentUserUid');
      final list =
          (raw as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
      _addresses = list;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) safeSetState(() => _loading = false);
  }

  Future<void> _deleteOne(Map<String, dynamic> a) async {
    final id = _s(a, ['id']);
    if (id.isEmpty) return;
    try {
      await zannext_api.ApiClient.delete('/addresses/$id');
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Address deleted'),
        behavior: SnackBarBehavior.floating,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not delete: $e'),
        backgroundColor: const Color(0xFFDC0F0F),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<bool> _confirmDelete(Map<String, dynamic> a) async {
    final theme = FlutterFlowTheme.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: theme.secondaryBackground,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text('Delete this address?',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            content: Text(_s(a, ['label', 'city'], 'This address'),
                style: TextStyle(
                    color: theme.secondaryText, fontSize: 13, height: 1.4)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Keep',
                    style: TextStyle(
                        color: theme.secondaryText,
                        fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete',
                    style: TextStyle(
                        color: Color(0xFFDC0F0F),
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ) ??
        false;
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
              Expanded(
                child: currentUserUid.isEmpty
                    ? _emptyState(
                        context,
                        'Sign in to manage your addresses',
                        Icons.lock_outline_rounded,
                      )
                    : _buildAddressList(context),
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
      padding: EdgeInsetsDirectional.fromSTEB(0, topPad + 8, 0, 14),
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
                  'My Addresses',
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
                  'Manage your delivery locations',
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

  Widget _buildAddressList(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primary, const Color(0xFF053020)],
                stops: const [0, 1],
                begin: AlignmentDirectional(-1, -1),
                end: AlignmentDirectional(1, 1),
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withOpacity(0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Multiple addresses',
                        style: theme.titleMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700,
                            fontStyle: theme.titleMedium.fontStyle,
                          ),
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w700,
                          fontStyle: theme.titleMedium.fontStyle,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add multiple addresses for faster checkout',
                        style: theme.bodySmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontStyle: theme.bodySmall.fontStyle,
                          ),
                          color: Colors.white70,
                          fontSize: 12,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                          fontStyle: theme.bodySmall.fontStyle,
                          lineHeight: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildAddressesBody(context),
          const SizedBox(height: 20),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              await context.pushNamed(
                AddNewadressWidget.routeName,
                extra: <String, dynamic>{
                  '__transition_info__': TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 250),
                  ),
                },
              );
              _load(); // refresh after returning from AddNewadress
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: theme.primary,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: theme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Add Another Address',
                    style: theme.titleMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FontWeight.w700,
                        fontStyle: theme.titleMedium.fontStyle,
                      ),
                      color: theme.primary,
                      fontSize: 15,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                      fontStyle: theme.titleMedium.fontStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressesBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    if (_loading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
            ),
          ),
        ),
      );
    }
    if (_error != null) {
      return _emptyState(context, 'Could not load your addresses',
          Icons.error_outline_rounded);
    }
    if (_addresses.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_outlined,
                color: theme.secondaryText, size: 44),
            const SizedBox(height: 12),
            Text(
              'No addresses saved yet',
              style: theme.titleMedium.override(
                font: GoogleFonts.interTight(
                  fontWeight: FontWeight.w600,
                  fontStyle: theme.titleMedium.fontStyle,
                ),
                color: theme.primaryText,
                fontSize: 15,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                fontStyle: theme.titleMedium.fontStyle,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add your first delivery address below',
              textAlign: TextAlign.center,
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
      );
    }

    return Column(
      children: _addresses
          .map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _addressCard(context, a),
              ))
          .toList(),
    );
  }

  Widget _addressCard(BuildContext context, Map<String, dynamic> a) {
    final theme = FlutterFlowTheme.of(context);

    final lineParts = <String>[
      _s(a, ['label']),
      _s(a, ['district']),
      _s(a, ['street_address', 'streetAddress']),
      _s(a, ['house_no', 'houseNo']),
    ].where((s) => s.isNotEmpty).toList();
    final fullAddress = lineParts.join(', ');
    final city = _s(a, ['city']);
    final secondParts = <String>[
      _s(a, ['landmark']),
      _s(a, ['phone']),
    ].where((s) => s.isNotEmpty).toList();
    final secondLine = secondParts.join(' · ');

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.home_rounded,
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
                      fullAddress.isEmpty ? 'Address' : fullAddress,
                      style: theme.bodyLarge.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontStyle: theme.bodyLarge.fontStyle,
                        ),
                        color: theme.primaryText,
                        fontSize: 14,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w700,
                        fontStyle: theme.bodyLarge.fontStyle,
                        lineHeight: 1.3,
                      ),
                    ),
                    if (city.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(city,
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 12)),
                    ],
                    if (secondLine.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.phone_outlined,
                              color: theme.secondaryText, size: 14),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              secondLine,
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
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  final ok = await _confirmDelete(a);
                  if (ok) await _deleteOne(a);
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC0F0F).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFDC0F0F),
                    size: 17,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context, String message, IconData icon) {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: theme.primary,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontStyle: theme.bodyMedium.fontStyle,
                ),
                color: theme.secondaryText,
                fontSize: 14,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
                fontStyle: theme.bodyMedium.fontStyle,
                lineHeight: 1.5,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: _load, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
