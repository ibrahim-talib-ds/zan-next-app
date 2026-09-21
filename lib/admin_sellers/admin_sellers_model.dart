import '/flutter_flow/flutter_flow_util.dart';
import 'admin_sellers_widget.dart' show AdminSellersWidget;
import 'package:flutter/material.dart';

class AdminSellersModel extends FlutterFlowModel<AdminSellersWidget> {
  FocusNode? searchFocusNode;
  TextEditingController? searchController;
  String searchQuery = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchController?.dispose();
  }
}
