import 'package:cubetest_mobile/core/formatters/date_formatter.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_form_field_card.dart';
import '../../../../shared/widgets/app_segmented_control.dart';
import '../../../../shared/widgets/app_text_form_field.dart';
import '../../domain/entities/test_set.dart';

class TestSetFormData {
  TestSetFormData({
    required this.appointDate,
    this.name,
    this.description,
    required this.requiredStrength,
    required this.status,
  });

  final DateTime appointDate;
  final String? name;
  final String? description;
  final double requiredStrength;
  final TestSetStatus status;
}

class TestSetForm extends StatefulWidget {
  const TestSetForm({
    super.key,
    this.initialTestSet,
    required this.onSubmit,
    required this.submitting,
  });

  final TestSet? initialTestSet;
  final void Function(TestSetFormData data) onSubmit;
  final bool submitting;

  @override
  State<TestSetForm> createState() => _TestSetFormState();
}

class _TestSetFormState extends State<TestSetForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _requiredStrengthController;
  late DateTime _appointDate;
  late TestSetStatus _status;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialTestSet?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialTestSet?.description ?? '');
    _requiredStrengthController = TextEditingController(
      text: widget.initialTestSet?.requiredStrength.toString() ?? '',
    );
    _appointDate = widget.initialTestSet?.appointDate ?? DateTime.now();
    _status = widget.initialTestSet?.status ?? TestSetStatus.active;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _requiredStrengthController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _appointDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _appointDate = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    widget.onSubmit(TestSetFormData(
      appointDate: _appointDate,
      name: _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      requiredStrength: double.parse(_requiredStrengthController.text.trim()),
      status: _status,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialTestSet != null;
    final textTheme = Theme.of(context).textTheme;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppFormFieldCard(
            label: 'Concreting date',
            required: true,
            onTap: widget.submitting ? null : _pickDate,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _appointDate.toReadable(),
                    style: textTheme.bodyLarge,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: AppColors.ink3,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextFormField(
            label: 'Name',
            controller: _nameController,
            hintText: 'Optional',
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextFormField(
            label: 'Description',
            controller: _descriptionController,
            hintText: 'Optional',
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextFormField(
            label: 'Required strength (MPa)',
            required: true,
            controller: _requiredStrengthController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return 'Required strength is required';
              final parsed = double.tryParse(text);
              if (parsed == null) return 'Enter a valid number';
              if (parsed <= 0) return 'Must be greater than 0';
              return null;
            },
          ),
          if (isEdit) ...[
            const SizedBox(height: AppSpacing.md),
            AppFormFieldCard(
              label: 'Status',
              child: AppSegmentedControl<TestSetStatus>(
                value: _status,
                enabled: !widget.submitting,
                itemsPerRow: 2,
                options: const [
                  AppSegmentedOption(
                      value: TestSetStatus.notStarted, label: 'Not started'),
                  AppSegmentedOption(
                      value: TestSetStatus.active, label: 'Active'),
                  AppSegmentedOption(
                      value: TestSetStatus.blocked, label: 'Blocked'),
                  AppSegmentedOption(
                      value: TestSetStatus.completed, label: 'Completed'),
                ],
                onChanged: (value) => setState(() => _status = value),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: widget.submitting ? null : _submit,
            child: widget.submitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isEdit ? 'Save' : 'Create'),
          ),
        ],
      ),
    );
  }
}
