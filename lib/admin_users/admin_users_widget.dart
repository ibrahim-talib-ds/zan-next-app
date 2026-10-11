import '/auth/firebase_auth/auth_util.dart';
import '/services/api_client.dart' as zannext_api;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'admin_users_model.dart';
export 'admin_users_model.dart';

/// Admin Users — 100% Postgres. List, search, promote/demote admin.
class AdminUsersWidget extends StatefulWidget {
  const AdminUsersWidget({super.key});

  static String routeName = 'adminUsers';
  static String routePath = '/adminUsers';

  @override
  State<AdminUsersWidget> createState() => _AdminUsersWidgetState();
}

class _AdminUsersWidgetState extends State<AdminUsersWidget> {
  late AdminUsersModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);

  List<Map<String, dynamic>> _all = const [];
  List<Map<String, dynamic>> _shown = const [];
  bool _loading = true;
  String? _error;
  String _query = '';

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  String _s(Map m, List<String> keys, [String fb = '']) {
    for (final k in keys) {
      final v = m[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return fb;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminUsersModel());
    _load();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final raw = await zannext_api.ApiClient.get('/users');
      final list = (raw as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
      list.sort((a, b) => _s(a, ['display_name', 'displayName'])
          .toLowerCase()
          .compareTo(_s(b, ['display_name', 'displayName']).toLowerCase()));
      _all = list;
      _applyFilter();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) safeSetState(() => _loading = false);
  }

  void _applyFilter() {
    final q = _query.trim().toLowerCase();
    _shown = q.isEmpty
        ? _all
        : _all.where((u) {
            return _s(u, ['display_name', 'displayName']).toLowerCase().contains(q) ||
                _s(u, ['email']).toLowerCase().contains(q);
          }).toList();
  }

  Future<void> _toggleAdmin(Map<String, dynamic> u) async {
    final id = _s(u, ['id']);
    final name = _s(u, ['display_name', 'displayName'], 'user');
    final isAdmin = u['is_admin'] == true || u['is_admin'].toString() == 'true';
    try {
      await zannext_api.ApiClient.patch('/admin/users/$id',
          body: {'is_admin': !isAdmin});
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isAdmin ? '$name demoted' : '$name promoted to admin'),
        backgroundColor: kGreen,
        behavior: SnackBarBehavior.floating,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed: $e'),
        backgroundColor: kRed,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

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
              _buildSearch(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(8, topPad + 8, 16, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreen, Color(0xFF0A3A22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: Row(
        children: [
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 24,
            borderWidth: 1,
            buttonSize: 44,
            fillColor: Colors.white.withOpacity(0.15),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 22),
            onPressed: () => context.safePop(),
          ),
          const Spacer(),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Users',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            Text('Admin · ${_all.length} total',
                style: TextStyle(color: Colors.white70, fontSize: 11)),
          ]),
          const Spacer(),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: TextField(
          onChanged: (v) => safeSetState(() {
            _query = v;
            _applyFilter();
          }),
          style: TextStyle(color: _text, fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search name or email…',
            hintStyle: TextStyle(color: _muted, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: _muted, size: 20),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsetsDirectional.fromSTEB(0, 14, 12, 14),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
          child: SizedBox(
              width: 36, height: 36,
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                  strokeWidth: 3)));
    }
    if (_error != null) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.error_outline_rounded,
                    color: kRed, size: 44),
                const SizedBox(height: 12),
                Text(_error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 12)),
                const SizedBox(height: 8),
                TextButton(onPressed: _load, child: const Text('Retry')),
              ])));
    }
    if (_shown.isEmpty) {
      return Center(
          child: Text('No users match',
              style: TextStyle(color: _muted, fontSize: 14)));
    }

    return RefreshIndicator(
      color: kGreen,
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
        itemCount: _shown.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final u = _shown[i];
          final name = _s(u, ['display_name', 'displayName'], 'User');
          final email = _s(u, ['email']);
          final photo = _s(u, ['photo_url', 'photoUrl']);
          final isAdmin = u['is_admin'] == true ||
              u['is_admin'].toString() == 'true';
          final isMe = _s(u, ['id']) == currentUserUid;
          final placeholder =
              email.startsWith('deleted_') && email.endsWith('@placeholder.local');

          return Container(
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: isAdmin ? kGreen.withOpacity(0.4) : _border,
                  width: isAdmin ? 1.4 : 1),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                      color: Color(0x1A1B7A4E), shape: BoxShape.circle),
                  clipBehavior: Clip.antiAlias,
                  child: photo.isEmpty
                      ? Icon(Icons.person_rounded, color: kGreen, size: 20)
                      : Image.network(photo,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.person_rounded, color: kGreen, size: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(
                            child: Text(name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: _text,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700))),
                        if (isAdmin) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                                color: kGreen.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text('ADMIN',
                                style: TextStyle(
                                    color: kGreen,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5)),
                          ),
                        ],
                        if (placeholder) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                                color: kAmber.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text('DELETED',
                                style: TextStyle(
                                    color: kAmber,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ]),
                      const SizedBox(height: 3),
                      Text(email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: _muted, fontSize: 12)),
                    ],
                  ),
                ),
                if (!isMe && !placeholder)
                  GestureDetector(
                    onTap: () => _toggleAdmin(u),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: (isAdmin ? kRed : kGreen).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(isAdmin ? 'Demote' : 'Promote',
                          style: TextStyle(
                              color: isAdmin ? kRed : kGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
