import 'package:cubetest_mobile/core/formatters/date_formatter.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_form_field_card.dart';
import '../../../../shared/widgets/app_segmented_control.dart';
import '../../domain/entities/test.dart';

class TestFormData {
  TestFormData({
    required this.type,
    required this.dueDate,
  });

  final TestType type;
  final DateTime dueDate;
}

class TestForm extends StatefulWidget {
  const TestForm({
    super.key,
    required this.concretingDate,
    required this.existingTypes,
    required this.onSubmit,
    required this.submitting,
  });

  final DateTime concretingDate;
  final Set<TestType> existingTypes;
  final void Function(TestFormData data) onSubmit;
  final bool submitting;

  @override
  State<TestForm> createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
  final _formKey = GlobalKey<FormState>();
  late TestType _type;
  late DateTime _dueDate;
  bool _dueDateManuallyEdited = false;

  List<TestType> get _availableTypes => TestType.values
      .where((t) => !widget.existingTypes.contains(t))
      .toList();

  @override
  void initState() {
    super.initState();
    _type = _availableTypes.isNotEmpty ? _availableTypes.first : TestType.day7;
    _dueDate = _defaultDueDateFor(_type);
  }

  DateTime _defaultDueDateFor(TestType type) {
    return widget.concretingDate.add(Duration(days: type.days));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dueDateManuallyEdited = true;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    widget.onSubmit(TestFormData(type: _type, dueDate: _dueDate));
  }

  String _typeLabel(TestType type) {
    switch (type) {
      case TestType.day7:
        return '7-day test';
      case TestType.day14:
        return '14-day test';
      case TestType.day28:
        return '28-day test';
    }
  }

  @override
  Widget build(BuildContext context) {
    final available = _availableTypes;
    final textTheme = Theme.of(context).textTheme;
    if (available.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 48,
                color: AppColors.ink4,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'All test types (7/14/28-day) already exist for this test set.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppFormFieldCard(
            label: 'Type',
            required: true,
            child: AppSegmentedControl<TestType>(
              value: _type,
              enabled: !widget.submitting,
              options: available
                  .map((t) =>
                      AppSegmentedOption(value: t, label: _typeLabel(t)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _type = value;
                  if (!_dueDateManuallyEdited) {
                    _dueDate = _defaultDueDateFor(value);
                  }
                });
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppFormFieldCard(
            label: 'Due date',
            required: true,
            onTap: widget.submitting ? null : _pickDate,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _dueDate.toReadable(),
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
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: widget.submitting ? null : _submit,
            child: widget.submitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create'),
          ),
        ],
      ),
    );
  }
}
