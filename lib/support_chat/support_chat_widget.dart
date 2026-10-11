import 'dart:async';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/internationalization.dart';
import '/services/api_client.dart' as zannext_api;
import 'package:flutter/material.dart';

import 'support_chat_model.dart';
export 'support_chat_model.dart';

/// Support Chat — 100% Postgres. No Firebase.
///  * User mode  (threadId == null): own thread via GET/POST /support
///  * Admin mode (threadId != null): header from GET /admin/support,
///    messages via GET/POST /support/{id}/messages (admin allowed).
/// New messages arrive by 5s polling. Push arrives via backend hook.
class SupportChatWidget extends StatefulWidget {
  const SupportChatWidget({super.key, this.threadId});

  final String? threadId;

  static String routeName = 'SupportChat';
  static String routePath = '/supportChat';

  @override
  State<SupportChatWidget> createState() => _SupportChatWidgetState();
}

class _SupportChatWidgetState extends State<SupportChatWidget> {
  late SupportChatModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();
  Timer? _poll;

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kAdmin = Color(0xFF0D9488);
  static const Color kRed = Color(0xFFDC0F0F);
  static const String kSupportName = 'ZanNext Support';

  List<String> get _userQuickReplies => [
    FFLocalizations.of(context).getText('sc_qr_user_help'),
    FFLocalizations.of(context).getText('sc_qr_user_arrive'),
    FFLocalizations.of(context).getText('sc_qr_user_seller'),
    FFLocalizations.of(context).getText('sc_qr_user_refund'),
    FFLocalizations.of(context).getText('sc_qr_user_payment'),
  ];

  List<String> get _adminQuickReplies => [
    FFLocalizations.of(context).getText('sc_qr_admin_hello'),
    FFLocalizations.of(context).getText('sc_qr_admin_eta'),
    FFLocalizations.of(context).getText('sc_qr_admin_ordernum'),
    FFLocalizations.of(context).getText('sc_qr_admin_check'),
    FFLocalizations.of(context).getText('sc_qr_admin_sorry'),
    FFLocalizations.of(context).getText('sc_qr_admin_thanks'),
    FFLocalizations.of(context).getText('sc_qr_admin_resolved'),
  ];

  bool get _isAdminView => (widget.threadId ?? '').isNotEmpty;
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  String _tid = '';
  Map<String, dynamic>? _thread;
  List<Map<String, dynamic>> _messages = const [];
  bool _loading = true;
  String? _error;

