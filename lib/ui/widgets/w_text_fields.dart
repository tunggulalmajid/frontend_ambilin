/// File gabungan untuk seluruh widget input teks di aplikasi Ambilin.
/// Berisi: WTextFieldPutih, WPasswordField, WDropdownField.
///
/// Catatan: Widget [WTextField] lama yang menggunakan AppColor.base20 sebagai
/// fillColor telah dihapus. Seluruh halaman kini menggunakan [WTextFieldPutih]
/// sebagai komponen input standar.
library;

import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

// ============================================================================
// 1. WTextFieldPutih — Text field standar dengan label luar dan latar putih.
// ============================================================================

class WTextFieldPutih extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;

  const WTextFieldPutih({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.suffixIcon,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Komponen Label Luar
        Text(
          label,
          style: AppFont.semibold().copyWith(
            fontSize: 14,
            color: AppColor.font100,
          ),
        ),
        const SizedBox(height: 8),

        // Komponen Form Input
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppFont.regular().copyWith(
            fontSize: 14,
            color: AppColor.font100,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppFont.regular().copyWith(
              fontSize: 14,
              color: AppColor.font80,
            ),
            filled: true,
            fillColor: AppColor.putih100,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(minHeight: 24),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.font60),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.base100, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 2. WPasswordField — Password field dengan toggle visibilitas.
// ============================================================================

class WPasswordField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const WPasswordField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
  });

  @override
  State<WPasswordField> createState() => _WPasswordFieldState();
}

class _WPasswordFieldState extends State<WPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          widget.label,
          style: AppFont.semibold().copyWith(
            fontSize: 14,
            color: AppColor.font100,
          ),
        ),
        const SizedBox(height: 8),

        // Password Input
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppFont.regular().copyWith(
            fontSize: 14,
            color: AppColor.font100,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppFont.regular().copyWith(
              fontSize: 14,
              color: AppColor.font80,
            ),
            filled: true,
            fillColor: AppColor.putih100,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColor.font80,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.font60),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.base100, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 3. WDropdownField — Dropdown field dengan label luar.
// ============================================================================

class WDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const WDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          label,
          style: AppFont.semibold().copyWith(
            fontSize: 14,
            color: AppColor.font100,
          ),
        ),
        const SizedBox(height: 8),

        // Dropdown
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            hintText,
            style: AppFont.regular().copyWith(
              fontSize: 14,
              color: AppColor.font80,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColor.font80),
          style: AppFont.regular().copyWith(
            fontSize: 14,
            color: AppColor.font100,
          ),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.putih100,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.font60),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.base100, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
