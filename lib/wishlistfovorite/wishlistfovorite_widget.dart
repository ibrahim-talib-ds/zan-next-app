import 'package:provider/provider.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'wishlistfovorite_model.dart';
export 'wishlistfovorite_model.dart';

class WishlistfovoriteWidget extends StatefulWidget {
  const WishlistfovoriteWidget({
    super.key,
    required this.wishlistRef,
  });

  final DocumentReference? wishlistRef;

  static String routeName = 'Wishlistfovorite';
  static String routePath = '/wishlistfovorite';

  @override
  State<WishlistfovoriteWidget> createState() =>
      _WishlistfovoriteWidgetState();
}

class _WishlistfovoriteWidgetState extends State<WishlistfovoriteWidget> {
  late WishlistfovoriteModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WishlistfovoriteModel());
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
          'Favorites — coming soon',
          style: FlutterFlowTheme.of(context).bodyLarge,
        ),
      ),
    );
  }
}
