import 'package:flutter/material.dart';
import 'category_service.dart';

/// Bottom sheet that lets admin edit a category.
/// Returns `true` if admin chose "Edit" and saved.
class AdminCategoryEditor extends StatefulWidget {
  const AdminCategoryEditor({
    super.key,
    required this.categoryKey,
    required this.currentImage,
    required this.currentLabel,
    required this.currentRoute,
  });

  final String categoryKey;
  final String currentImage;
  final String currentLabel;
  final String currentRoute;

  @override
  State<AdminCategoryEditor> createState() => _AdminCategoryEditorState();
}

class _AdminCategoryEditorState extends State<AdminCategoryEditor> {
  late TextEditingController _imageController;
  late TextEditingController _labelController;
  late TextEditingController _routeController;
  bool _saving = false;

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kRed = Color(0xFFDC0F0F);

  @override
  void initState() {
    super.initState();
    _imageController = TextEditingController(text: widget.currentImage);
    _labelController = TextEditingController(text: widget.currentLabel);
    _routeController = TextEditingController(text: widget.currentRoute);
  }

  @override
  void dispose() {
    _imageController.dispose();
    _labelController.dispose();
    _routeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await CategoryService.saveCategory(
        widget.categoryKey,
        imageUrl: _imageController.text.trim(),
        label: _labelController.text.trim(),
        routeName: _routeController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category updated'),
          backgroundColor: kGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e'), backgroundColor: kRed),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final text = isDark ? Colors.white : const Color(0xFF111827);
    final muted = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final border = isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44, height: 4,
                decoration: BoxDecoration(
                  color: border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: kGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.edit_rounded, color: kGreen, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Edit "${widget.categoryKey}"',
                          style: TextStyle(color: text, fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text('Admin only',
                          style: TextStyle(color: muted, fontSize: 11.5)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _field(label: 'Image URL', hint: 'https://...',
                controller: _imageController, muted: muted, text: text, border: border),

            const SizedBox(height: 14),
            _field(label: 'Label', hint: 'Category name',
                controller: _labelController, muted: muted, text: text, border: border),

            const SizedBox(height: 14),
            _field(label: 'Route name', hint: 'e.g. Specific_categories',
                controller: _routeController, muted: muted, text: text, border: border),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: border),
                      ),
                    ),
                    child: Text('Cancel',
                        style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                        : const Text('Save',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Color muted,
    required Color text,
    required Color border,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(color: muted, fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2A2A2C)
                : const Color(0xFFF0F2F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: TextField(
            controller: controller,
            style: TextStyle(color: text, fontSize: 13.5),
            cursorColor: kGreen,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: hint,
              hintStyle: TextStyle(color: muted, fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
