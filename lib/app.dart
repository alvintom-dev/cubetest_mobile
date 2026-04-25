import 'package:cubetest_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'core/route/router.dart';

class CubeTestApp extends StatelessWidget {
  const CubeTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cube Test',
      routerConfig: appRouter,
      theme: AppTheme.light(),
    );
  }
}
