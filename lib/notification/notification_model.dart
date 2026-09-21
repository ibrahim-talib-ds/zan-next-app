import '/flutter_flow/flutter_flow_util.dart';
import 'notification_widget.dart' show NotificationWidget;
import 'package:flutter/material.dart';

/// Which filter chip is currently active.
enum NotifyFilter { all, message, product, auth, promo, favorite, review, social, system }

class NotificationModel extends FlutterFlowModel<NotificationWidget> {
  bool isMarkingAll = false;
  NotifyFilter selectedFilter = NotifyFilter.all;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
