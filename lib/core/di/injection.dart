import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../network/connectivity_service.dart';
import '../cache/cache_manager.dart';
import '../../features/breeds/data/datasources/breeds_remote_datasource.dart';
import '../../features/breeds/data/datasources/breeds_local_datasource.dart';
import '../../features/breeds/data/repositories/breeds_repository_impl.dart';
import '../../features/breeds/domain/repositories/breeds_repository.dart';
import '../../features/breed_detail/data/datasources/fact_remote_datasource.dart';
import '../../features/breed_detail/data/repositories/fact_repository_impl.dart';
import '../../features/breed_detail/domain/repositories/fact_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Core
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityServiceImpl());
  getIt.registerLazySingleton<CacheManager>(() => CacheManager());

  // DataSources
  getIt.registerLazySingleton<BreedsRemoteDataSource>(
    () => BreedsRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<BreedsLocalDataSource>(
    () => BreedsLocalDataSourceImpl(cacheManager: getIt<CacheManager>()),
  );
  getIt.registerLazySingleton<FactRemoteDataSource>(
    () => FactRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<BreedsRepository>(
    () => BreedsRepositoryImpl(
      remoteDataSource: getIt<BreedsRemoteDataSource>(),
      localDataSource: getIt<BreedsLocalDataSource>(),
      connectivityService: getIt<ConnectivityService>(),
    ),
  );
  getIt.registerLazySingleton<FactRepository>(
    () => FactRepositoryImpl(remoteDataSource: getIt<FactRemoteDataSource>()),
  );
}
