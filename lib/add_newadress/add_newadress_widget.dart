import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import 'add_newadress_model.dart';
export 'add_newadress_model.dart';

class AddNewadressWidget extends StatefulWidget {
  const AddNewadressWidget({super.key});

  static String routeName = 'AddNewadress';
  static String routePath = '/addNewadress';

  @override
  State<AddNewadressWidget> createState() => _AddNewadressWidgetState();
}

class _AddNewadressWidgetState extends State<AddNewadressWidget> {
  late AddNewadressModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF3B82F6);

  // Tanzania regions
  static const List<String> kCities = [
    'Mjini Magharibi (Unguja)',
    'Kaskazini Unguja',
    'Kusini Unguja',
    'Kaskazini Pemba',
    'Kusini Pemba',
    'Dar es Salaam',
    'Arusha',
    'Mwanza',
    'Dodoma',
    'Tanga',
    'Kilimanjaro',
    'Mbeya',
    'Morogoro',
    'Tabora',
    'Kigoma',
  ];

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _soft   => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFF0F2F5);
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddNewadressModel());

    _model.districtTextController ??= TextEditingController();
    _model.districtFocusNode ??= FocusNode();
    _model.streetTextController ??= TextEditingController();
    _model.streetFocusNode ??= FocusNode();
    _model.landmarkTextController ??= TextEditingController();
    _model.landmarkFocusNode ??= FocusNode();
    _model.phoneTextController ??=
        TextEditingController(text: currentPhoneNumber ?? '');
    _model.phoneFocusNode ??= FocusNode();
    _model.houseNoTextController ??= TextEditingController();
    _model.houseNoFocusNode ??= FocusNode();
    _model.notesTextController ??= TextEditingController();
    _model.notesFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: error ? kRed : kGreen,
    ));
  }

  Future<void> _save() async {
    if (_model.isSaving) return;
    if (!(_model.formKey.currentState?.validate() ?? false)) return;
    if (_model.selectedLabel == null) {
      _snack('Chagua aina ya anwani', error: true);
      return;
    }
    if (_model.selectedCity == null) {
      _snack('Chagua mji / mkoa', error: true);
      return;
    }

    safeSetState(() => _model.isSaving = true);
    try {
      await AddressRecord.collection.doc().set(createAddressRecordData(
            user: currentUserReference,
            streetAddress: _model.streetTextController!.text.trim(),
            phone: _model.phoneTextController!.text.trim(),
            createdTime: getCurrentTimestamp,
            label: _model.selectedLabel,
            city: _model.selectedCity,
            district: _model.districtTextController!.text.trim(),
            landmark: _model.landmarkTextController!.text.trim(),
            houseNo: _model.houseNoTextController!.text.trim(),
            notes: _model.notesTextController!.text.trim(),
          ));
      if (!mounted) return;
      _snack('Anwani imehifadhiwa kikamilifu!');
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      context.safePop();
    } catch (e) {
      if (!mounted) return;
      safeSetState(() => _model.isSaving = false);
      _snack('Imeshindwa kuhifadhi: $e', error: true);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _bg,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelPicker(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Location'),
                        const SizedBox(height: 10),
                        _buildCityPicker(),
                        const SizedBox(height: 16),
                        _buildDistrictField(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Address Details'),
                        const SizedBox(height: 10),
                        _buildStreetField(),
                        const SizedBox(height: 16),
                        _buildLandmarkField(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Contact & Building'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildPhoneField()),
                            const SizedBox(width: 12),
                            Expanded(child: _buildHouseNoField()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Delivery Instructions'),
                        const SizedBox(height: 10),
                        _buildNotesField(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
              _buildSaveBar(),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeader() {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(8, topPad + 8, 16, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreen, kGreenDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 24,
            borderWidth: 1,
            buttonSize: 44,
            fillColor: Colors.white.withOpacity(0.18),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 22),
            onPressed: () => context.safePop(),
          ),
          const Spacer(),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add New Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(height: 2),
              Text('Where should we deliver?',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SECTION TITLE
  // ═══════════════════════════════════════════════════════════
  Widget _buildSectionTitle(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: kGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: _text,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // LABEL PICKER (visual chips, not dropdown)
  // ═══════════════════════════════════════════════════════════
  Widget _buildLabelPicker() {
    final options = [
      ('Home', Icons.home_rounded),
      ('Office', Icons.work_outline_rounded),
      ('Other', Icons.location_on_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 14,
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Address Type',
              style: TextStyle(
                color: _text,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: options.map((opt) {
            final isActive = _model.selectedLabel == opt.$1;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: opt.$1 == 'Other' ? 0 : 10,
                ),
                child: GestureDetector(
                  onTap: () => safeSetState(() {
                    _model.selectedLabel = opt.$1;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 60,
                    decoration: BoxDecoration(
                      color: isActive ? kGreen : _card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isActive ? kGreen : _border,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          opt.$2,
                          color: isActive ? Colors.white : _muted,
                          size: 18,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          opt.$1,
                          style: TextStyle(
                            color: isActive ? Colors.white : _text,
                            fontSize: 12,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // CITY PICKER (dropdown)
  // ═══════════════════════════════════════════════════════════
  Widget _buildCityPicker() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(14, 2, 4, 2),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _model.selectedCity,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(Icons.location_city_outlined, size: 18, color: _muted),
              const SizedBox(width: 10),
              Text('Select city or region',
                  style: TextStyle(color: _muted, fontSize: 14)),
            ],
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: _muted, size: 22),
          dropdownColor: _card,
          style: TextStyle(color: _text, fontSize: 14),
          onChanged: (v) => safeSetState(() => _model.selectedCity = v),
          items: kCities
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _text, fontSize: 14)),
                  ))
              .toList(),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // FIELDS
  // ═══════════════════════════════════════════════════════════
  Widget _buildDistrictField() => _buildTextField(
        controller: _model.districtTextController!,
        focusNode: _model.districtFocusNode!,
        hint: 'Wilaya au Kata',
        icon: Icons.map_outlined,
        validator: _model.districtTextControllerValidator,
      );

  Widget _buildStreetField() => _buildTextField(
        controller: _model.streetTextController!,
        focusNode: _model.streetFocusNode!,
        hint: 'Jina la mtaa',
        icon: Icons.signpost_outlined,
        validator: _model.streetTextControllerValidator,
      );

  Widget _buildLandmarkField() => _buildTextField(
        controller: _model.landmarkTextController!,
        focusNode: _model.landmarkFocusNode!,
        hint: 'Sehemu maarufu iliyo karibu',
        icon: Icons.place_outlined,
        validator: _model.landmarkTextControllerValidator,
      );

  Widget _buildPhoneField() => _buildTextField(
        controller: _model.phoneTextController!,
        focusNode: _model.phoneFocusNode!,
        hint: 'Namba ya simu',
        icon: Icons.phone_outlined,
        keyboardType: TextInputType.phone,
        validator: _model.phoneTextControllerValidator,
      );

  Widget _buildHouseNoField() => _buildTextField(
        controller: _model.houseNoTextController!,
        focusNode: _model.houseNoFocusNode!,
        hint: 'Namba ya nyumba',
        icon: Icons.home_outlined,
        validator: _model.houseNoTextControllerValidator,
      );

  Widget _buildNotesField() => _buildTextField(
        controller: _model.notesTextController!,
        focusNode: _model.notesFocusNode!,
        hint: 'Maelekezo zaidi ya kufika (mfano: nyumba ya rangi ya bluu)',
        icon: Icons.notes_rounded,
        maxLines: 5,
        minLines: 4,
        validator: _model.notesTextControllerValidator,
        alignTop: true,
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int minLines = 1,
    bool alignTop = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLines: maxLines,
        minLines: minLines,
        textAlignVertical:
            alignTop ? TextAlignVertical.top : TextAlignVertical.center,
        validator: validator,
        style: TextStyle(color: _text, fontSize: 14.5),
        cursorColor: kGreen,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: TextStyle(color: _muted, fontSize: 14),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: 14,
              right: 10,
              bottom: alignTop ? (maxLines * 24).toDouble() - 12 : 0,
            ),
            child: Icon(icon, color: _muted, size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          contentPadding: EdgeInsetsDirectional.fromSTEB(
              0, alignTop ? 16 : 16, 14, alignTop ? 16 : 16),
          errorStyle: const TextStyle(
            color: kRed,
            fontSize: 12,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SAVE BAR
  // ═══════════════════════════════════════════════════════════
  Widget _buildSaveBar() {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: _card,
        border: Border(top: BorderSide(color: _border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: _model.isSaving ? null : _save,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: _model.isSaving ? kGreen.withOpacity(0.5) : kGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: _model.isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_rounded,
                          color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Save Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
