import '/flutter_flow/flutter_flow_util.dart';
import 'sign_up_widget.dart' show SignUpWidget;
import 'package:flutter/material.dart';

class SignUpModel extends FlutterFlowModel<SignUpWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for txtname widget.
  FocusNode? txtnameFocusNode;
  TextEditingController? txtnameTextController;
  String? Function(BuildContext, String?)? txtnameTextControllerValidator;

  // State field(s) for txtphone widget.
  FocusNode? txtphoneFocusNode;
  TextEditingController? txtphoneTextController;
  String? Function(BuildContext, String?)? txtphoneTextControllerValidator;

  // State field(s) for txtemail widget.
  FocusNode? txtemailFocusNode;
  TextEditingController? txtemailTextController;
  String? Function(BuildContext, String?)? txtemailTextControllerValidator;

  // State field(s) for TextPassort widget.
  FocusNode? textPassortFocusNode;
  TextEditingController? textPassortTextController;
  late bool textPassortVisibility;
  String? Function(BuildContext, String?)? textPassortTextControllerValidator;

  // State field(s) for Checkbox widget.
  bool? checkboxValue;

  @override
  void initState(BuildContext context) {
    textPassortVisibility = false;
  }

  @override
  void dispose() {
    txtnameFocusNode?.dispose();
    txtnameTextController?.dispose();

    txtphoneFocusNode?.dispose();
    txtphoneTextController?.dispose();

    txtemailFocusNode?.dispose();
    txtemailTextController?.dispose();

    textPassortFocusNode?.dispose();
    textPassortTextController?.dispose();
  }
}
