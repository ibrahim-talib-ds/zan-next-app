import '/flutter_flow/flutter_flow_util.dart';
import 'support_chat_widget.dart' show SupportChatWidget;
import 'package:flutter/material.dart';

class SupportChatModel extends FlutterFlowModel<SupportChatWidget> {
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  bool isSending = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
