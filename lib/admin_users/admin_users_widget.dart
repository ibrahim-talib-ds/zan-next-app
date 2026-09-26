import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_users_model.dart';
export 'admin_users_model.dart';

class AdminUsersWidget extends StatefulWidget {
  const AdminUsersWidget({super.key});
  static String routeName = 'AdminUsers';
  static String routePath = '/adminUsers';
  @override
  State<AdminUsersWidget> createState() => _AdminUsersWidgetState();
}

class _AdminUsersWidgetState extends State<AdminUsersWidget> {
  late AdminUsersModel _model;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kBlue = Color(0xFF3B82F6);
  static const Color kAmber = Color(0xFFFFB300);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _soft   => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFF0F2F5);
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  String _imgUrl(String? url) {
    final u = (url ?? '').trim();
    if (u.isEmpty) return '';
    return u.startsWith('http://') ? u.replaceFirst('http://', 'https://') : u;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminUsersModel());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _header(),
            _searchBar(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .orderBy('created_time', descending: true)
                    .snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                      ),
                    );
                  }
                  var docs = snap.data!.docs;
                  // 🔍 Filter by search query
                  if (_query.isNotEmpty) {
                    final q = _query.toLowerCase();
                    docs = docs.where((doc) {
                      final d = doc.data() as Map<String, dynamic>;
                      final name = (d['display_name'] ?? '').toString().toLowerCase();
                      final email = (d['email'] ?? '').toString().toLowerCase();
                      return name.contains(q) || email.contains(q);
                    }).toList();
                  }
                  if (docs.isEmpty) return _empty();
                  return RefreshIndicator(
                    color: kGreen,
                    onRefresh: () async => safeSetState(() {}),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final doc = docs[i];
                        final d = doc.data() as Map<String, dynamic>;
                        return Dismissible(
                          key: ValueKey('user_${doc.id}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                            decoration: BoxDecoration(
                              color: kRed,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
                                SizedBox(width: 6),
                                Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                              ],
                            ),
                          ),
                          confirmDismiss: (_) => _confirmDelete('user', d['display_name'] ?? 'User'),
                          onDismissed: (_) => _deleteUser(doc),
                          child: _userTile(doc),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 6, 0),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: _muted, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (v) => safeSetState(() => _query = v.trim()),
                style: TextStyle(color: _text, fontSize: 14),
                cursorColor: kGreen,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: 'Search by name or email...',
                  hintStyle: TextStyle(color: _muted, fontSize: 13.5),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            if (_query.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  safeSetState(() => _query = '');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.close_rounded, color: _muted, size: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(8, topPad + 8, 16, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreen, kGreenDeep],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          FlutterFlowIconButton(
            borderRadius: 24, buttonSize: 44,
            fillColor: Colors.white.withOpacity(0.18),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('All Users', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(height: 2),
              Text('Swipe left to delete', style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _userTile(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final name = (d['display_name'] ?? 'User').toString();
    final email = (d['email'] ?? '').toString();
    final photo = _imgUrl(d['photo_url']?.toString());
    final isAdmin = d['is_admin'] == true;

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(color: _soft, shape: BoxShape.circle),
            clipBehavior: Clip.antiAlias,
            child: photo.isEmpty
                ? Icon(Icons.person_rounded, color: _muted, size: 22)
                : Image.network(photo, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.person_rounded, color: _muted, size: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _text, fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(color: kAmber.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                        child: const Text('ADMIN', style: TextStyle(color: kAmber, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(email, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: _muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(String kind, String name) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete $kind?', style: TextStyle(color: _text, fontWeight: FontWeight.w800, fontSize: 16)),
        content: Text('"$name" will be permanently removed from Firestore.', style: TextStyle(color: _muted, fontSize: 13, height: 1.4)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: _muted, fontWeight: FontWeight.w600))),
          TextButton(onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: kRed, fontWeight: FontWeight.w800))),
        ],
      ),
    ) ?? false;
  }

  Future<void> _deleteUser(DocumentSnapshot doc) async {
    try {
      await doc.reference.delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User deleted'),
        backgroundColor: kGreen, behavior: SnackBarBehavior.floating,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not delete: $e'),
        backgroundColor: kRed, behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: kGreen.withOpacity(0.10), shape: BoxShape.circle),
            child: const Icon(Icons.people_outline, color: kGreen, size: 36),
          ),
          const SizedBox(height: 16),
          Text('No users yet', style: TextStyle(color: _text, fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
