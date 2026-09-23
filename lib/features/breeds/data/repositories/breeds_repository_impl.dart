import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/connectivity_service.dart';
import '../datasources/breeds_local_datasource.dart';
import '../datasources/breeds_remote_datasource.dart';
import '../models/breed_model.dart';
import '../../domain/entities/breed.dart';
import '../../domain/repositories/breeds_repository.dart';

class BreedsRepositoryImpl implements BreedsRepository {
  final BreedsRemoteDataSource remoteDataSource;
  final BreedsLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  BreedsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
  });

  @override
  Future<BreedsResult> getBreeds({required int page, bool forceRefresh = false}) async {
    final hasNet = await connectivityService.hasConnection();
    final cached = await localDataSource.getCachedBreeds(page);
    final lastUpdated = await localDataSource.getLastCachedTimestamp();

    // 1. If forceRefresh, bypass cache and fetch network
    if (forceRefresh) {
      if (!hasNet) {
        if (cached != null) {
          return _resultFromCache(cached.data, page, isFromCache: true, lastUpdated: lastUpdated);
        }
        throw const NetworkException('No connection to refresh breeds');
      }
      return await _fetchAndCacheRemote(page);
    }

    // 2. Cache logic: Fresh cache -> Return immediately
    if (cached != null && !cached.isExpired && !cached.isStale) {
      return _resultFromCache(cached.data, page, isFromCache: !hasNet, lastUpdated: lastUpdated);
    }

    // 3. Stale cache: return cached data immediately, update in background if online
    if (cached != null && cached.isStale) {
      if (hasNet) {
        // Trigger silent background update
        _fetchAndCacheRemote(page).ignore();
      }
      return _resultFromCache(cached.data, page, isFromCache: !hasNet, lastUpdated: lastUpdated);
    }

    // 4. Expired or no cache: fetch remote
    if (hasNet) {
      try {
        return await _fetchAndCacheRemote(page);
      } catch (e) {
        if (cached != null) {
          return _resultFromCache(cached.data, page, isFromCache: true, lastUpdated: lastUpdated);
        }
        rethrow;
      }
    }

    // 5. Offline with cached data fallback
    if (cached != null) {
      return _resultFromCache(cached.data, page, isFromCache: true, lastUpdated: lastUpdated);
    }

    throw const NetworkException('No network connection and no cached data available');
  }

  Future<BreedsResult> _fetchAndCacheRemote(int page) async {
    final remoteResponse = await remoteDataSource.getBreeds(page: page);
    await localDataSource.cacheBreeds(page, remoteResponse.data);

    final breeds = remoteResponse.data.map(_mapModelToEntity).toList();
    final now = DateTime.now();

    return BreedsResult(
      breeds: breeds,
      currentPage: remoteResponse.currentPage,
      lastPage: remoteResponse.lastPage,
      total: remoteResponse.total,
      isFromCache: false,
      lastUpdated: now,
    );
  }

  BreedsResult _resultFromCache(
    List<BreedModel> models,
    int page, {
    required bool isFromCache,
    DateTime? lastUpdated,
  }) {
    return BreedsResult(
      breeds: models.map(_mapModelToEntity).toList(),
      currentPage: page,
      lastPage: 20, // Estimated/cached last page
      total: 98,
      isFromCache: isFromCache,
      lastUpdated: lastUpdated,
    );
  }

  @override
  Future<List<Breed>> searchBreeds(String query, List<Breed> currentList) async {
    if (query.trim().isEmpty) return currentList;
    final lowerQuery = query.toLowerCase().trim();
    return currentList
        .where((b) => b.breed.toLowerCase().contains(lowerQuery))
        .toList();
  }

  Breed _mapModelToEntity(BreedModel model) {
    return Breed(
      breed: model.breed,
      country: model.country,
      origin: model.origin,
      coat: model.coat,
      pattern: model.pattern,
    );
  }
}
