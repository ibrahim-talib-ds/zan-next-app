import '/flutter_flow/flutter_flow_util.dart';
import 'admin_broadcast_widget.dart' show AdminBroadcastWidget;
import 'package:flutter/material.dart';

class AdminBroadcastModel extends FlutterFlowModel<AdminBroadcastWidget> {
  FocusNode? titleFocusNode;
  TextEditingController? titleController;

  FocusNode? bodyFocusNode;
  TextEditingController? bodyController;

  String? selectedType; // 'info' | 'promo' | 'alert'
  bool isSending = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    titleFocusNode?.dispose();
    titleController?.dispose();
    bodyFocusNode?.dispose();
    bodyController?.dispose();
  }
}
