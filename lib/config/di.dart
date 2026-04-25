import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../features/site/data/datasource/site_local_datasource.dart';
import 'di.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  getIt.registerLazySingleton<Uuid>(() => const Uuid());

  final database = await SiteLocalDatasource.openDatabaseInstance();
  getIt.registerLazySingleton<Database>(() => database);

  getIt.init();
}
