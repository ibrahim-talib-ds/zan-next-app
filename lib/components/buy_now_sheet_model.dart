import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'buy_now_sheet_widget.dart' show BuyNowSheetWidget;
import 'package:flutter/material.dart';

class BuyNowSheetModel extends FlutterFlowModel<BuyNowSheetWidget> {
  AddressRecord? selectedAddress;
  String? customPhone;
  String? notes;
  bool isPlacing = false;

  FocusNode? phoneFocusNode;
  TextEditingController? phoneController;
  FocusNode? notesFocusNode;
  TextEditingController? notesController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    phoneFocusNode?.dispose();
    phoneController?.dispose();
    notesFocusNode?.dispose();
    notesController?.dispose();
  }
}
