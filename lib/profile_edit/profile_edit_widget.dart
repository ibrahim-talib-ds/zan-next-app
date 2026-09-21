import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';

import 'profile_edit_model.dart';
export 'profile_edit_model.dart';

class ProfileEditWidget extends StatefulWidget {
  const ProfileEditWidget({super.key});

  static String routeName = 'ProfileEdit';
  static String routePath = '/profileEdit';

  @override
  State<ProfileEditWidget> createState() => _ProfileEditWidgetState();
}

class _ProfileEditWidgetState extends State<ProfileEditWidget> {
  late ProfileEditModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // Local state
  DateTime? _selectedBirthday;
  bool _isSaving = false;

  // Brand
  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);
  static const Color kBlue = Color(0xFF3B82F6);

  // Theme colors
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _soft   => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFF0F2F5);
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  String _imgUrl(String? url) {
    final u = (url ?? '').trim();
    if (u.isEmpty) return '';
    return u.startsWith('http://') ? u.replaceFirst('http://', 'https://') : u;
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  // ═══════════════════════════════════════════════════════════
  // INIT
  // ═══════════════════════════════════════════════════════════
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileEditModel());

    _model.nameTextController ??=
        TextEditingController(text: currentUserDisplayName);
    _model.nameFocusNode ??= FocusNode();

    _model.emailTextController ??=
        TextEditingController(text: currentUserEmail);
    _model.emailFocusNode ??= FocusNode();

    _model.phoneTextController ??=
        TextEditingController(text: currentPhoneNumber);
    _model.phoneFocusNode ??= FocusNode();

    _model.birthdayTextController ??= TextEditingController();
    _model.birthdayFocusNode ??= FocusNode();

    _selectedBirthday = currentUserDocument?.birthday;
    _model.birthdayTextController?.text = _formatDate(_selectedBirthday);

    final g = currentUserDocument?.gender ?? '';
    if (g.isNotEmpty) {
      _model.choiceChipsValue = g;
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16, 20, 16, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAvatarSection(),
                        const SizedBox(height: 28),
                        _buildFieldLabel('Full Name'),
                        _buildTextField(
                          controller: _model.nameTextController!,
                          focusNode: _model.nameFocusNode!,
                          hint: 'Enter your name',
                          icon: Icons.person_outline_rounded,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Name is required';
                            }
                            if (v.trim().length < 2) {
                              return 'Name is too short';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildFieldLabel('Email Address'),
                        _buildTextField(
                          controller: _model.emailTextController!,
                          focusNode: _model.emailFocusNode!,
                          hint: 'Enter your email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Email is required';
                            }
                            final re =
                                RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\.\-]+$');
                            if (!re.hasMatch(v.trim())) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildFieldLabel('Phone Number'),
                        _buildPhoneField(),
                        const SizedBox(height: 20),
                        _buildFieldLabel('Gender'),
                        _buildGenderChips(),
                        const SizedBox(height: 20),
                        _buildFieldLabel('Birthday'),
                        _buildBirthdayPicker(),
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
            fillColor: Colors.white.withOpacity(0.15),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 22),
            onPressed: () => context.safePop(),
          ),
          const Spacer(),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Update your info',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // AVATAR
  // ═══════════════════════════════════════════════════════════
  Widget _buildAvatarSection() {
    final preview = _model.uploadedFileUrl_uploadDataDr6.isNotEmpty
        ? _model.uploadedFileUrl_uploadDataDr6
        : currentUserPhoto;

    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kGreen, kGreenDeep],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    color: _bg,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: _model.isDataUploading_uploadDataDr6
                        ? Container(
                            color: _soft,
                            child: const Center(
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      kGreen),
                                ),
                              ),
                            ),
                          )
                        : Image.network(
                            _imgUrl(preview),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: _soft,
                              child: Icon(
                                Icons.person_rounded,
                                color: _muted,
                                size: 44,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: GestureDetector(
                  onTap: _model.isDataUploading_uploadDataDr6
                      ? null
                      : _pickAvatar,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: _bg, width: 3),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed:
                _model.isDataUploading_uploadDataDr6 ? null : _pickAvatar,
            child: Text(
              _model.isDataUploading_uploadDataDr6
                  ? 'Uploading...'
                  : 'Change Photo',
              style: const TextStyle(
                color: kGreen,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAvatar() async {
    try {
      final selectedMedia = await selectMediaWithSourceBottomSheet(
        context: context,
        maxWidth: 720,
        maxHeight: 720,
        imageQuality: 90,
        allowPhoto: true,
        textColor: _text,
      );

      if (selectedMedia == null || selectedMedia.isEmpty) return;

      safeSetState(() => _model.isDataUploading_uploadDataDr6 = true);

      try {
        final url = await uploadData(
          selectedMedia.first.storagePath,
          selectedMedia.first.bytes,
        );
        if (url != null && url.isNotEmpty && mounted) {
          safeSetState(() {
            _model.uploadedFileUrl_uploadDataDr6 = url;
          });
        }
      } finally {
        if (mounted) {
          safeSetState(() => _model.isDataUploading_uploadDataDr6 = false);
        }
      }
    } catch (e) {
      debugPrint('Avatar upload error: $e');
      if (!mounted) return;
      safeSetState(() => _model.isDataUploading_uploadDataDr6 = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // FIELD LABEL
  // ═══════════════════════════════════════════════════════════
  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 2, 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: _muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // TEXT FIELD
  // ═══════════════════════════════════════════════════════════
  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
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
        validator: validator,
        style: TextStyle(color: _text, fontSize: 14.5),
        cursorColor: kGreen,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: TextStyle(color: _muted, fontSize: 14),
          prefixIcon: Icon(icon, color: kMutedOrGreen(), size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsetsDirectional.fromSTEB(0, 16, 12, 16),
          errorStyle: const TextStyle(
            color: kRed,
            fontSize: 12,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Color kMutedOrGreen() => _muted;

  // ═══════════════════════════════════════════════════════════
  // PHONE FIELD
  // ═══════════════════════════════════════════════════════════
  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Container(
            width: 28,
            height: 20,
            decoration: BoxDecoration(
              color: kGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                'TZ',
                style: TextStyle(
                  color: kGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(width: 1, height: 28, color: _border),
          Expanded(
            child: TextFormField(
              controller: _model.phoneTextController,
              focusNode: _model.phoneFocusNode,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: _text, fontSize: 14.5),
              cursorColor: kGreen,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Phone is required';
                }
                final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
                if (digits.length < 10 || digits.length > 13) {
                  return 'Enter a valid phone (10-13 digits)';
                }
                return null;
              },
              decoration: InputDecoration(
                isDense: true,
                hintText: '712 345 678',
                hintStyle: TextStyle(color: _muted, fontSize: 14),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(14, 16, 14, 16),
                errorStyle: const TextStyle(
                  color: kRed,
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // GENDER CHIPS
  // ═══════════════════════════════════════════════════════════
  Widget _buildGenderChips() {
    final genders = [
      ('Male', Icons.male_rounded),
      ('Female', Icons.female_rounded),
      ('Other', Icons.transgender_rounded),
    ];

    return Row(
      children: genders.map((g) {
        final isActive = _model.choiceChipsValue == g.$1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: g.$1 == 'Other' ? 0 : 8,
            ),
            child: GestureDetector(
              onTap: () {
                safeSetState(() {
                  _model.choiceChipsValue = isActive ? null : g.$1;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 48,
                decoration: BoxDecoration(
                  color: isActive ? kGreen : _card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isActive ? kGreen : _border,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      g.$2,
                      color: isActive ? Colors.white : _muted,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      g.$1,
                      style: TextStyle(
                        color: isActive ? Colors.white : _text,
                        fontSize: 13,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // BIRTHDAY PICKER
  // ═══════════════════════════════════════════════════════════
  Widget _buildBirthdayPicker() {
    final hasDate = _selectedBirthday != null;
    return GestureDetector(
      onTap: _pickBirthday,
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 12, 16),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(
              Icons.calendar_month_outlined,
              color: hasDate ? kGreen : _muted,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hasDate
                    ? _formatDate(_selectedBirthday)
                    : 'Select your birthday',
                style: TextStyle(
                  color: hasDate ? _text : _muted,
                  fontSize: 14.5,
                  fontWeight: hasDate ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: _muted, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final initial = _selectedBirthday ?? DateTime(now.year - 20, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year - 13, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: kGreen,
              onPrimary: Colors.white,
              surface: _card,
              onSurface: _text,
            ),
            dialogTheme: DialogThemeData(backgroundColor: _card),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      safeSetState(() {
        _selectedBirthday = picked;
        _model.birthdayTextController?.text = _formatDate(picked);
      });
    }
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
        onTap: _isSaving ? null : _save,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: _isSaving ? kGreen.withOpacity(0.5) : kGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: _isSaving
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
                        'Save Changes',
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

  Future<void> _save() async {
    if (_isSaving) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors above'),
          backgroundColor: kRed,
        ),
      );
      return;
    }

    if (currentUserReference == null) return;

    safeSetState(() => _isSaving = true);

    try {
      await currentUserReference!.update(
        createUsersRecordData(
          email: _model.emailTextController!.text.trim(),
          displayName: _model.nameTextController!.text.trim(),
          photoUrl: _model.uploadedFileUrl_uploadDataDr6.isNotEmpty
              ? _model.uploadedFileUrl_uploadDataDr6
              : currentUserPhoto,
          phoneNumber: _model.phoneTextController!.text.trim(),
          gender: _model.choiceChipsValue,
          birthday: _selectedBirthday,
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: kGreen,
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      context.safePop();
    } catch (e) {
      if (!mounted) return;
      safeSetState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save failed: $e'),
          backgroundColor: kRed,
        ),
      );
    }
  }
}
