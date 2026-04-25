import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_text_form_field.dart';
import '../../domain/entities/cube_result_set.dart';

class CubeResultSetFormData {
  CubeResultSetFormData({
    this.load1,
    this.load2,
    this.load3,
    required this.strength1,
    required this.strength2,
    required this.strength3,
    this.notes,
  });

  final double? load1;
  final double? load2;
  final double? load3;
  final double strength1;
  final double strength2;
  final double strength3;
  final String? notes;
}

class CubeResultSetForm extends StatefulWidget {
  const CubeResultSetForm({
    super.key,
    this.initial,
    required this.onSubmit,
    required this.submitting,
  });

  final CubeResultSet? initial;
  final void Function(CubeResultSetFormData data) onSubmit;
  final bool submitting;

  @override
  State<CubeResultSetForm> createState() => _CubeResultSetFormState();
}

class _CubeResultSetFormState extends State<CubeResultSetForm> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _strengthControllers;
  late final List<TextEditingController> _loadControllers;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _strengthControllers = [
      TextEditingController(text: initial?.strength1.toString() ?? ''),
      TextEditingController(text: initial?.strength2.toString() ?? ''),
      TextEditingController(text: initial?.strength3.toString() ?? ''),
    ];
    _loadControllers = [
      TextEditingController(text: initial?.load1?.toString() ?? ''),
      TextEditingController(text: initial?.load2?.toString() ?? ''),
      TextEditingController(text: initial?.load3?.toString() ?? ''),
    ];
    _notesController = TextEditingController(text: initial?.notes ?? '');
    for (final controller in _strengthControllers) {
      controller.addListener(_onStrengthChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in _strengthControllers) {
      controller.removeListener(_onStrengthChanged);
      controller.dispose();
    }
    for (final controller in _loadControllers) {
      controller.dispose();
    }
    _notesController.dispose();
    super.dispose();
  }

  void _onStrengthChanged() => setState(() {});

  double? get _averageStrength {
    final values = <double>[];
    for (final controller in _strengthControllers) {
      final parsed = double.tryParse(controller.text.trim());
      if (parsed == null || parsed <= 0) return null;
      values.add(parsed);
    }
    if (values.length != 3) return null;
    return values.reduce((a, b) => a + b) / 3;
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    double parseRequired(int i) =>
        double.parse(_strengthControllers[i].text.trim());
    double? parseOptional(int i) {
      final text = _loadControllers[i].text.trim();
      return text.isEmpty ? null : double.parse(text);
    }

    final notesText = _notesController.text.trim();
    widget.onSubmit(CubeResultSetFormData(
      strength1: parseRequired(0),
      strength2: parseRequired(1),
      strength3: parseRequired(2),
      load1: parseOptional(0),
      load2: parseOptional(1),
      load3: parseOptional(2),
      notes: notesText.isEmpty ? null : notesText,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    final textTheme = Theme.of(context).textTheme;
    final average = _averageStrength;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEdit ? 'Edit result' : 'New result',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < 3; i++) ...[
            _CubeInputGroup(
              label: 'Cube ${i + 1}',
              strengthController: _strengthControllers[i],
              loadController: _loadControllers[i],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Average strength', style: textTheme.titleSmall),
                Text(
                  average == null
                      ? '—'
                      : '${average.toStringAsFixed(2)} MPa',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryInk,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextFormField(
            label: 'Notes',
            controller: _notesController,
            hintText: 'Optional',
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: widget.submitting ? null : _submit,
            child: widget.submitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isEdit ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }
}

class _CubeInputGroup extends StatelessWidget {
  const _CubeInputGroup({
    required this.label,
    required this.strengthController,
    required this.loadController,
  });

  final String label;
  final TextEditingController strengthController;
  final TextEditingController loadController;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          _InlineLabeledField(
            label: 'Strength (MPa)',
            required: true,
            controller: strengthController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return 'Required';
              final parsed = double.tryParse(text);
              if (parsed == null) return 'Enter a valid number';
              if (parsed <= 0) return 'Must be greater than 0';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          _InlineLabeledField(
            label: 'Load (kN)',
            controller: loadController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return null;
              final parsed = double.tryParse(text);
              if (parsed == null) return 'Enter a valid number';
              if (parsed <= 0) return 'Must be greater than 0';
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class _InlineLabeledField extends StatelessWidget {
  const _InlineLabeledField({
    required this.label,
    required this.controller,
    this.required = false,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final bool required;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(color: AppColors.ink3),
            ),
            if (required) ...[
              const SizedBox(width: 2),
              Text(
                '*',
                style: textTheme.labelMedium?.copyWith(
                  color: AppColors.danger,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
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
            errorStyle:
                textTheme.labelMedium?.copyWith(color: AppColors.danger),
          ),
        ),
      ],
    );
  }
}
