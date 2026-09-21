import 'dart:async';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'support_chat_model.dart';
export 'support_chat_model.dart';

/// Support Chat — works for BOTH:
///   * User mode   (threadId == null) → talks to ZanNext Support
///   * Admin mode  (threadId != null) → admin replies to a specific user's thread
class SupportChatWidget extends StatefulWidget {
  const SupportChatWidget({
    super.key,
    this.threadId,
  });

  /// User's own uid when admin is viewing. Null when a user opens the page.
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

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kAdmin = Color(0xFF0D9488);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);
  static const String kSupportName = 'ZanNext Support';

  /// User's quick replies
  static const List<String> _userQuickReplies = [
    'I need help with my order',
    'When will my product arrive?',
    'How do I become a seller?',
    'How do I request a refund?',
    'Payment issue',
  ];

  /// Admin's quick replies
  static const List<String> _adminQuickReplies = [
    'Hello! How can I help you today?',
    'Your order is on the way. ETA: 1-2 days.',
    'Please share your order number.',
    'Let me check that for you.',
    'Sorry for the inconvenience.',
    'Thanks for reaching out!',
    'Your issue has been resolved. ✅',
  ];

  bool get _isAdminView => widget.threadId != null;
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

  DocumentReference? get _threadRef {
    final id = widget.threadId ?? currentUserReference?.id;
    if (id == null) return null;
    return FirebaseFirestore.instance.collection('support_chats').doc(id);
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SupportChatModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _model.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    if (currentUserReference == null) {
      return Scaffold(
        backgroundColor: _bg,
        body: const Center(child: Text('Please sign in first')),
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

  // ═══════════════════════════════════════════════════════════
  // HEADER — different per role
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeader() {
    final topPad = MediaQuery.of(context).padding.top;

    // In admin mode we show the USER info; in user mode we show SUPPORT info
    return StreamBuilder<DocumentSnapshot>(
      stream: _isAdminView ? _threadRef?.snapshots() : null,
      builder: (context, snap) {
        String title;
        String subtitle;
        String photoUrl;

        if (_isAdminView) {
          final data = (snap.data?.data() as Map<String, dynamic>?) ?? {};
          title = (data['user_name'] ?? 'User').toString();
          subtitle = (data['user_email'] ?? 'Admin view').toString();
          photoUrl = _imgUrl((data['user_photo'] ?? '').toString());
        } else {
          title = kSupportName;
          subtitle = 'Usually replies in minutes';
          photoUrl = '';
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
                // Avatar
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
                          : Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ))
                      : const Icon(Icons.support_agent_rounded,
                          color: Colors.white, size: 22),
                ),
                const SizedBox(width: 10),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
                              child: const Text(
                                'ADMIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
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
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Menu
                PopupMenuButton<String>(
                  color: _card,
                  icon: const Icon(Icons.more_vert_rounded,
                      color: Colors.white, size: 22),
                  onSelected: (v) => _handleMenu(v),
                  itemBuilder: (_) => _isAdminView
                      ? const [
                          PopupMenuItem(
                            value: 'user_profile',
                            child: Row(
                              children: [
                                Icon(Icons.person_outline_rounded, size: 18),
                                SizedBox(width: 8),
                                Text('View user profile'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'resolve',
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline_rounded,
                                    size: 18),
                                SizedBox(width: 8),
                                Text('Mark resolved'),
                              ],
                            ),
                          ),
                        ]
                      : const [
                          PopupMenuItem(
                            value: 'refresh',
                            child: Row(
                              children: [
                                Icon(Icons.refresh_rounded, size: 18),
                                SizedBox(width: 8),
                                Text('Refresh'),
                              ],
                            ),
                          ),
                        ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleMenu(String v) async {
    final ref = _threadRef;
    if (ref == null) return;

    switch (v) {
      case 'resolve':
        try {
          await ref.update({'status': 'resolved'});
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Marked as resolved'),
              backgroundColor: kGreen,
            ),
          );
        } catch (_) {}
        break;
      case 'user_profile':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User profile coming soon')),
        );
        break;
      case 'refresh':
        safeSetState(() {});
        break;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // MESSAGES
  // ═══════════════════════════════════════════════════════════
  Widget _buildMessages() {
    final ref = _threadRef;
    if (ref == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: ref
          .collection('messages')
          .orderBy('created_at', descending: true)
          .limit(200)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Could not load messages\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: kRed, fontSize: 13),
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
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

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return _welcomeState();

        return ListView.separated(
          controller: _scrollController,
          reverse: true,
          padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 8),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final sender = (data['sender'] ?? '').toString();

            // Determine if THIS message is "mine"
            final isMine = _isAdminView
                ? sender == 'admin'
                : sender == 'user';

            return _messageBubble(
              text: (data['text'] ?? '').toString(),
              isMine: isMine,
              isAdminMsg: sender == 'admin',
              when: (data['created_at'] as Timestamp?)?.toDate(),
              senderName: data['sender_name'] as String?,
            );
          },
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
                  ? 'No messages yet'
                  : 'How can we help you?',
              style: TextStyle(
                color: _text,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _isAdminView
                  ? 'The user hasn\'t sent any messages yet.'
                  : 'Pick a topic below or type your own message.',
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
    final bubbleColor = isMine
        ? (_isAdminView ? kAdmin : kGreen)
        : _card;
    final textColor = isMine ? Colors.white : _text;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
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
              // Label on non-mine messages
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
                      Text(
                        senderName ?? (isAdminMsg ? kSupportName : 'User'),
                        style: TextStyle(
                          color: isAdminMsg ? kAdmin : kGreen,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (when != null)
                    Text(
                      dateTimeFormat(
                        'jm',
                        when,
                        locale: FFLocalizations.of(context).languageCode,
                      ),
                      style: TextStyle(
                        color: isMine ? Colors.white70 : _muted,
                        fontSize: 10,
                      ),
                    ),
                  if (isMine) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.done_all_rounded,
                      color: Colors.white.withOpacity(0.8),
                      size: 13,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // QUICK REPLIES — different per role
  // ═══════════════════════════════════════════════════════════
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _isAdminView
                    ? kAdmin.withOpacity(0.1)
                    : _card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isAdminView
                      ? kAdmin.withOpacity(0.35)
                      : _border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isAdminView) ...[
                    const Icon(Icons.bolt_rounded,
                        color: kAdmin, size: 13),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    list[i],
                    style: TextStyle(
                      color: _isAdminView ? kAdmin : _text,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
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
  // INPUT BAR
  // ═══════════════════════════════════════════════════════════
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
                      ? 'Reply as Support...'
                      : 'Type your message...',
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

  // ═══════════════════════════════════════════════════════════
  // SEND
  // ═══════════════════════════════════════════════════════════
  Future<void> _send() async {
    final ref = _threadRef;
    if (ref == null) return;
    final text = _model.textController!.text.trim();
    if (text.isEmpty || _model.isSending) return;

    safeSetState(() => _model.isSending = true);

    try {
      final threadSnap = await ref.get();
      final senderType = _isAdminView ? 'admin' : 'user';
      final senderDisplayName =
          _isAdminView ? 'ZanNext Support' : currentUserDisplayName;

      if (!threadSnap.exists) {
        // First message ever — create the parent thread
        // (only happens in USER mode)
        await ref.set({
          'user_ref': currentUserReference,
          'user_name': currentUserDisplayName,
          'user_photo': currentUserPhoto,
          'user_email': currentUserEmail,
          'status': 'open',
          'created_at': FieldValue.serverTimestamp(),
          'last_message': text,
          'last_message_at': FieldValue.serverTimestamp(),
          'unread_for_admin': 1,
          'unread_for_user': 0,
        });
      } else {
        await ref.update({
          'last_message': text,
          'last_message_at': FieldValue.serverTimestamp(),
          if (_isAdminView)
            'unread_for_user': FieldValue.increment(1)
          else
            'unread_for_admin': FieldValue.increment(1),
          'status': 'open',
        });
      }

      // Append the message
      await ref.collection('messages').add({
        'sender': senderType,
        'sender_ref': currentUserReference,
        'sender_name': senderDisplayName,
        'text': text,
        'created_at': FieldValue.serverTimestamp(),
        'seen_by_admin': _isAdminView,
      });

      _model.textController?.clear();
      if (mounted) safeSetState(() {});

      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Send failed: $e'),
          backgroundColor: kRed,
        ),
      );
    } finally {
      if (mounted) safeSetState(() => _model.isSending = false);
    }
  }
}
