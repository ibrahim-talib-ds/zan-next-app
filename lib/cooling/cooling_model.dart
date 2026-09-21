import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_checkbox_group.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import 'cooling_widget.dart' show CoolingWidget;
import 'package:sticky_headers/sticky_headers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CoolingModel extends FlutterFlowModel<CoolingWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey3 = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  bool isDataUploading_cooling = false;
  List<FFUploadedFile> uploadedLocalFiles_cooling = [];
  List<String> uploadedFileUrls_cooling = [];

  // State field(s) for Product_Name widget.
  FocusNode? productNameFocusNode;
  TextEditingController? productNameTextController;
  String? Function(BuildContext, String?)? productNameTextControllerValidator;
  String? _productNameTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'ovgfyfso' /* Please enter a product name */,
      );
    }

    if (val.length > 60) {
      return FFLocalizations.of(context).getText(
        'k1sjv6h4' /* Name is too long. Use 60 chara... */,
      );
    }

    return null;
  }

  // State field(s) for Product_Category widget.
  FocusNode? productCategoryFocusNode;
  TextEditingController? productCategoryTextController;
  String? Function(BuildContext, String?)?
      productCategoryTextControllerValidator;
  // State field(s) for newin widget.
  FormFieldController<List<String>>? newinValueController;
  String? get newinValue => newinValueController?.value?.firstOrNull;
  set newinValue(String? val) =>
      newinValueController?.value = val != null ? [val] : [];
  // State field(s) for phonenumber widget.
  FormFieldController<List<String>>? phonenumberValueController;
  List<String>? get phonenumberValues => phonenumberValueController?.value;
  set phonenumberValues(List<String>? v) =>
      phonenumberValueController?.value = v;

  // State field(s) for price widget.
  FocusNode? priceFocusNode;
  TextEditingController? priceTextController;
  String? Function(BuildContext, String?)? priceTextControllerValidator;
  String? _priceTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'je1anfwk' /* Please set a price */,
      );
    }

    return null;
  }

  // State field(s) for Productdescription widget.
  FocusNode? productdescriptionFocusNode;
  TextEditingController? productdescriptionTextController;
  String? Function(BuildContext, String?)?
      productdescriptionTextControllerValidator;
  String? _productdescriptionTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '8br8rcii' /* Please provide a description o... */,
      );
    }

    if (val.length > 1000) {
      return 'Maximum 1000 characters allowed, currently ${val.length}.';
    }

    return null;
  }

  // State field(s) for treding widget.
  bool? tredingValue;
  // State field(s) for highlight widget.
  bool? highlightValue;

  @override
  void initState(BuildContext context) {
    productNameTextControllerValidator = _productNameTextControllerValidator;
    priceTextControllerValidator = _priceTextControllerValidator;
    productdescriptionTextControllerValidator =
        _productdescriptionTextControllerValidator;
  }

  @override
  void dispose() {
    productNameFocusNode?.dispose();
    productNameTextController?.dispose();

    productCategoryFocusNode?.dispose();
    productCategoryTextController?.dispose();

    priceFocusNode?.dispose();
    priceTextController?.dispose();

    productdescriptionFocusNode?.dispose();
    productdescriptionTextController?.dispose();
  }
}
