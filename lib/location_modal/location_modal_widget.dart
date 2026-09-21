import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/tz_locations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'location_modal_model.dart';
export 'location_modal_model.dart';

class LocationModalWidget extends StatefulWidget {
  const LocationModalWidget({super.key});

  @override
  State<LocationModalWidget> createState() => _LocationModalWidgetState();
}

class _LocationModalWidgetState extends State<LocationModalWidget> {
  late LocationModalModel _model;
  static const Color kGreen = Color(0xFF1B7A4E);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LocationModalModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF121212) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E7EB);

  List<String> get _districts {
    final r = _model.selectedRegion;
    if (r == null || !kTanzaniaLocations.containsKey(r)) return const [];
    return kTanzaniaLocations[r]!.keys.toList();
  }

  List<String> get _wards {
    final r = _model.selectedRegion;
    final d = _model.selectedDistrict;
    if (r == null || d == null) return const [];
    return kTanzaniaLocations[r]?[d] ?? const [];
  }

  bool get _canSave =>
      _model.selectedRegion != null &&
      _model.selectedDistrict != null &&
      _model.selectedWard != null &&
      !_model.saving;

  // ─── Save location ────────────────────────────────────────
  Future<void> _save() async {
    if (!_canSave) return;
    if (currentUserReference == null) return;
    safeSetState(() => _model.saving = true);

    final region = _model.selectedRegion!;
    final district = _model.selectedDistrict!;
    final ward = _model.selectedWard!;
    final displayCity = '$ward, $district, $region';

    try {
      // 1. Upsert the AddressRecord
      final snap = await AddressRecord.collection
          .where('user', isEqualTo: currentUserReference)
          .limit(1)
          .get();

      if (snap.docs.isEmpty) {
        await AddressRecord.collection.doc().set(
              createAddressRecordData(
                user: currentUserReference,
                city: ward,
                district: district,
                streetAddress: '$ward, $district',
                label: 'Home',
                isDefault: true,
                createdTime: getCurrentTimestamp,
              ),
            );
      } else {
        await snap.docs.first.reference.update({
          'city': ward,
          'district': district,
          'street_address': '$ward, $district',
        });
      }

      // 2. Update UsersRecord with city + district for fast reads
      try {
        await currentUserReference!.update({
          'city': ward,
          'district': district,
        });
      } catch (_) {
        // If those fields don't exist on the schema yet, ignore —
        // AddressRecord is still the source of truth.
        debugPrint('📍 User record has no city/district fields');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location set to $displayCity'),
          backgroundColor: kGreen,
        ),
      );
      Navigator.pop(context, displayCity);
    } catch (e) {
      if (!mounted) return;
      safeSetState(() => _model.saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save failed: $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        color: _bg,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _handle(),
              _header(),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _sectionLabel('Region'),
                      _dropdown(
                        hint: 'Select region',
                        value: _model.selectedRegion,
                        items: kTanzaniaLocations.keys.toList(),
                        onChanged: (v) => safeSetState(() {
                          _model.selectedRegion = v;
                          _model.selectedDistrict = null;
                          _model.selectedWard = null;
                        }),
                      ),
                      const SizedBox(height: 14),
                      _sectionLabel('District'),
                      _dropdown(
                        hint: _model.selectedRegion == null
                            ? 'Select region first'
                            : 'Select district',
                        value: _model.selectedDistrict,
                        items: _districts,
                        enabled: _model.selectedRegion != null,
                        onChanged: (v) => safeSetState(() {
                          _model.selectedDistrict = v;
                          _model.selectedWard = null;
                        }),
                      ),
                      const SizedBox(height: 14),
                      _sectionLabel('Ward / Area'),
                      _dropdown(
                        hint: _model.selectedDistrict == null
                            ? 'Select district first'
                            : 'Select ward',
                        value: _model.selectedWard,
                        items: _wards,
                        enabled: _model.selectedDistrict != null,
                        onChanged: (v) =>
                            safeSetState(() => _model.selectedWard = v),
                      ),
                      const SizedBox(height: 22),
                      _saveButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _handle() => Container(
        margin: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 4),
        width: 44,
        height: 4,
        decoration: BoxDecoration(
          color: _border,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  Widget _header() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deliver to',
                      style: TextStyle(
                        color: _text,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 4),
                  Text('Pick your region, district and ward',
                      style: TextStyle(color: _muted, fontSize: 13)),
                ],
              ),
            ),
            FlutterFlowIconButton(
              borderRadius: 8,
              buttonSize: 40,
              fillColor: Colors.transparent,
              icon: Icon(Icons.close_rounded, color: _text, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 6),
        child: Text(text,
            style: TextStyle(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            )),
      );

  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(12, 2, 4, 2),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint,
              style: TextStyle(color: _muted, fontSize: 14)),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: _muted, size: 22),
          dropdownColor: _card,
          style: TextStyle(color: _text, fontSize: 14),
          onChanged: enabled && items.isNotEmpty ? onChanged : null,
          items: items
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

  Widget _saveButton() {
    final enabled = _canSave;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: enabled ? _save : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: enabled
                ? [kGreen, const Color(0xFF0A3A22)]
                : [
                    kGreen.withOpacity(0.4),
                    kGreen.withOpacity(0.4),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: _model.saving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Save Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  )),
        ),
      ),
    );
  }
}
