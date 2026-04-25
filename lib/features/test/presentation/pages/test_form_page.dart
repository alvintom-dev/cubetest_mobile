import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/test.dart';
import '../../domain/usecases/create_test_usecase.dart';
import '../../domain/usecases/get_tests_usecase.dart';
import '../blocs/test_form_cubit/test_form_cubit.dart';
import '../widgets/test_form.dart';

class TestFormPage extends StatelessWidget {
  const TestFormPage({
    super.key,
    required this.testSetId,
    this.concretingDate,
  });

  final String testSetId;
  final DateTime? concretingDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TestFormCubit>(
      create: (_) => getIt<TestFormCubit>(),
      child: _FormScaffold(
        testSetId: testSetId,
        concretingDate: concretingDate ?? DateTime.now(),
      ),
    );
  }
}

class _FormScaffold extends StatefulWidget {
  const _FormScaffold({
    required this.testSetId,
    required this.concretingDate,
  });

  final String testSetId;
  final DateTime concretingDate;

  @override
  State<_FormScaffold> createState() => _FormScaffoldState();
}

class _FormScaffoldState extends State<_FormScaffold> {
  Set<TestType>? _existingTypes;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadExistingTypes();
  }

  Future<void> _loadExistingTypes() async {
    final usecase = getIt<GetTestsUsecase>();
    final result = await usecase(
      GetTestsUsecaseParam(testSetId: widget.testSetId),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() => _loadError = failure.toString()),
      (tests) => setState(() {
        _existingTypes = tests.map((t) => t.type).toSet();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Test')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loadError != null) {
      return Center(
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
              Text(_loadError!, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
    final existing = _existingTypes;
    if (existing == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return BlocConsumer<TestFormCubit, TestFormState>(
      listener: (context, state) {
        if (state is TestFormSuccess) {
          context.pop();
        } else if (state is TestFormValidationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is TestFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final submitting = state is TestFormSubmitting;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: TestForm(
            concretingDate: widget.concretingDate,
            existingTypes: existing,
            submitting: submitting,
            onSubmit: (data) {
              context.read<TestFormCubit>().submitCreate(
                    CreateTestUsecaseParam(
                      testSetId: widget.testSetId,
                      type: data.type,
                      dueDate: data.dueDate,
                    ),
                  );
            },
          ),
        );
      },
    );
  }
}
