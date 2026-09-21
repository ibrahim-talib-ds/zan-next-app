import 'package:provider/provider.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'wishlist_prefe_model.dart';
export 'wishlist_prefe_model.dart';

class WishlistPrefeWidget extends StatefulWidget {
  const WishlistPrefeWidget({
    super.key,
    required this.wishLisrDoc,
  });

  final DocumentReference? wishLisrDoc;

  static String routeName = 'wishlistPrefe';
  static String routePath = '/wishlistPrefe';

  @override
  State<WishlistPrefeWidget> createState() => _WishlistPrefeWidgetState();
}

class _WishlistPrefeWidgetState extends State<WishlistPrefeWidget> {
  late WishlistPrefeModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WishlistPrefeModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Text(
          'Preferences — coming soon',
          style: FlutterFlowTheme.of(context).bodyLarge,
        ),
      ),
    );
  }
}