  String _s(Map<String, dynamic>? m, List<String> keys, [String fb = '']) {
    if (m == null) return fb;
    for (final k in keys) {
      final v = m[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return fb;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SupportChatModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _init();
    _poll = Timer.periodic(const Duration(seconds: 5), (_) => _load(silent: true));
  }

  @override
  void dispose() {
    _poll?.cancel();
    _scrollController.dispose();
    _model.dispose();
    super.dispose();
  }

  Map<String, dynamic>? _pickThread(dynamic raw) {
    List<dynamic> threads = const [];
    if (raw is List) {
      threads = raw;
    } else if (raw is Map) {
      final m = Map<String, dynamic>.from(raw);
      if (m['threads'] is List) {
        threads = m['threads'] as List;
      } else if (m['data'] is List) {
        threads = m['data'] as List;
      } else {
        threads = [m];
      }
    }
    for (final t in threads) {
      final m = Map<String, dynamic>.from(t as Map);
      if ((m['id'] ?? m['thread_id'] ?? '').toString().isNotEmpty) return m;
    }
    return null;
  }

  Future<void> _init() async {
    if (currentUserUid.isEmpty) {
      if (mounted) safeSetState(() => _loading = false);
      return;
    }
    try {
      if (_isAdminView) {
        _tid = widget.threadId!;
        try {
          final list = await zannext_api.ApiClient.get('/admin/support') as List;
          for (final t in list) {
            final m = Map<String, dynamic>.from(t as Map);
            if ((m['id'] ?? '').toString() == _tid) {
              _thread = m;
              break;
            }
          }
        } catch (_) {}
        try {
          await zannext_api.ApiClient.patch('/admin/support/$_tid/read');
        } catch (_) {}
      } else {
        await _ensureMyThread();
      }
      await _load(silent: true);
    } catch (e) {
      _error = e.toString();
      if (mounted) safeSetState(() => _loading = false);
    }
  }

  Future<void> _ensureMyThread() async {
    dynamic raw;
    try {
      raw = await zannext_api.ApiClient.get('/support?user_id=$currentUserUid');
    } catch (_) {}
    _thread = _pickThread(raw);
    if (_thread == null) {
      dynamic created;
      try {
        created = await zannext_api.ApiClient.post('/support', body: const {});
      } catch (_) {
        try {
          created = await zannext_api.ApiClient.post('/support');
        } catch (_) {}
      }
      _thread = _pickThread(created);
    }
    _tid = (_thread?['id'] ?? _thread?['thread_id'] ?? '').toString();
  }

  Future<void> _load({bool silent = false}) async {
    if (_tid.isEmpty) {
      if (mounted) safeSetState(() => _loading = false);
      return;
    }
    try {
      dynamic raw = await zannext_api.ApiClient.get('/support/$_tid/messages');
      List<dynamic> list = const [];
      if (raw is List) {
        list = raw;
      } else if (raw is Map) {
        final m = Map<String, dynamic>.from(raw);
        if (m['messages'] is List) list = m['messages'] as List;
        if (m['data'] is List) list = m['data'] as List;
      }
      final msgs = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      msgs.sort((a, b) {
        final ad = DateTime.tryParse(_s(a, ['created_at', 'timestamp'])) ?? DateTime(1970);
        final bd = DateTime.tryParse(_s(b, ['created_at', 'timestamp'])) ?? DateTime(1970);
        return bd.compareTo(ad); // newest first + reverse:true = newest at BOTTOM
      });
      _messages = msgs;
      _error = null;
    } catch (e) {
      if (!silent) _error = e.toString();
    }
    if (mounted) safeSetState(() => _loading = false);
  }

  // ── BUILD ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (currentUserUid.isEmpty) {
      return Scaffold(
        backgroundColor: _bg,
        body: Center(
            child: Text(FFLocalizations.of(context).getText('sc_sign_in_first'))),
      );
    }
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
              Expanded(child: _buildMessages()),
              _buildQuickReplies(),
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final topPad = MediaQuery.of(context).padding.top;
    String title;
    String subtitle;
    String photoUrl = '';
    if (_isAdminView) {
      title = _s(_thread, ['user_name'], 'User');
      subtitle = _s(_thread, ['user_email']);
      photoUrl = _s(_thread, ['user_photo']);
    } else {
      title = FFLocalizations.of(context).getText('sc_support_name');
      subtitle = FFLocalizations.of(context).getText('sc_replies_minutes');
    }

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(0, topPad + 8, 0, 12),
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
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
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
            const SizedBox(width: 6),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: _isAdminView
                  ? (photoUrl.isEmpty
                      ? const Icon(Icons.person_rounded,
                          color: Colors.white, size: 22)
                      : Image.network(photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 22)))
                  : const Icon(Icons.support_agent_rounded,
                      color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                      ),
                      if (_isAdminView) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                              FFLocalizations.of(context)
                                  .getText('sc_admin_badge'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              color: _card,
              icon: const Icon(Icons.more_vert_rounded,
                  color: Colors.white, size: 22),
              onSelected: (v) {
                if (v == 'refresh') _load();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'refresh',
                  child: Row(children: [
                    const Icon(Icons.refresh_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(FFLocalizations.of(context).getText('sc_menu_refresh')),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages() {
    if (_loading) {
      return const Center(
        child: SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kGreen),
            strokeWidth: 3,
          ),
        ),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
              '${FFLocalizations.of(context).getText('sc_could_not_load')}\n$_error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: kRed, fontSize: 13)),
        ),
      );
    }
    if (_messages.isEmpty) return _welcomeState();

    return ListView.separated(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 8),
      itemCount: _messages.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final m = _messages[index];
        final sender = _s(m, ['sender_type', 'sender']);
        final isMine = _isAdminView ? sender == 'admin' : sender == 'user';
        return _messageBubble(
          text: _s(m, ['text', 'message']),
          isMine: isMine,
          isAdminMsg: sender == 'admin',
          when: DateTime.tryParse(_s(m, ['created_at', 'timestamp'])),
          senderName: (sender == 'admin' && !_isAdminView)
              ? 'ZanNext Support'
              : _s(m, ['sender_name']),
        );
      },
    );
  }

  Widget _welcomeState() {
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
                color: kGreen.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isAdminView
                    ? Icons.support_agent_rounded
                    : Icons.chat_bubble_outline_rounded,
                color: kGreen,
                size: 42,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isAdminView
                  ? FFLocalizations.of(context).getText('sc_no_messages_admin')
                  : FFLocalizations.of(context).getText('sc_no_messages_user'),
              style: TextStyle(
                  color: _text, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              _isAdminView
                  ? FFLocalizations.of(context)
                      .getText('sc_no_messages_admin_sub')
                  : FFLocalizations.of(context)
                      .getText('sc_no_messages_user_sub'),
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageBubble({
    required String text,
    required bool isMine,
    required bool isAdminMsg,
    DateTime? when,
    String? senderName,
  }) {
    final bubbleColor = isMine ? (_isAdminView ? kAdmin : kGreen) : _card;
    final textColor = isMine ? Colors.white : _text;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78),
        child: Container(
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMine ? 16 : 4),
              bottomRight: Radius.circular(isMine ? 4 : 16),
            ),
            border: isMine ? null : Border.all(color: _border),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(12, 9, 12, 9),
          child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isMine)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isAdminMsg ? kAdmin : kGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(senderName ?? (isAdminMsg ? kSupportName : 'User'),
                          style: TextStyle(
                              color: isAdminMsg ? kAdmin : kGreen,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              Text(text,
                  style: TextStyle(color: textColor, fontSize: 14, height: 1.4)),
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (when != null)
                    Text(
                        dateTimeFormat('jm', when,
                            locale:
                                FFLocalizations.of(context).languageCode),
                        style: TextStyle(
                            color: isMine ? Colors.white70 : _muted,
                            fontSize: 10)),
                  if (isMine) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.done_all_rounded,
                        color: Colors.white.withOpacity(0.8), size: 13),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReplies() {
    final list = _isAdminView ? _adminQuickReplies : _userQuickReplies;
    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              _model.textController?.text = list[i];
              safeSetState(() {});
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _isAdminView ? kAdmin.withOpacity(0.1) : _card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color:
                        _isAdminView ? kAdmin.withOpacity(0.35) : _border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isAdminView) ...[
                    const Icon(Icons.bolt_rounded, color: kAdmin, size: 13),
                    const SizedBox(width: 4),
                  ],
                  Text(list[i],
                      style: TextStyle(
                          color: _isAdminView ? kAdmin : _text,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    final accent = _isAdminView ? kAdmin : kGreen;
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(
          12, 10, 12, MediaQuery.of(context).padding.bottom + 10),
      decoration: BoxDecoration(
        color: _card,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _border),
              ),
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: TextField(
                controller: _model.textController,
                focusNode: _model.textFieldFocusNode,
                onChanged: (_) => safeSetState(() {}),
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: _isAdminView
                      ? FFLocalizations.of(context).getText('sc_input_admin')
                      : FFLocalizations.of(context).getText('sc_input_user'),
                  hintStyle: TextStyle(color: _muted, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                ),
                style: TextStyle(color: _text, fontSize: 14),
                cursorColor: accent,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: (_model.textController!.text.trim().isEmpty ||
                    _model.isSending)
                ? null
                : _send,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: (_model.textController!.text.trim().isEmpty ||
                        _model.isSending)
                    ? _muted
                    : accent,
                shape: BoxShape.circle,
              ),
              child: _model.isSending
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send_rounded,
                      color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    if (currentUserUid.isEmpty || _tid.isEmpty) return;
    final text = _model.textController!.text.trim();
    if (text.isEmpty || _model.isSending) return;

    safeSetState(() => _model.isSending = true);
    try {
      await zannext_api.ApiClient.post('/support/$_tid/messages',
          body: {'text': text});
      _model.textController?.clear();
      await _load(silent: true);
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${FFLocalizations.of(context).getText('sc_send_failed')}$e'),
          backgroundColor: kRed,
        ),
      );
    } finally {
      if (mounted) safeSetState(() => _model.isSending = false);
    }
  }
}
