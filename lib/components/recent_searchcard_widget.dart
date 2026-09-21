import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'recent_searchcard_model.dart';
export 'recent_searchcard_model.dart';

class RecentSearchcardWidget extends StatefulWidget {
  const RecentSearchcardWidget({super.key});

  @override
  State<RecentSearchcardWidget> createState() => _RecentSearchcardWidgetState();
}

class _RecentSearchcardWidgetState extends State<RecentSearchcardWidget> {
  late RecentSearchcardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecentSearchcardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.history_rounded,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 18.0,
              ),
              Text(
                valueOrDefault<String>(
                  _model.inventoryD?.inventoryName,
                  'T-Shirt',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ].divide(SizedBox(width: 6.0)),
          ),
          Icon(
            Icons.close,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 20.0,
          ),
        ],
      ),
    );
  }
}
