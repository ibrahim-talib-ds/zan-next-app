import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'messagelist_model.dart';
export 'messagelist_model.dart';

class MessagelistWidget extends StatefulWidget {
  const MessagelistWidget({super.key});

  static String routeName = 'messagelist';
  static String routePath = '/messagelist';

  @override
  State<MessagelistWidget> createState() => _MessagelistWidgetState();
}

class _MessagelistWidgetState extends State<MessagelistWidget> {
  late MessagelistModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);

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
    _model = createModel(context, () => MessagelistModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserReference == null) {
      return _scaffoldWithHeader(
        body: Center(
          child: Text('Please sign in', style: TextStyle(color: _muted)),
        ),
      );
    }

    return _scaffoldWithHeader(
      body: StreamBuilder<List<ChatsRecord>>(
        stream: queryChatsRecord(
          queryBuilder: (r) => r
              .where('users', arrayContains: currentUserReference)
              .orderBy('last_message_time', descending: true),
          limit: 100,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _errorState('${snapshot.error}');
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
          final items = snapshot.data!;
          if (items.isEmpty) return _emptyState();

          return RefreshIndicator(
            color: kGreen,
            onRefresh: () async => safeSetState(() {}),
            child: ListView.separated(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final chat = items[i];
                return Dismissible(
                  key: ValueKey('chat_${chat.reference.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC0F0F),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete_outline_rounded,
                            color: Colors.white, size: 22),
                        SizedBox(width: 6),
                        Text('Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            )),
                      ],
                    ),
                  ),
                  confirmDismiss: (_) => _confirmDeleteChat(chat),
                  onDismissed: (_) => _deleteChat(chat),
                  child: _chatTile(chat),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SCAFFOLD (header + body)
  // ═══════════════════════════════════════════════════════════
  Widget _scaffoldWithHeader({required Widget body}) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _bg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: body),
          ],
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
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Messages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(height: 2),
              Text('Chat with buyers & sellers',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded,
                color: Colors.white, size: 22),
            onSelected: (v) {
              if (v == 'clear_all') _confirmClearAllChats();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded,
                        size: 18, color: Color(0xFFDC0F0F)),
                    SizedBox(width: 10),
                    Text('Clear all',
                        style: TextStyle(color: Color(0xFFDC0F0F))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // DELETE HELPERS
  // ═══════════════════════════════════════════════════════════
  Future<bool> _confirmDeleteChat(ChatsRecord chat) async {
    final names = chat.userName;
    final isMeBuyer = chat.buyerRef == currentUserReference;
    String otherName = 'this chat';
    if (names.length >= 2) {
      otherName = isMeBuyer ? names[1] : names[0];
    } else if (names.isNotEmpty) {
      otherName = names.first;
    }

    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: _card,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Text('Delete conversation?',
                style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
            content: Text(
              'Chat with $otherName and all its messages will be removed permanently.',
              style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancel',
                    style: TextStyle(
                        color: _muted, fontWeight: FontWeight.w600)),
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

  Future<void> _deleteChat(ChatsRecord chat) async {
    try {
      // 1. Delete all messages in this chat
      final msgs = await FirebaseFirestore.instance
          .collection('chat_messages')
          .where('chat_ref', isEqualTo: chat.reference)
          .get();

      if (msgs.docs.isNotEmpty) {
        final batch = FirebaseFirestore.instance.batch();
        for (final d in msgs.docs) {
          batch.delete(d.reference);
        }
        await batch.commit();
      }

      // 2. Delete the chat document
      await chat.reference.delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conversation deleted'),
          backgroundColor: kGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      safeSetState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not delete: $e'),
          backgroundColor: const Color(0xFFDC0F0F),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _confirmClearAllChats() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Clear all conversations?',
            style: TextStyle(
                color: _text, fontWeight: FontWeight.w800, fontSize: 16)),
        content: Text(
          'Every chat and its messages will be permanently deleted.',
          style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: TextStyle(
                    color: _muted, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear All',
                style: TextStyle(
                    color: Color(0xFFDC0F0F),
                    fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
    if (ok == true) await _clearAllChats();
  }

  Future<void> _clearAllChats() async {
    if (currentUserReference == null) return;
    try {
      final chats = await FirebaseFirestore.instance
          .collection('Chats')
          .where('users', arrayContains: currentUserReference)
          .get();

      if (chats.docs.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No conversations to clear')),
        );
        return;
      }

      for (final chat in chats.docs) {
        final msgs = await FirebaseFirestore.instance
            .collection('chat_messages')
            .where('chat_ref', isEqualTo: chat.reference)
            .get();
        if (msgs.docs.isNotEmpty) {
          final batch = FirebaseFirestore.instance.batch();
          for (final d in msgs.docs) {
            batch.delete(d.reference);
          }
          await batch.commit();
        }
        await chat.reference.delete();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cleared ${chats.docs.length} conversation(s)'),
          backgroundColor: kGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      safeSetState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not clear: $e'),
          backgroundColor: const Color(0xFFDC0F0F),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // CHAT TILE
  // ═══════════════════════════════════════════════════════════
  Widget _chatTile(ChatsRecord chat) {
    // Names live in `User_name` as [buyer_name, seller_name].
    // My index tells us which name to show (the other party).
    final names = chat.userName;
    final isMeBuyer = chat.buyerRef == currentUserReference;
    String otherName = 'Chat';
    if (names.length >= 2) {
      otherName = isMeBuyer ? names[1] : names[0];
    } else if (names.isNotEmpty) {
      otherName = names.first;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.pushNamed(
        ChatDWidget.routeName,
        queryParameters: {
          'receiveChats':
              serializeParam(chat.reference, ParamType.DocumentReference),
        }.withoutNulls,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar (uses chat's image fallback or generic icon)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                _imgUrl(valueOrDefault<String>(
                  chat.itemsImages.firstOrNull,
                  '',
                )),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person_rounded,
                  color: kGreen,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          otherName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _text,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (chat.lastMessageTime != null)
                        Text(
                          _timeAgo(chat.lastMessageTime!),
                          style: TextStyle(color: _muted, fontSize: 11),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    valueOrDefault<String>(chat.productName, 'Product'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: kGreen, fontSize: 11.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    valueOrDefault<String>(chat.lastMessage, ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _muted, fontSize: 12.5),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, color: _muted, size: 20),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime when) {
    final d = DateTime.now().difference(when);
    if (d.inSeconds < 60) return 'Just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    if (d.inDays < 7) return '${d.inDays}d';
    return '${when.day}/${when.month}';
  }

  // ═══════════════════════════════════════════════════════════
  // STATES
  // ═══════════════════════════════════════════════════════════
  Widget _emptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chat_bubble_outline_rounded,
                    color: kGreen, size: 36),
              ),
              const SizedBox(height: 16),
              Text('No messages yet',
                  style: TextStyle(
                    color: _text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 6),
              Text(
                'Chats with buyers and sellers will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
      );

  Widget _errorState(String msg) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: Color(0xFFDC0F0F), size: 48),
              const SizedBox(height: 12),
              Text('Could not load messages',
                  style: TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 8),
              Text(msg,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 12)),
            ],
          ),
        ),
      );
}
