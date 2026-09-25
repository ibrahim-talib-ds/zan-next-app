import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_d_model.dart';
import '/services/notification_sender.dart';
export 'chat_d_model.dart';

class ChatDWidget extends StatefulWidget {
  const ChatDWidget({
    super.key,
    required this.receiveChats,
  });

  final DocumentReference? receiveChats;

  static String routeName = 'ChatD';
  static String routePath = '/chatD';

  @override
  State<ChatDWidget> createState() => _ChatDWidgetState();
}

class _ChatDWidgetState extends State<ChatDWidget> {
  late ChatDModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF121212) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E7EB);
  Color get _bubbleMine => kGreen;
  Color get _bubbleOther => _isDark ? const Color(0xFF262626) : const Color(0xFFF1F5F9);

  String _imgUrl(String? url) {
    final u = (url ?? '').trim();
    if (u.isEmpty) return '';
    return u.startsWith('http://') ? u.replaceFirst('http://', 'https://') : u;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatDModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.receiveChats == null) {
      return _scaffoldSimple(
        const Center(child: Text('Chat not found')),
      );
    }

    return StreamBuilder<ChatsRecord>(
      stream: ChatsRecord.getDocument(widget.receiveChats!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _scaffoldSimple(
            _errorState('${snapshot.error}'),
          );
        }
        if (!snapshot.hasData) {
          return _scaffoldSimple(
            const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                  strokeWidth: 3,
                ),
              ),
            ),
          );
        }

        final chat = snapshot.data!;
        final isMeBuyer = chat.buyerRef == currentUserReference;
        final otherRef = isMeBuyer ? chat.sellerRef : chat.buyerRef;

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
                  _buildHeader(chat, otherRef),
                  _buildProductBar(chat),
                  Expanded(child: _buildMessages()),
                  _buildInputBar(chat),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _scaffoldSimple(Widget body) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _bg,
      body: SafeArea(top: false, child: body),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeader(ChatsRecord chat, DocumentReference? otherRef) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(8, topPad + 8, 8, 12),
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
            fillColor: Colors.white.withOpacity(0.15),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 22),
            onPressed: () => context.safePop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: FutureBuilder<UsersRecord?>(
              future: _getUserRecord(otherRef),
              builder: (context, snap) {
                final user = snap.data;
                final name = user?.displayName ?? 'Chat';
                final photo = user?.photoUrl ?? '';
                final city = user?.city ?? '';

                return GestureDetector(
                  onTap: () {
                    if (otherRef == null) return;
                    context.pushNamed(
                      SellerDashbordWidget.routeName,
                      queryParameters: {
                        'sellerRef': serializeParam(
                          otherRef,
                          ParamType.DocumentReference,
                        ),
                      }.withoutNulls,
                    );
                  },
                  child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: photo.isEmpty
                          ? const Icon(Icons.person_rounded,
                              color: Colors.white, size: 22)
                          : Image.network(
                              _imgUrl(photo),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 22),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
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
                                  city.isEmpty ? 'Online' : city,
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
                  ],
                ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PRODUCT BAR
  // ═══════════════════════════════════════════════════════════
  Widget _buildProductBar(ChatsRecord chat) {
    final imageUrl = chat.itemsImages.firstOrNull;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _card,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _border,
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              _imgUrl(imageUrl),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.shopping_bag_outlined,
                color: _muted,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'DISCUSSING',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  valueOrDefault<String>(chat.productName, 'Product'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _text,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  valueOrDefault<String>(
                    formatNumber(
                      chat.price,
                      formatType: FormatType.decimal,
                      decimalType: DecimalType.automatic,
                      currency: 'TZS ',
                    ),
                    'TZS 0',
                  ),
                  style: const TextStyle(
                    color: kGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // MESSAGES
  // ═══════════════════════════════════════════════════════════
  Widget _buildMessages() {
    return StreamBuilder<List<ChatMessagesRecord>>(
      stream: queryChatMessagesRecord(
        parent: widget.receiveChats,
        queryBuilder: (r) => r.orderBy('timestamp', descending: true),
        limit: 200,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorState('${snapshot.error}');
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

        final messages = snapshot.data!;
        if (messages.isEmpty) {
          return Center(
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
                  Text('Say hi 👋',
                      style: TextStyle(
                        color: _text,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    'Start the conversation about this product',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          controller: _scrollController,
          reverse: true,
          padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 16),
          itemCount: messages.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final msg = messages[index];
            final isMine = msg.user == currentUserReference;
            return _messageBubble(msg: msg, isMine: isMine);
          },
        );
      },
    );
  }

  Widget _messageBubble({
    required ChatMessagesRecord msg,
    required bool isMine,
  }) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isMine ? _bubbleMine : _bubbleOther,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMine ? 16 : 4),
              bottomRight: Radius.circular(isMine ? 4 : 16),
            ),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
          child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                valueOrDefault<String>(msg.text, ''),
                style: TextStyle(
                  color: isMine ? Colors.white : _text,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (msg.timestamp != null)
                    Text(
                      dateTimeFormat(
                        'jm',
                        msg.timestamp!,
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
  // INPUT BAR
  // ═══════════════════════════════════════════════════════════
  Widget _buildInputBar(ChatsRecord chat) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: _card,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: SafeArea(
        top: false,
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
                child: TextFormField(
                  controller: _model.textController,
                  focusNode: _model.textFieldFocusNode,
                  onChanged: (_) => safeSetState(() {}),
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onFieldSubmitted: (_) => _send(chat),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: _muted, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                  ),
                  style: TextStyle(color: _text, fontSize: 14),
                  cursorColor: kGreen,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: (_model.textController!.text.trim().isEmpty ||
                      _model.isSending)
                  ? null
                  : () => _send(chat),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: (_model.textController!.text.trim().isEmpty ||
                          _model.isSending)
                      ? _muted
                      : kGreen,
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
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SEND
  // ═══════════════════════════════════════════════════════════
  Future<void> _send(ChatsRecord chat) async {
    final text = _model.textController!.text.trim();
    if (text.isEmpty || _model.isSending) return;

    safeSetState(() => _model.isSending = true);

    try {
      // 1. Create the message doc
      await ChatMessagesRecord.createDoc(widget.receiveChats!).set(
        createChatMessagesRecordData(
          user: currentUserReference,
          text: text,
          timestamp: getCurrentTimestamp,
          nameSender: currentUserDisplayName,
        ),
      );

      // 2. Update chat metadata — single atomic-ish update
      await widget.receiveChats!.update({
        'last_message': text,
        'last_message_time': getCurrentTimestamp,
        'last_message_seen_by': FieldValue.arrayUnion([currentUserReference]),
      });

      // 🔔 Push notify the other participant
      final isMeBuyer = chat.buyerRef == currentUserReference;
      final recipientRef = isMeBuyer ? chat.sellerRef : chat.buyerRef;
      if (recipientRef != null) {
        final preview = text.length > 60 ? '${text.substring(0, 60)}...' : text;
        await NotificationSender.sendToUser(
          userRef: recipientRef,
          title: currentUserDisplayName,
          body: preview,
          data: {
            'route': 'ChatD',
            'chatId': widget.receiveChats!.id,
          },
        );
      }

      _model.textController?.clear();
      if (mounted) safeSetState(() {});

      // Scroll to newest
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
          backgroundColor: const Color(0xFFDC0F0F),
        ),
      );
    } finally {
      if (mounted) safeSetState(() => _model.isSending = false);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════
  Future<UsersRecord?> _getUserRecord(DocumentReference? ref) async {
    if (ref == null) return null;
    try {
      final snap = await ref.get();
      if (snap.exists) return UsersRecord.fromSnapshot(snap);
    } catch (_) {}
    return null;
  }

  Widget _errorState(String msg) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: Color(0xFFDC0F0F), size: 48),
              const SizedBox(height: 12),
              Text('Could not load chat',
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
