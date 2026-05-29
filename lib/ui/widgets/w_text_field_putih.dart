import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class WTextFieldPutih extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const WTextFieldPutih({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.suffixIcon,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.validator,
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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