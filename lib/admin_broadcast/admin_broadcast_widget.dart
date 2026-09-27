import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/internationalization.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_broadcast_model.dart';
export 'admin_broadcast_model.dart';

class AdminBroadcastWidget extends StatefulWidget {
  const AdminBroadcastWidget({super.key});

  static String routeName = 'AdminBroadcast';
  static String routePath = '/adminBroadcast';

  @override
  State<AdminBroadcastWidget> createState() => _AdminBroadcastWidgetState();
}

class _AdminBroadcastWidgetState extends State<AdminBroadcastWidget> {
  late AdminBroadcastModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF3B82F6);

  static const List<Map<String, dynamic>> _templates = [
    {
      'type': 'promo',
      'icon': Icons.local_offer_rounded,
      'color': kAmber,
      'title': 'ab_tpl_promo_title',
      'body': 'ab_tpl_promo_body',
    },
    {
      'type': 'info',
      'icon': Icons.info_outline_rounded,
      'color': kBlue,
      'title': 'ab_tpl_info_title',
      'body': 'ab_tpl_info_body',
    },
    {
      'type': 'alert',
      'icon': Icons.warning_amber_rounded,
      'color': kRed,
      'title': 'ab_tpl_alert_title',
      'body': 'ab_tpl_alert_body',
    },
    {
      'type': 'info',
      'icon': Icons.celebration_rounded,
      'color': kGreen,
      'title': 'ab_tpl_welcome_title',
      'body': 'ab_tpl_welcome_body',
    },
  ];

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
    _model = createModel(context, () => AdminBroadcastModel());
    _model.titleController ??= TextEditingController();
    _model.titleFocusNode ??= FocusNode();
    _model.bodyController ??= TextEditingController();
    _model.bodyFocusNode ??= FocusNode();
    _model.selectedType = 'info';
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(FFLocalizations.of(context).getText('ab_section_templates')),
                      const SizedBox(height: 10),
                      _buildTemplates(),
                      const SizedBox(height: 24),
                      _buildSectionTitle(FFLocalizations.of(context).getText('ab_section_type')),
                      const SizedBox(height: 10),
                      _buildTypeChips(),
                      const SizedBox(height: 24),
                      _buildSectionTitle(FFLocalizations.of(context).getText('ab_section_title')),
                      const SizedBox(height: 8),
                      _buildTitleField(),
                      const SizedBox(height: 20),
                      _buildSectionTitle(FFLocalizations.of(context).getText('ab_section_message')),
                      const SizedBox(height: 8),
                      _buildBodyField(),
                      const SizedBox(height: 24),
                      _buildPreview(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              _buildSendBar(),
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
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 22),
            onPressed: () => context.safePop(),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(FFLocalizations.of(context).getText('ab_header_title'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 2),
              Text(FFLocalizations.of(context).getText('ab_header_sub'),
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.campaign_outlined, color: Colors.white, size: 12),
                const SizedBox(width: 4),
                Text(FFLocalizations.of(context).getText('ab_badge_all'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.6,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: kGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: _text,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // TEMPLATES
  // ═══════════════════════════════════════════════════════════
  Widget _buildTemplates() {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _templates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final t = _templates[i];
          final color = t['color'] as Color;
          return GestureDetector(
            onTap: () {
              _model.titleController?.text =
                  FFLocalizations.of(context).getText(t['title'] as String);
              _model.bodyController?.text =
                  FFLocalizations.of(context).getText(t['body'] as String);
              _model.selectedType = t['type'] as String;
              safeSetState(() {});
            },
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _border),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      t['icon'] as IconData,
                      color: color,
                      size: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    FFLocalizations.of(context)
                        .getText(t['title'] as String)
                        .split('—')
                        .first
                        .trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _text,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // TYPE CHIPS
  // ═══════════════════════════════════════════════════════════
  Widget _buildTypeChips() {
    final types = [
      ('info', FFLocalizations.of(context).getText('ab_type_info'), kBlue, Icons.info_outline_rounded),
      ('promo', FFLocalizations.of(context).getText('ab_type_promo'), kAmber, Icons.local_offer_rounded),
      ('alert', FFLocalizations.of(context).getText('ab_type_alert'), kRed, Icons.warning_amber_rounded),
    ];

    return Row(
      children: types.map((t) {
        final isActive = _model.selectedType == t.$1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: t.$1 == 'alert' ? 0 : 8,
            ),
            child: GestureDetector(
              onTap: () =>
                  safeSetState(() => _model.selectedType = t.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 46,
                decoration: BoxDecoration(
                  color: isActive ? t.$3 : _card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive ? t.$3 : _border,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      t.$4,
                      color: isActive ? Colors.white : t.$3,
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      t.$2,
                      style: TextStyle(
                        color: isActive ? Colors.white : _text,
                        fontSize: 13,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // FIELDS
  // ═══════════════════════════════════════════════════════════
  Widget _buildTitleField() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: TextField(
        controller: _model.titleController,
        focusNode: _model.titleFocusNode,
        maxLength: 80,
        style: TextStyle(color: _text, fontSize: 14.5),
        cursorColor: kGreen,
        decoration: InputDecoration(
          isDense: true,
          hintText: FFLocalizations.of(context).getText('ab_title_hint'),
          hintStyle: TextStyle(color: _muted, fontSize: 14),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsetsDirectional.fromSTEB(14, 16, 14, 16),
          counterStyle: TextStyle(color: _muted, fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildBodyField() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: TextField(
        controller: _model.bodyController,
        focusNode: _model.bodyFocusNode,
        maxLines: 5,
        minLines: 4,
        maxLength: 300,
        style: TextStyle(color: _text, fontSize: 14, height: 1.4),
        cursorColor: kGreen,
        decoration: InputDecoration(
          isDense: true,
          hintText: FFLocalizations.of(context).getText('ab_body_hint'),
          hintStyle: TextStyle(color: _muted, fontSize: 14),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsetsDirectional.fromSTEB(14, 16, 14, 16),
          counterStyle: TextStyle(color: _muted, fontSize: 11),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PREVIEW
  // ═══════════════════════════════════════════════════════════
  Widget _buildPreview() {
    final title = _model.titleController?.text.trim() ?? '';
    final body = _model.bodyController?.text.trim() ?? '';
    if (title.isEmpty && body.isEmpty) return const SizedBox.shrink();

    final type = _model.selectedType ?? 'info';
    final color = type == 'promo'
        ? kAmber
        : type == 'alert'
            ? kRed
            : kBlue;
    final icon = type == 'promo'
        ? Icons.local_offer_rounded
        : type == 'alert'
            ? Icons.warning_amber_rounded
            : Icons.info_outline_rounded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(FFLocalizations.of(context).getText('ab_section_preview')),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isEmpty
                          ? FFLocalizations.of(context).getText('ab_preview_no_title')
                          : title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: title.isEmpty ? _muted : _text,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        body,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _muted,
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      FFLocalizations.of(context).getText('ab_preview_just_now'),
                      style: TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SEND BAR
  // ═══════════════════════════════════════════════════════════
  Widget _buildSendBar() {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: _card,
        border: Border(top: BorderSide(color: _border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: _model.isSending ? null : _sendBroadcast,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: _model.isSending
                ? kGreen.withOpacity(0.5)
                : kGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: _model.isSending
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.send_rounded,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        FFLocalizations.of(context).getText('ab_send_all'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SEND LOGIC
  // ═══════════════════════════════════════════════════════════
  Future<void> _sendBroadcast() async {
    final title = _model.titleController?.text.trim() ?? '';
    final body = _model.bodyController?.text.trim() ?? '';

    if (title.isEmpty) {
      _snack(FFLocalizations.of(context).getText('ab_error_title'), error: true);
      return;
    }
    if (body.isEmpty) {
      _snack(FFLocalizations.of(context).getText('ab_error_body'), error: true);
      return;
    }

    // Confirm
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _card,
        title: Text(
          FFLocalizations.of(context).getText('ab_confirm_title'),
          style: TextStyle(color: _text, fontWeight: FontWeight.w700),
        ),
        content: Text(
          FFLocalizations.of(context).getText('ab_confirm_body'),
          style: TextStyle(color: _muted, fontSize: 13.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(FFLocalizations.of(context).getText('ab_confirm_cancel'), style: TextStyle(color: _muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              FFLocalizations.of(context).getText('ab_confirm_send'),
              style: TextStyle(
                color: kGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    safeSetState(() => _model.isSending = true);

    try {
      // 1. Fetch all users (batched, limited to first 500)
      final usersSnap = await FirebaseFirestore.instance
          .collection('users')
          .limit(500)
          .get();

      if (usersSnap.docs.isEmpty) {
        if (!mounted) return;
        _snack(FFLocalizations.of(context).getText('ab_no_users'), error: true);
        safeSetState(() => _model.isSending = false);
        return;
      }

      // 2. Write one notification doc per user (batched in chunks of 500)
      final batch = FirebaseFirestore.instance.batch();
      final now = FieldValue.serverTimestamp();

      for (final userDoc in usersSnap.docs) {
        final ref = FirebaseFirestore.instance
            .collection('notifications')
            .doc();
        batch.set(ref, {
          'title': title,
          'notification_text': body,
          'user_ref': userDoc.reference,
          'is_read': false,
          'created_time': now,
          'date': now,
          'avater': '',
          'product_id': '',
          'type': _model.selectedType ?? 'info',
          'is_broadcast': true,
        });
      }

      await batch.commit();

      if (!mounted) return;
      safeSetState(() => _model.isSending = false);

      _snack('${FFLocalizations.of(context).getText('ab_sent_prefix')}${usersSnap.docs.length}${FFLocalizations.of(context).getText('ab_sent_suffix')}');

      // Clear form
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      context.safePop();
    } catch (e) {
      if (!mounted) return;
      safeSetState(() => _model.isSending = false);
      _snack('${FFLocalizations.of(context).getText('ab_failed')}$e', error: true);
    }
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
}
