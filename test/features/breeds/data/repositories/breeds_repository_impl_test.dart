import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cat_directory_app/core/network/api_exceptions.dart';
import 'package:cat_directory_app/core/network/connectivity_service.dart';
import 'package:cat_directory_app/core/cache/cache_policy.dart';
import 'package:cat_directory_app/features/breeds/data/datasources/breeds_local_datasource.dart';
import 'package:cat_directory_app/features/breeds/data/datasources/breeds_remote_datasource.dart';
import 'package:cat_directory_app/features/breeds/data/models/breed_model.dart';
import 'package:cat_directory_app/features/breeds/data/models/paginated_response.dart';
import 'package:cat_directory_app/features/breeds/data/repositories/breeds_repository_impl.dart';

class MockBreedsRemoteDataSource extends Mock implements BreedsRemoteDataSource {}
class MockBreedsLocalDataSource extends Mock implements BreedsLocalDataSource {}
class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late BreedsRepositoryImpl repository;
  late MockBreedsRemoteDataSource mockRemote;
  late MockBreedsLocalDataSource mockLocal;
  late MockConnectivityService mockConnectivity;

  setUp(() {
    mockRemote = MockBreedsRemoteDataSource();
    mockLocal = MockBreedsLocalDataSource();
    mockConnectivity = MockConnectivityService();

    repository = BreedsRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      connectivityService: mockConnectivity,
    );
  });

  const testModels = [
    BreedModel(breed: 'Abyssinian', country: 'Ethiopia', origin: 'Natural', coat: 'Short', pattern: 'Ticked'),
  ];

  group('BreedsRepositoryImpl Unit Tests (Phase 14 - F.I.R.S.T.)', () {
    test('returns cached data when offline and cache exists', () async {
      when(() => mockConnectivity.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.getCachedBreeds(1)).thenAnswer(
        (_) async => CachedData<List<BreedModel>>(
          data: testModels,
          cachedAt: DateTime.now(),
        ),
      );
      when(() => mockLocal.getLastCachedTimestamp()).thenAnswer((_) async => DateTime.now());

      final result = await repository.getBreeds(page: 1);

      expect(result.breeds.length, equals(1));
      expect(result.breeds.first.breed, equals('Abyssinian'));
      expect(result.isFromCache, isTrue);
    });

    test('throws NetworkException when offline and no cache exists', () async {
      when(() => mockConnectivity.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.getCachedBreeds(1)).thenAnswer((_) async => null);
      when(() => mockLocal.getLastCachedTimestamp()).thenAnswer((_) async => null);

      expect(
        () async => await repository.getBreeds(page: 1),
        throwsA(isA<NetworkException>()),
      );
    });

    test('fetches from remote and updates cache when online and cache empty', () async {
      when(() => mockConnectivity.hasConnection()).thenAnswer((_) async => true);
      when(() => mockLocal.getCachedBreeds(1)).thenAnswer((_) async => null);
      when(() => mockLocal.getLastCachedTimestamp()).thenAnswer((_) async => null);
      when(() => mockRemote.getBreeds(page: 1)).thenAnswer(
        (_) async => const PaginatedResponse<BreedModel>(
          currentPage: 1,
          data: testModels,
          lastPage: 20,
          total: 98,
        ),
      );
      when(() => mockLocal.cacheBreeds(1, testModels)).thenAnswer((_) async {});

      final result = await repository.getBreeds(page: 1);

      expect(result.breeds.length, equals(1));
      expect(result.isFromCache, isFalse);
      verify(() => mockLocal.cacheBreeds(1, testModels)).called(1);
    });
  });
}
