import '/flutter_flow/flutter_flow_util.dart';
import 'specific_categories_widget.dart' show SpecificCategoriesWidget;
import 'package:flutter/material.dart';

class SpecificCategoriesModel
    extends FlutterFlowModel<SpecificCategoriesWidget> {
  /// Sort mode: 'popular' | 'price_low' | 'price_high' | 'newest'
  String sortMode = 'popular';

  /// Optional price range filter (TZS)
  double? minPrice;
  double? maxPrice;

  bool showFilters = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
