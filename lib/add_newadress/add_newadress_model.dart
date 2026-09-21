import '/flutter_flow/flutter_flow_util.dart';
import 'add_newadress_widget.dart' show AddNewadressWidget;
import 'package:flutter/material.dart';

class AddNewadressModel extends FlutterFlowModel<AddNewadressWidget> {
  final formKey = GlobalKey<FormState>();

  String? selectedLabel;
  String? selectedCity;

  FocusNode? districtFocusNode;
  TextEditingController? districtTextController;
  String? Function(String?)? districtTextControllerValidator;

  FocusNode? streetFocusNode;
  TextEditingController? streetTextController;
  String? Function(String?)? streetTextControllerValidator;

  FocusNode? landmarkFocusNode;
  TextEditingController? landmarkTextController;
  String? Function(String?)? landmarkTextControllerValidator;

  FocusNode? phoneFocusNode;
  TextEditingController? phoneTextController;
  String? Function(String?)? phoneTextControllerValidator;

  FocusNode? houseNoFocusNode;
  TextEditingController? houseNoTextController;
  String? Function(String?)? houseNoTextControllerValidator;

  FocusNode? notesFocusNode;
  TextEditingController? notesTextController;
  String? Function(String?)? notesTextControllerValidator;

  bool isSaving = false;

  @override
  void initState(BuildContext context) {
    districtTextControllerValidator = (val) {
      if (val == null || val.trim().isEmpty) return 'Tafadhali jaza sehemu hii';
      return null;
    };
    streetTextControllerValidator = (val) {
      if (val == null || val.trim().isEmpty) return 'Tafadhali jaza sehemu hii';
      return null;
    };
    landmarkTextControllerValidator = (val) {
      if (val == null || val.trim().isEmpty) return 'Taja sehemu maarufu karibu nawe';
      return null;
    };
    phoneTextControllerValidator = (val) {
      final t = val?.trim() ?? '';
      if (t.isEmpty) return 'Ingiza namba ya simu';
      if (!RegExp(r"^\+?[0-9]{10,13}$").hasMatch(t)) return 'Namba sahihi: 0712345678';
      return null;
    };
    houseNoTextControllerValidator = (val) {
      if (val == null || val.trim().isEmpty) return 'Tafadhali jaza sehemu hii';
      return null;
    };
    notesTextControllerValidator = (val) {
      if (val == null || val.trim().isEmpty) return 'Tafadhali toa maelezo zaidi.';
      return null;
    };
  }

  @override
  void dispose() {
    districtFocusNode?.dispose();
    districtTextController?.dispose();
    streetFocusNode?.dispose();
    streetTextController?.dispose();
    landmarkFocusNode?.dispose();
    landmarkTextController?.dispose();
    phoneFocusNode?.dispose();
    phoneTextController?.dispose();
    houseNoFocusNode?.dispose();
    houseNoTextController?.dispose();
    notesFocusNode?.dispose();
    notesTextController?.dispose();
  }
}
