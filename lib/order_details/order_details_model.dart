import '/flutter_flow/flutter_flow_util.dart';
import 'order_details_widget.dart' show OrderDetailsWidget;
import 'package:flutter/material.dart';

class OrderDetailsModel extends FlutterFlowModel<OrderDetailsWidget> {
  /// Which tab is active: 'buyer' or 'seller'.
  String activeTab = 'buyer';

  /// Has the user placed any buyer orders? (drives whether Seller tab shows)
  bool hasSellerOrders = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
