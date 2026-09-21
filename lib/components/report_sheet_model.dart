import '/flutter_flow/flutter_flow_util.dart';
import 'report_sheet_widget.dart' show ReportSheetWidget;
import 'package:flutter/material.dart';

class ReportSheetModel extends FlutterFlowModel<ReportSheetWidget> {
  String? selectedReason;
  FocusNode? notesFocusNode;
  TextEditingController? notesController;
  bool isSubmitting = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    notesFocusNode?.dispose();
    notesController?.dispose();
  }
}
