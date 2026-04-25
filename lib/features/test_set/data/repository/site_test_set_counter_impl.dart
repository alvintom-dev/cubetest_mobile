import 'package:injectable/injectable.dart';

import '../../../../core/ports/site_test_set_counter.dart';
import '../datasource/test_set_local_datasource.dart';

@Injectable(as: SiteTestSetCounter)
class SiteTestSetCounterImpl implements SiteTestSetCounter {
  const SiteTestSetCounterImpl(this._datasource);

  final TestSetLocalDatasource _datasource;

  @override
  Future<int> countActiveForSite(String siteId) =>
      _datasource.countBySiteId(siteId);
}
