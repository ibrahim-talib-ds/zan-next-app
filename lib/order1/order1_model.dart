import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'order1_widget.dart' show Order1Widget;
import 'package:flutter/material.dart';

class Order1Model extends FlutterFlowModel<Order1Widget> {
  /// Selected order (from route param or streamed)
  OrdersRecord? order;

  bool isCancelling = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
