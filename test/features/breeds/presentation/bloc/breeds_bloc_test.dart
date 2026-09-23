import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/repositories/breeds_repository.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_event.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_state.dart';

class MockBreedsRepository extends Mock implements BreedsRepository {}

void main() {
  late MockBreedsRepository mockRepository;

  setUp(() {
    mockRepository = MockBreedsRepository();
  });

  const testBreeds = [
    Breed(breed: 'Abyssinian', country: 'Ethiopia', origin: 'Natural', coat: 'Short', pattern: 'Ticked'),
    Breed(breed: 'Aegean', country: 'Greece', origin: 'Natural', coat: 'Semi-long', pattern: 'Bi-color'),
  ];

  group('BreedsBloc Unit Tests (Phases 3 to 6 - F.I.R.S.T.)', () {
    blocTest<BreedsBloc, BreedsState>(
      'emits [isLoading: true, loaded data] when BreedsLoadStarted is added',
      build: () {
        when(() => mockRepository.getBreeds(page: 1, forceRefresh: false)).thenAnswer(
          (_) async => const BreedsResult(
            breeds: testBreeds,
            currentPage: 1,
            lastPage: 20,
            total: 98,
            isFromCache: false,
          ),
        );
        when(() => mockRepository.searchBreeds('', testBreeds)).thenAnswer((_) async => testBreeds);
        return BreedsBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(const BreedsLoadStarted()),
      expect: () => [
        const BreedsState(isLoading: true),
        const BreedsState(
          isLoading: false,
          breeds: testBreeds,
          filteredBreeds: testBreeds,
          currentPage: 1,
          lastPage: 20,
          hasReachedEnd: false,
          isFromCache: false,
        ),
      ],
    );

    blocTest<BreedsBloc, BreedsState>(
      'filters breeds list locally when BreedsSearchQueryChanged is added',
      build: () {
        when(() => mockRepository.searchBreeds('aby', testBreeds)).thenAnswer(
          (_) async => [testBreeds.first],
        );
        return BreedsBloc(repository: mockRepository);
      },
      seed: () => const BreedsState(breeds: testBreeds, filteredBreeds: testBreeds),
      act: (bloc) => bloc.add(const BreedsSearchQueryChanged('aby')),
      wait: const Duration(milliseconds: 350), // Account for 300ms debounce
      expect: () => [
        BreedsState(
          breeds: testBreeds,
          filteredBreeds: [testBreeds.first],
          searchQuery: 'aby',
        ),
      ],
    );
  });
}
