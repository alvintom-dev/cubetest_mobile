import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'app_form_field_card.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.label,
    this.required = false,
    this.controller,
    this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.enabled = true,
    this.textInputAction,
    this.autovalidateMode,
    this.onChanged,
  });

  final String label;
  final bool required;
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppFormFieldCard(
      label: label,
      required: required,
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        textInputAction: textInputAction,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        cursorColor: AppColors.primary,
        style: textTheme.bodyLarge,
        decoration: InputDecoration(
          isDense: true,
          filled: false,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.ink4),
          errorStyle: textTheme.labelMedium?.copyWith(color: AppColors.danger),
        ),
      ),
    );
  }
}
