import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_form_field_card.dart';
import '../../../../shared/widgets/app_segmented_control.dart';
import '../../../../shared/widgets/app_text_form_field.dart';
import '../../domain/entities/site.dart';

class SiteFormData {
  SiteFormData({
    required this.name,
    this.location,
    this.description,
    required this.status,
  });

  final String name;
  final String? location;
  final String? description;
  final SiteStatus status;
}

class SiteForm extends StatefulWidget {
  const SiteForm({
    super.key,
    this.initialSite,
    required this.onSubmit,
    required this.submitting,
  });

  final Site? initialSite;
  final void Function(SiteFormData data) onSubmit;
  final bool submitting;

  @override
  State<SiteForm> createState() => _SiteFormState();
}

class _SiteFormState extends State<SiteForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;
  late SiteStatus _status;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialSite?.name ?? '');
    _locationController =
        TextEditingController(text: widget.initialSite?.location ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialSite?.description ?? '');
    _status = widget.initialSite?.status ?? SiteStatus.open;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    widget.onSubmit(SiteFormData(
      name: _nameController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      status: _status,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextFormField(
            label: 'Site Name',
            required: true,
            controller: _nameController,
            hintText: 'e.g. Harborfront Tower B',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextFormField(
            label: 'Location',
            controller: _locationController,
            hintText: 'e.g. Pier 39, Oakland',
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextFormField(
            label: 'Description',
            controller: _descriptionController,
            hintText: 'Scope, program, notes…',
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.md),
          AppFormFieldCard(
            label: 'Status',
            child: AppSegmentedControl<SiteStatus>(
              value: _status,
              enabled: !widget.submitting,
              options: const [
                AppSegmentedOption(value: SiteStatus.open, label: 'Open'),
                AppSegmentedOption(value: SiteStatus.close, label: 'Closed'),
              ],
              onChanged: (value) => setState(() => _status = value),
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
                : Text(widget.initialSite == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }
}
