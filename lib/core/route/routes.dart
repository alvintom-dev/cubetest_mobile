class AppRoutes {
  const AppRoutes._();

  // Site route names
  static const sites = 'sites';
  static const siteDetail = 'siteDetail';
  static const siteCreate = 'siteCreate';
  static const siteEdit = 'siteEdit';
  static const sitesArchive = 'sitesArchive';

  // Site route paths
  static const sitesPath = '/sites';
  static const siteDetailPath = ':id';
  static const siteCreatePath = 'create';
  static const siteEditPath = ':id/edit';
  static const sitesArchivePath = 'archive';

  // Test Set route names
  static const testSets = 'testSets';
  static const testSetDetail = 'testSetDetail';
  static const testSetCreate = 'testSetCreate';
  static const testSetEdit = 'testSetEdit';

  // Test Set route paths (nested under siteDetail)
  static const testSetsPath = 'test-sets';
  static const testSetDetailPath = ':testSetId';
  static const testSetCreatePath = 'create';
  static const testSetEditPath = ':testSetId/edit';

  // Test route names
  static const tests = 'tests';
  static const testDetail = 'testDetail';
  static const testCreate = 'testCreate';

  // Test route paths (nested under testSetDetail)
  static const testsPath = 'tests';
  static const testDetailPath = ':testId';
  static const testCreatePath = 'create';

  // Bottom-nav tab route names
  static const testsOverview = 'testsOverview';
  static const dashboard = 'dashboard';
  static const settings = 'settings';

  // Bottom-nav tab route paths (top-level)
  static const testsOverviewPath = '/tests';
  static const dashboardPath = '/dashboard';
  static const settingsPath = '/settings';
}
