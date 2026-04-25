import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/site.dart';
import '../../domain/usecases/create_site_usecase.dart';
import '../../domain/usecases/update_site_usecase.dart';
import '../blocs/site_detail_cubit/site_detail_cubit.dart';
import '../blocs/site_form_cubit/site_form_cubit.dart';
import '../widgets/site_form.dart';

class SiteFormPage extends StatelessWidget {
  const SiteFormPage({super.key, this.siteId});

  final String? siteId;

  @override
  Widget build(BuildContext context) {
    if (siteId == null) {
      return BlocProvider<SiteFormCubit>(
        create: (_) => getIt<SiteFormCubit>(),
        child: const _SiteFormScaffold(initialSite: null),
      );
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<SiteFormCubit>(create: (_) => getIt<SiteFormCubit>()),
        BlocProvider<SiteDetailCubit>(
          create: (_) => getIt<SiteDetailCubit>()..load(siteId!),
        ),
      ],
      child: BlocBuilder<SiteDetailCubit, SiteDetailState>(
        builder: (context, state) {
          if (state is SiteDetailLoaded) {
            return _SiteFormScaffold(initialSite: state.site);
          }
          if (state is SiteDetailError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Edit Site')),
              body: Center(child: Text(state.message)),
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

class _SiteFormScaffold extends StatelessWidget {
  const _SiteFormScaffold({required this.initialSite});

  final Site? initialSite;

  @override
  Widget build(BuildContext context) {
    final isEdit = initialSite != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Site' : 'Create Site')),
      body: BlocConsumer<SiteFormCubit, SiteFormState>(
        listener: (context, state) {
          if (state is SiteFormSuccess) {
            context.pop();
          } else if (state is SiteFormValidationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is SiteFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final submitting = state is SiteFormSubmitting;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SiteForm(
              initialSite: initialSite,
              submitting: submitting,
              onSubmit: (data) {
                final cubit = context.read<SiteFormCubit>();
                if (isEdit) {
                  cubit.submitUpdate(UpdateSiteUsecaseParam(
                    id: initialSite!.id,
                    name: data.name,
                    location: data.location,
                    description: data.description,
                    status: data.status,
                  ));
                } else {
                  cubit.submitCreate(CreateSiteUsecaseParam(
                    name: data.name,
                    location: data.location,
                    description: data.description,
                    status: data.status,
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

