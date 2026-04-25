import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/site/presentation/pages/site_detail_page.dart';
import '../../features/site/presentation/pages/site_form_page.dart';
import '../../features/site/presentation/pages/sites_archive_page.dart';
import '../../features/site/presentation/pages/sites_page.dart';
import '../../features/test/presentation/pages/test_detail_page.dart';
import '../../features/test/presentation/pages/test_form_page.dart';
import '../../features/test/presentation/pages/tests_page.dart';
import '../../features/test_set/presentation/pages/test_set_detail_page.dart';
import '../../features/test_set/presentation/pages/test_set_form_page.dart';
import '../../features/test_set/presentation/pages/test_sets_page.dart';
import '../../features/tests_overview/presentation/pages/tests_overview_page.dart';
import 'main_shell.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _sitesBranchKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _testsBranchKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _dashboardBranchKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _settingsBranchKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.sitesPath,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _sitesBranchKey,
          routes: [
            GoRoute(
              path: AppRoutes.sitesPath,
              name: AppRoutes.sites,
              builder: (context, state) => const SitesPage(),
              routes: [
                GoRoute(
                  path: AppRoutes.siteCreatePath,
                  name: AppRoutes.siteCreate,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const SiteFormPage(),
                ),
                GoRoute(
                  path: AppRoutes.sitesArchivePath,
                  name: AppRoutes.sitesArchive,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const SitesArchivePage(),
                ),
                GoRoute(
                  path: AppRoutes.siteDetailPath,
                  name: AppRoutes.siteDetail,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['id'];
                    if (id == null || id.isEmpty) {
                      return const _RouteErrorPage(message: 'Missing site id');
                    }
                    return SiteDetailPage(siteId: id);
                  },
                  routes: [
                    GoRoute(
                      path: AppRoutes.testSetsPath,
                      name: AppRoutes.testSets,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final siteId = state.pathParameters['id'];
                        if (siteId == null || siteId.isEmpty) {
                          return const _RouteErrorPage(
                              message: 'Missing site id');
                        }
                        return TestSetsPage(siteId: siteId);
                      },
                      routes: [
                        GoRoute(
                          path: AppRoutes.testSetCreatePath,
                          name: AppRoutes.testSetCreate,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) {
                            final siteId = state.pathParameters['id'];
                            if (siteId == null || siteId.isEmpty) {
                              return const _RouteErrorPage(
                                  message: 'Missing site id');
                            }
                            return TestSetFormPage(siteId: siteId);
                          },
                        ),
                        GoRoute(
                          path: AppRoutes.testSetDetailPath,
                          name: AppRoutes.testSetDetail,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) {
                            final testSetId =
                                state.pathParameters['testSetId'];
                            if (testSetId == null || testSetId.isEmpty) {
                              return const _RouteErrorPage(
                                  message: 'Missing test set id');
                            }
                            return TestSetDetailPage(testSetId: testSetId);
                          },
                          routes: [
                            GoRoute(
                              path: AppRoutes.testsPath,
                              name: AppRoutes.tests,
                              parentNavigatorKey: _rootNavigatorKey,
                              builder: (context, state) {
                                final siteId = state.pathParameters['id'];
                                final testSetId =
                                    state.pathParameters['testSetId'];
                                if (siteId == null ||
                                    siteId.isEmpty ||
                                    testSetId == null ||
                                    testSetId.isEmpty) {
                                  return const _RouteErrorPage(
                                      message: 'Missing ids for tests');
                                }
                                final extra = state.extra;
                                return TestsPage(
                                  siteId: siteId,
                                  testSetId: testSetId,
                                  concretingDate:
                                      extra is DateTime ? extra : null,
                                );
                              },
                              routes: [
                                GoRoute(
                                  path: AppRoutes.testCreatePath,
                                  name: AppRoutes.testCreate,
                                  parentNavigatorKey: _rootNavigatorKey,
                                  builder: (context, state) {
                                    final testSetId =
                                        state.pathParameters['testSetId'];
                                    if (testSetId == null ||
                                        testSetId.isEmpty) {
                                      return const _RouteErrorPage(
                                          message: 'Missing test set id');
                                    }
                                    final extra = state.extra;
                                    return TestFormPage(
                                      testSetId: testSetId,
                                      concretingDate:
                                          extra is DateTime ? extra : null,
                                    );
                                  },
                                ),
                                GoRoute(
                                  path: AppRoutes.testDetailPath,
                                  name: AppRoutes.testDetail,
                                  parentNavigatorKey: _rootNavigatorKey,
                                  builder: (context, state) {
                                    final testId =
                                        state.pathParameters['testId'];
                                    if (testId == null || testId.isEmpty) {
                                      return const _RouteErrorPage(
                                          message: 'Missing test id');
                                    }
                                    return TestDetailPage(testId: testId);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        GoRoute(
                          path: AppRoutes.testSetEditPath,
                          name: AppRoutes.testSetEdit,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) {
                            final siteId = state.pathParameters['id'];
                            final testSetId =
                                state.pathParameters['testSetId'];
                            if (siteId == null ||
                                siteId.isEmpty ||
                                testSetId == null ||
                                testSetId.isEmpty) {
                              return const _RouteErrorPage(
                                  message: 'Missing ids for test set edit');
                            }
                            return TestSetFormPage(
                              siteId: siteId,
                              testSetId: testSetId,
                            );
                          },
                        ),
                      ],
                    ),
                    GoRoute(
                      path: AppRoutes.siteEditPath,
                      name: AppRoutes.siteEdit,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final id = state.pathParameters['id'];
                        if (id == null || id.isEmpty) {
                          return const _RouteErrorPage(
                              message: 'Missing site id');
                        }
                        return SiteFormPage(siteId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _testsBranchKey,
          routes: [
            GoRoute(
              path: AppRoutes.testsOverviewPath,
              name: AppRoutes.testsOverview,
              builder: (context, state) => const TestsOverviewPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _dashboardBranchKey,
          routes: [
            GoRoute(
              path: AppRoutes.dashboardPath,
              name: AppRoutes.dashboard,
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsBranchKey,
          routes: [
            GoRoute(
              path: AppRoutes.settingsPath,
              name: AppRoutes.settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) =>
      _RouteErrorPage(message: state.error?.toString() ?? 'Unknown route'),
);

class _RouteErrorPage extends StatelessWidget {
  const _RouteErrorPage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(message)),
    );
  }
}
