import 'package:cubetest_mobile/core/route/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('MainShell', () {
    GoRouter buildRouter() {
      return GoRouter(
        initialLocation: '/sites',
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) =>
                MainShell(navigationShell: navigationShell),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/sites',
                    builder: (_, _) => const _MarkerPage('SitesContent'),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/tests',
                    builder: (_, _) => const _MarkerPage('TestsContent'),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/dashboard',
                    builder: (_, _) =>
                        const _MarkerPage('DashboardContent'),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/settings',
                    builder: (_, _) => const _MarkerPage('SettingsContent'),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    testWidgets('renders 4 nav items with semantic labels', (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Sites'), findsOneWidget);
      expect(find.bySemanticsLabel('Tests'), findsOneWidget);
      expect(find.bySemanticsLabel('Dashboard'), findsOneWidget);
      expect(find.bySemanticsLabel('Settings'), findsOneWidget);
    });

    testWidgets('starts on Sites branch by default', (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));
      await tester.pumpAndSettle();

      expect(find.text('SitesContent'), findsOneWidget);
    });

    testWidgets('tapping a non-active tab switches branch', (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));
      await tester.pumpAndSettle();

      await tester.tap(find.bySemanticsLabel('Dashboard'));
      await tester.pumpAndSettle();

      expect(find.text('DashboardContent'), findsOneWidget);
    });

    testWidgets(
        'tapping active tab is a no-op '
        '(does not reset branch or rebuild root)', (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));
      await tester.pumpAndSettle();

      final initialBuildCount = _MarkerPageState.buildCount('SitesContent');

      await tester.tap(find.bySemanticsLabel('Sites'));
      await tester.pumpAndSettle();

      expect(find.text('SitesContent'), findsOneWidget);
      expect(
        _MarkerPageState.buildCount('SitesContent'),
        initialBuildCount,
        reason: 'Tapping active tab should not rebuild the branch root',
      );
    });

    testWidgets(
        'preserves state when switching tabs '
        '(IndexedStack keeps page alive)', (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));
      await tester.pumpAndSettle();

      final sitesBuilds = _MarkerPageState.buildCount('SitesContent');

      await tester.tap(find.bySemanticsLabel('Tests'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Sites'));
      await tester.pumpAndSettle();

      expect(
        _MarkerPageState.buildCount('SitesContent'),
        sitesBuilds,
        reason: 'Sites branch root should remain alive across tab switches',
      );
    });
  });
}

class _MarkerPage extends StatefulWidget {
  const _MarkerPage(this.text);

  final String text;

  @override
  State<_MarkerPage> createState() => _MarkerPageState();
}

class _MarkerPageState extends State<_MarkerPage> {
  static final Map<String, int> _builds = <String, int>{};

  static int buildCount(String text) => _builds[text] ?? 0;

  @override
  void initState() {
    super.initState();
    _builds[widget.text] = (_builds[widget.text] ?? 0) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(widget.text)));
  }
}
