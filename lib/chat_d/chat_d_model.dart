import '/flutter_flow/flutter_flow_util.dart';
import 'chat_d_widget.dart' show ChatDWidget;
import 'package:flutter/material.dart';

class ChatDModel extends FlutterFlowModel<ChatDWidget> {
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(String?)? textControllerValidator;
  bool isSending = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
