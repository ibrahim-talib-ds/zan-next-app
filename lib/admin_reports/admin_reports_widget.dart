import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/internationalization.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_reports_model.dart';
export 'admin_reports_model.dart';

class AdminReportsWidget extends StatefulWidget {
  const AdminReportsWidget({super.key});

  static String routeName = 'AdminReports';
  static String routePath = '/adminReports';

  @override
  State<AdminReportsWidget> createState() => _AdminReportsWidgetState();
}

class _AdminReportsWidgetState extends State<AdminReportsWidget> {
  late AdminReportsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF3B82F6);
  static const Color kPurple = Color(0xFFAB47D0);
  static const Color kMuted = Color(0xFF9CA3AF);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _soft   => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFF0F2F5);
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminReportsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _bg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterTabs(),
            Expanded(child: _buildReportsList()),
          ],
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
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 22),
            onPressed: () => context.safePop(),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(FFLocalizations.of(context).getText('ar_header_title'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 2),
              Text(FFLocalizations.of(context).getText('ar_header_sub'),
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const Spacer(),
          // Pending count badge
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('reports')
                .where('status', isEqualTo: 'pending')
                .snapshots(),
            builder: (context, snap) {
              final n = snap.data?.docs.length ?? 0;
              if (n == 0) return const SizedBox(width: 44);
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: kRed.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('$n${FFLocalizations.of(context).getText('ar_pending_suffix')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    )),
              );
            },
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // FILTER TABS
  // ═══════════════════════════════════════════════════════════
  Widget _buildFilterTabs() {
    final tabs = [
      ('pending', FFLocalizations.of(context).getText('ar_tab_pending'), kAmber),
      ('resolved', FFLocalizations.of(context).getText('ar_tab_resolved'), kGreen),
      ('dismissed', FFLocalizations.of(context).getText('ar_tab_dismissed'), kMuted),
      ('all', FFLocalizations.of(context).getText('ar_tab_all'), kBlue),
    ];

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 6),
      child: SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tabs.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final t = tabs[i];
            final isActive = _model.activeFilter == t.$1;
            return GestureDetector(
              onTap: () =>
                  safeSetState(() => _model.activeFilter = t.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? t.$3 : _card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? t.$3 : _border,
                    width: 1.4,
                  ),
                ),
                child: Text(
                  t.$2,
                  style: TextStyle(
                    color: isActive ? Colors.white : _text,
                    fontSize: 12.5,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // LIST
  // ═══════════════════════════════════════════════════════════
  Widget _buildReportsList() {
    // If 'all', no status filter
    Query query =
        FirebaseFirestore.instance.collection('reports');
    if (_model.activeFilter != 'all') {
      query = query.where('status', isEqualTo: _model.activeFilter);
    }
    query = query.orderBy('created_at', descending: true).limit(200);

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _state(Icons.error_outline_rounded,
              FFLocalizations.of(context).getText('ar_could_not_load'),
              '${snapshot.error}', kRed);
        }
        if (!snapshot.hasData) {
          return const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                strokeWidth: 3,
              ),
            ),
          );
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return _state(
            Icons.check_circle_outline_rounded,
            _model.activeFilter == 'pending'
                ? FFLocalizations.of(context).getText('ar_empty_pending_title')
                : FFLocalizations.of(context).getText('ar_empty_other_title'),
            _model.activeFilter == 'pending'
                ? FFLocalizations.of(context).getText('ar_empty_pending_sub')
                : FFLocalizations.of(context).getText('ar_empty_other_sub'),
            kGreen,
          );
        }

        return RefreshIndicator(
          color: kGreen,
          onRefresh: () async => safeSetState(() {}),
          child: ListView.separated(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _reportCard(docs[i]),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  // REPORT CARD
  // ═══════════════════════════════════════════════════════════
  Widget _reportCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final priority = (data['priority'] ?? 'low').toString();
    final status = (data['status'] ?? 'pending').toString();
    final reasonLabel = (data['reason_label'] ?? FFLocalizations.of(context).getText('ar_unknown')).toString();
    final reasonId = (data['reason_id'] ?? 'other').toString();
    final notes = (data['notes'] ?? '').toString();
    final reporterName = (data['reporter_name'] ?? FFLocalizations.of(context).getText('ar_anonymous')).toString();
    final targetLabel = (data['target_label'] ?? FFLocalizations.of(context).getText('ar_unknown')).toString();
    final targetType = (data['target_type'] ?? 'product').toString();
    final createdAt = (data['created_at'] as Timestamp?)?.toDate();

    final priorityColor = priority == 'high'
        ? kRed
        : priority == 'medium'
            ? kAmber
            : kBlue;

    final statusColor = status == 'resolved'
        ? kGreen
        : status == 'dismissed'
            ? kMuted
            : kAmber;

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: priority == 'high' && status == 'pending'
              ? kRed.withOpacity(0.4)
              : _border,
          width: priority == 'high' && status == 'pending' ? 1.4 : 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: reason + priority + status
          Row(
            children: [
              _pill(
                '${reasonId == 'fake' ? FFLocalizations.of(context).getText('ar_badge_fake') : priority.toUpperCase()} · $status',
                statusColor,
              ),
              const Spacer(),
              if (createdAt != null)
                Text(
                  _timeAgo(createdAt),
                  style: TextStyle(
                      color: _muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 2: target info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  targetType == 'user'
                      ? Icons.person_outline_rounded
                      : Icons.inventory_2_outlined,
                  color: priorityColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reasonLabel,
                      style: TextStyle(
                        color: _text,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${FFLocalizations.of(context).getText('ar_target_prefix')}$targetLabel',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: _muted, fontSize: 12),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.person_outline_rounded,
                            size: 11, color: _muted),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            '${FFLocalizations.of(context).getText('ar_reported_by_prefix')}$reporterName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: _muted, fontSize: 11.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Row 3: notes (if any)
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: _soft,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                notes,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _text,
                  fontSize: 12.5,
                  height: 1.4,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],

          // Row 4: admin actions
          if (status == 'pending') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _actionBtn(
                    icon: Icons.check_circle_outline_rounded,
                    label: FFLocalizations.of(context).getText('ar_action_resolve'),
                    color: kGreen,
                    onTap: () => _resolve(doc, 'resolved'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _actionBtn(
                    icon: Icons.close_rounded,
                    label: FFLocalizations.of(context).getText('ar_action_dismiss'),
                    color: kMuted,
                    onTap: () => _resolve(doc, 'dismissed'),
                  ),
                ),
                const SizedBox(width: 8),
                _iconAction(
                  icon: Icons.delete_outline_rounded,
                  color: kRed,
                  onTap: () => _deleteTarget(doc),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    color: statusColor, size: 14),
                const SizedBox(width: 5),
                Text(
                  '${FFLocalizations.of(context).getText('ar_marked_prefix')}$status',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════
  Future<void> _resolve(DocumentSnapshot doc, String newStatus) async {
    try {
      await doc.reference.update({
        'status': newStatus,
        'resolved_at': FieldValue.serverTimestamp(),
        'resolved_by': currentUserReference,
        'action_taken': newStatus,
      });
      if (!mounted) return;
      _snack(newStatus == 'resolved'
          ? FFLocalizations.of(context).getText('ar_resolved')
          : FFLocalizations.of(context).getText('ar_dismissed'));
    } catch (e) {
      if (!mounted) return;
      _snack('${FFLocalizations.of(context).getText('ar_failed')}$e', error: true);
    }
  }

  Future<void> _deleteTarget(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final targetRef = data['target_ref'] as DocumentReference?;
    final targetType = (data['target_type'] ?? 'product').toString();

    if (targetRef == null) {
      _snack(FFLocalizations.of(context).getText('ar_target_missing'), error: true);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _card,
        title: Text('${FFLocalizations.of(context).getText('ar_delete_title_prefix')}$targetType${FFLocalizations.of(context).getText('ar_delete_title_suffix')}',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w700,
            )),
        content: Text(
          '${FFLocalizations.of(context).getText('ar_delete_body_prefix')}$targetType${FFLocalizations.of(context).getText('ar_delete_body_suffix')}',
          style: TextStyle(color: _muted, fontSize: 13.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(FFLocalizations.of(context).getText('ar_cancel'), style: TextStyle(color: _muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              FFLocalizations.of(context).getText('ar_delete'),
              style: TextStyle(
                color: kRed,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await targetRef.delete();
      await doc.reference.update({
        'status': 'resolved',
        'resolved_at': FieldValue.serverTimestamp(),
        'resolved_by': currentUserReference,
        'action_taken': 'deleted',
      });
      if (!mounted) return;
      _snack('$targetType${FFLocalizations.of(context).getText('ar_deleted_suffix')}');
    } catch (e) {
      if (!mounted) return;
      _snack('Failed: $e', error: true);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════
  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconAction({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  String _timeAgo(DateTime when) {
    final d = DateTime.now().difference(when);
    if (d.inSeconds < 60) return FFLocalizations.of(context).getText('ar_time_now');
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    if (d.inDays < 7) return '${d.inDays}d';
    return '${when.day}/${when.month}';
  }

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: error ? kRed : kGreen,
    ));
  }

  Widget _state(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 40),
            ),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _text,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 6),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _muted, fontSize: 13, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
