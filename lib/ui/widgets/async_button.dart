import 'package:flutter/material.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';

class AsyncButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  final double height;

  const AsyncButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.base100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColor.putih100,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: AppFont.semibold().copyWith(
                  fontSize: 16,
                  color: AppColor.putih100,
                ),
              ),
      ),
    );
  }
}
