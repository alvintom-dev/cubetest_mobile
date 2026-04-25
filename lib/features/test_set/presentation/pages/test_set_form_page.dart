import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/test_set.dart';
import '../../domain/usecases/create_test_set_usecase.dart';
import '../../domain/usecases/update_test_set_usecase.dart';
import '../blocs/test_set_detail_cubit/test_set_detail_cubit.dart';
import '../blocs/test_set_form_cubit/test_set_form_cubit.dart';
import '../widgets/test_set_form.dart';

class TestSetFormPage extends StatelessWidget {
  const TestSetFormPage({super.key, required this.siteId, this.testSetId});

  final String siteId;
  final String? testSetId;

  @override
  Widget build(BuildContext context) {
    if (testSetId == null) {
      return BlocProvider<TestSetFormCubit>(
        create: (_) => getIt<TestSetFormCubit>(),
        child: _FormScaffold(siteId: siteId, initial: null),
      );
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<TestSetFormCubit>(create: (_) => getIt<TestSetFormCubit>()),
        BlocProvider<TestSetDetailCubit>(
          create: (_) => getIt<TestSetDetailCubit>()..load(testSetId!),
        ),
      ],
      child: BlocBuilder<TestSetDetailCubit, TestSetDetailState>(
        builder: (context, state) {
          if (state is TestSetDetailLoaded) {
            return _FormScaffold(siteId: siteId, initial: state.testSet);
          }
          if (state is TestSetDetailError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Edit Test Set')),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.danger,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(state.message, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class _FormScaffold extends StatelessWidget {
  const _FormScaffold({required this.siteId, required this.initial});

  final String siteId;
  final TestSet? initial;

  @override
  Widget build(BuildContext context) {
    final isEdit = initial != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Test Set' : 'Create Test Set')),
      body: BlocConsumer<TestSetFormCubit, TestSetFormState>(
        listener: (context, state) {
          if (state is TestSetFormSuccess) {
            context.pop();
          } else if (state is TestSetFormValidationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is TestSetFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final submitting = state is TestSetFormSubmitting;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TestSetForm(
              initialTestSet: initial,
              submitting: submitting,
              onSubmit: (data) async {
                final cubit = context.read<TestSetFormCubit>();
                if (isEdit) {
                  if (data.requiredStrength != initial!.requiredStrength) {
                    final confirmed = await _confirmStrengthChange(
                      context,
                      from: initial!.requiredStrength,
                      to: data.requiredStrength,
                    );
                    if (confirmed != true) return;
                  }
                  cubit.submitUpdate(UpdateTestSetUsecaseParam(
                    id: initial!.id,
                    appointDate: data.appointDate,
                    requiredStrength: data.requiredStrength,
                    status: data.status,
                    name: data.name,
                    description: data.description,
                  ));
                } else {
                  cubit.submitCreate(CreateTestSetUsecaseParam(
                    siteId: siteId,
                    appointDate: data.appointDate,
                    requiredStrength: data.requiredStrength,
                    name: data.name,
                    description: data.description,
                  ));
                }
              },
            ),
          );
        },
      ),
    );
  }
}

Future<bool?> _confirmStrengthChange(
  BuildContext context, {
  required double from,
  required double to,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Change required strength?'),
      content: Text(
          'Required strength will change from $from MPa to $to MPa.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}
