import 'package:flutter/material.dart';
import 'package:ride_booking/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final String? hintText;

  final TextEditingController? controller;

  final TextInputType keyboardType;

  final bool obscureText;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final String? Function(String?)? validator;

  final void Function(String)? onChanged;

  final bool enabled;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.title,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.surface,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          readOnly: readOnly,

          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,

            hintText: hintText ?? 'Enter ${title.toLowerCase()}',

            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
