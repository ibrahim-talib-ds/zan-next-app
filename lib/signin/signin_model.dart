import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'signin_widget.dart' show SigninWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SigninModel extends FlutterFlowModel<SigninWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for emailsignin widget.
  final emailsigninKey = GlobalKey();
  FocusNode? emailsigninFocusNode;
  TextEditingController? emailsigninTextController;
  String? emailsigninSelectedOption;
  String? Function(BuildContext, String?)? emailsigninTextControllerValidator;
  // State field(s) for passwordsignin widget.
  final passwordsigninKey = GlobalKey();
  FocusNode? passwordsigninFocusNode;
  TextEditingController? passwordsigninTextController;
  String? passwordsigninSelectedOption;
  late bool passwordsigninVisibility;
  String? Function(BuildContext, String?)?
      passwordsigninTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordsigninVisibility = false;
  }

  @override
  void dispose() {
    emailsigninFocusNode?.dispose();

    passwordsigninFocusNode?.dispose();
  }
}
