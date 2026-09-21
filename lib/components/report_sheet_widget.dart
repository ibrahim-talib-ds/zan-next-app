import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'report_sheet_model.dart';
export 'report_sheet_model.dart';

/// Bottom sheet that any user can open to report a product or user.
/// Writes to the `reports` collection.
class ReportSheetWidget extends StatefulWidget {
  const ReportSheetWidget({
    super.key,
    required this.targetType,   // 'product' | 'user'
    required this.targetRef,    // DocumentReference
    required this.targetLabel,  // display name for header
  });

  final String targetType;
  final DocumentReference targetRef;
  final String targetLabel;

  @override
  State<ReportSheetWidget> createState() => _ReportSheetWidgetState();
}

class _ReportSheetWidgetState extends State<ReportSheetWidget> {
  late ReportSheetModel _model;
  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF3B82F6);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  static const List<Map<String, dynamic>> _reasons = [
    {
      'id': 'fake',
      'label': 'Fake or misleading',
      'desc': 'Product doesn\'t match the description',
      'icon': Icons.report_gmailerrorred_rounded,
      'color': kRed,
      'priority': 'high',
    },
    {
      'id': 'price',
      'label': 'Wrong price',
      'desc': 'Price is incorrect or a scam',
      'icon': Icons.attach_money_rounded,
      'color': kAmber,
      'priority': 'high',
    },
    {
      'id': 'behavior',
      'label': 'Bad seller behavior',
      'desc': 'Rude, unresponsive, or dishonest',
      'icon': Icons.sentiment_dissatisfied_rounded,
      'color': kRed,
      'priority': 'medium',
    },
    {
      'id': 'spam',
      'label': 'Spam or duplicate',
      'desc': 'Repeated listings or junk content',
      'icon': Icons.block_rounded,
      'color': kBlue,
      'priority': 'low',
    },
    {
      'id': 'image',
      'label': 'Inappropriate image',
      'desc': 'Contains offensive or explicit content',
      'icon': Icons.image_not_supported_outlined,
      'color': kRed,
      'priority': 'high',
    },
    {
      'id': 'other',
      'label': 'Other issue',
      'desc': 'Something else not listed here',
      'icon': Icons.more_horiz_rounded,
      'color': kBlue,
      'priority': 'low',
    },
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportSheetModel());
    _model.notesController ??= TextEditingController();
    _model.notesFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        color: _bg,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHandle(),
                _buildHeader(),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16, 8, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildReasonsList(),
                        const SizedBox(height: 16),
                        _buildNotesField(),
                        const SizedBox(height: 20),
                        _buildSubmitBtn(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() => Container(
        margin: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 4),
        width: 44,
        height: 4,
        decoration: BoxDecoration(
          color: _border,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  Widget _buildHeader() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: kRed.withOpacity(0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.flag_rounded,
                  color: kRed, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Report',
                      style: TextStyle(
                        color: kRed,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      )),
                  const SizedBox(height: 2),
                  Text(
                    widget.targetLabel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _muted, fontSize: 12.5),
                  ),
                ],
              ),
            ),
            FlutterFlowIconButton(
              borderRadius: 8,
              buttonSize: 40,
              fillColor: Colors.transparent,
              icon: Icon(Icons.close_rounded, color: _text, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

  Widget _buildReasonsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 8),
          child: Text('WHY ARE YOU REPORTING THIS?',
              style: TextStyle(
                color: _muted,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              )),
        ),
        ..._reasons.map((r) {
          final isActive = _model.selectedReason == r['id'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => safeSetState(
                  () => _model.selectedReason = r['id'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: isActive
                      ? (r['color'] as Color).withOpacity(0.1)
                      : _card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive
                        ? r['color'] as Color
                        : _border,
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: (r['color'] as Color).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(r['icon'] as IconData,
                          color: r['color'] as Color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r['label'] as String,
                              style: TextStyle(
                                color: _text,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              )),
                          const SizedBox(height: 2),
                          Text(r['desc'] as String,
                              style: TextStyle(
                                  color: _muted, fontSize: 11.5)),
                        ],
                      ),
                    ),
                    if (isActive)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: r['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 12),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNotesField() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: TextField(
        controller: _model.notesController,
        focusNode: _model.notesFocusNode,
        maxLines: 3,
        minLines: 2,
        maxLength: 200,
        style: TextStyle(color: _text, fontSize: 13.5, height: 1.4),
        cursorColor: kGreen,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Add more details (optional)',
          hintStyle: TextStyle(color: _muted, fontSize: 13.5),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsetsDirectional.fromSTEB(14, 14, 14, 14),
          counterStyle: TextStyle(color: _muted, fontSize: 10.5),
        ),
      ),
    );
  }

  Widget _buildSubmitBtn() {
    final enabled = _model.selectedReason != null && !_model.isSubmitting;
    return GestureDetector(
      onTap: enabled ? _submit : null,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: enabled ? kRed : _muted,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: _model.isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flag_rounded,
                        color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Submit Report',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (currentUserReference == null) return;

    final reasonId = _model.selectedReason!;
    final reason = _reasons.firstWhere((r) => r['id'] == reasonId);

    safeSetState(() => _model.isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'reporter_ref': currentUserReference,
        'reporter_name': currentUserDisplayName,
        'reporter_email': currentUserEmail,
        'target_type': widget.targetType,
        'target_ref': widget.targetRef,
        'target_label': widget.targetLabel,
        'reason_id': reasonId,
        'reason_label': reason['label'],
        'priority': reason['priority'],
        'notes': _model.notesController?.text.trim() ?? '',
        'status': 'pending',
        'created_at': FieldValue.serverTimestamp(),
        'resolved_at': null,
        'resolved_by': null,
        'action_taken': null,
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thanks! Report submitted.'),
          backgroundColor: kGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      safeSetState(() => _model.isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: kRed,
        ),
      );
    }
  }
}
