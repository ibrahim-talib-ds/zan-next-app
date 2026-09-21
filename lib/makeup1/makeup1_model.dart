import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import 'makeup1_widget.dart' show Makeup1Widget;
import 'package:sticky_headers/sticky_headers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Makeup1Model extends FlutterFlowModel<Makeup1Widget> {
  ///  State fields for stateful widgets in this page.

  final formKey3 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  bool isDataUploading_makeup1 = false;
  List<FFUploadedFile> uploadedLocalFiles_makeup1 = [];
  List<String> uploadedFileUrls_makeup1 = [];

  // State field(s) for Product_Name widget.
  FocusNode? productNameFocusNode;
  TextEditingController? productNameTextController;
  String? Function(BuildContext, String?)? productNameTextControllerValidator;
  String? _productNameTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'mjkcpdlg' /* Please enter a product name */,
      );
    }

    if (val.length > 60) {
      return FFLocalizations.of(context).getText(
        '290t139i' /* Name is too long. Use 60 chara... */,
      );
    }

    return null;
  }

  // State field(s) for Product_Category widget.
  FocusNode? productCategoryFocusNode;
  TextEditingController? productCategoryTextController;
  String? Function(BuildContext, String?)?
      productCategoryTextControllerValidator;
  // State field(s) for ItemCategory widget.
  List<String>? itemCategoryValue;
  FormFieldController<List<String>>? itemCategoryValueController;
  // State field(s) for AlphaSizes widget.
  FormFieldController<List<String>>? alphaSizesValueController;
  String? get alphaSizesValue => alphaSizesValueController?.value?.firstOrNull;
  set alphaSizesValue(String? val) =>
      alphaSizesValueController?.value = val != null ? [val] : [];
  // State field(s) for NumericalSizes widget.
  FormFieldController<List<String>>? numericalSizesValueController;
  String? get numericalSizesValue =>
      numericalSizesValueController?.value?.firstOrNull;
  set numericalSizesValue(String? val) =>
      numericalSizesValueController?.value = val != null ? [val] : [];
  // State field(s) for Materia widget.
  List<String>? materiaValue;
  FormFieldController<List<String>>? materiaValueController;
  // State field(s) for Fit widget.
  FormFieldController<String>? fitValueController;
  // State field(s) for Pattern widget.
  FormFieldController<String>? patternValueController;
  // State field(s) for newin widget.
  FormFieldController<List<String>>? newinValueController;
  String? get newinValue => newinValueController?.value?.firstOrNull;
  set newinValue(String? val) =>
      newinValueController?.value = val != null ? [val] : [];
  // State field(s) for location widget.
  FocusNode? locationFocusNode;
  TextEditingController? locationTextController;
  String? Function(BuildContext, String?)? locationTextControllerValidator;
  // State field(s) for wasap widget.
  FocusNode? wasapFocusNode;
  TextEditingController? wasapTextController;
  String? Function(BuildContext, String?)? wasapTextControllerValidator;
  // State field(s) for Call widget.
  FocusNode? callFocusNode;
  TextEditingController? callTextController;
  String? Function(BuildContext, String?)? callTextControllerValidator;
  // State field(s) for price widget.
  FocusNode? priceFocusNode;
  TextEditingController? priceTextController;
  String? Function(BuildContext, String?)? priceTextControllerValidator;
  String? _priceTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'nh98sicx' /* Please set a price */,
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
        'orzpzy4q' /* Please provide a description o... */,
      );
    }

    if (val.length > 1000) {
      return 'Maximum 1000 characters allowed, currently ${val.length}.';
    }

    return null;
  }

  // State field(s) for treding widget.
  bool? tredingValue;
  // State field(s) for NewArrival widget.
  bool? newArrivalValue;
  // State field(s) for ShowinAll widget.
  bool? showinAllValue;

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

    locationFocusNode?.dispose();
    locationTextController?.dispose();

    wasapFocusNode?.dispose();
    wasapTextController?.dispose();

    callFocusNode?.dispose();
    callTextController?.dispose();

    priceFocusNode?.dispose();
    priceTextController?.dispose();

    productdescriptionFocusNode?.dispose();
    productdescriptionTextController?.dispose();
  }

  /// Additional helper methods.
  String? get fitValue => fitValueController?.value;
  String? get patternValue => patternValueController?.value;
}
