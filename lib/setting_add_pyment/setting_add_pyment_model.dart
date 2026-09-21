import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'setting_add_pyment_widget.dart' show SettingAddPymentWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingAddPymentModel extends FlutterFlowModel<SettingAddPymentWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for cardholder_name widget.
  FocusNode? cardholderNameFocusNode;
  TextEditingController? cardholderNameTextController;
  String? Function(BuildContext, String?)?
      cardholderNameTextControllerValidator;
  // State field(s) for cardnumber widget.
  FocusNode? cardnumberFocusNode;
  TextEditingController? cardnumberTextController;
  String? Function(BuildContext, String?)? cardnumberTextControllerValidator;
  // State field(s) for ccv widget.
  FocusNode? ccvFocusNode;
  TextEditingController? ccvTextController;
  String? Function(BuildContext, String?)? ccvTextControllerValidator;
  // State field(s) for exp widget.
  FocusNode? expFocusNode;
  TextEditingController? expTextController;
  String? Function(BuildContext, String?)? expTextControllerValidator;
  DateTime? datePicked1;
  // State field(s) for owner_name widget.
  FocusNode? ownerNameFocusNode;
  TextEditingController? ownerNameTextController;
  String? Function(BuildContext, String?)? ownerNameTextControllerValidator;
  // State field(s) for simcard_name widget.
  FocusNode? simcardNameFocusNode;
  TextEditingController? simcardNameTextController;
  String? Function(BuildContext, String?)? simcardNameTextControllerValidator;
  DateTime? datePicked2;
  // State field(s) for phone_number widget.
  FocusNode? phoneNumberFocusNode;
  TextEditingController? phoneNumberTextController;
  String? Function(BuildContext, String?)? phoneNumberTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    cardholderNameFocusNode?.dispose();
    cardholderNameTextController?.dispose();

    cardnumberFocusNode?.dispose();
    cardnumberTextController?.dispose();

    ccvFocusNode?.dispose();
    ccvTextController?.dispose();

    expFocusNode?.dispose();
    expTextController?.dispose();

    ownerNameFocusNode?.dispose();
    ownerNameTextController?.dispose();

    simcardNameFocusNode?.dispose();
    simcardNameTextController?.dispose();

    phoneNumberFocusNode?.dispose();
    phoneNumberTextController?.dispose();
  }
}
