import '/flutter_flow/flutter_flow_util.dart';
import 'reset_password_widget.dart' show ResetPasswordWidget;
import 'package:flutter/material.dart';

class ResetPasswordModel extends FlutterFlowModel<ResetPasswordWidget> {
  TextEditingController? passwordController;
  TextEditingController? confirmController;
  FocusNode? passwordFocus;
  FocusNode? confirmFocus;
  bool isSaving = false;
  bool showPassword = false;
  bool showConfirm = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    passwordController?.dispose();
    confirmController?.dispose();
    passwordFocus?.dispose();
    confirmFocus?.dispose();
  }
}
