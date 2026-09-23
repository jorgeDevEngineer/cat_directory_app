import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cat_directory_app/features/breed_detail/data/models/cat_fact_model.dart';
import 'package:cat_directory_app/features/breed_detail/domain/repositories/fact_repository.dart';
import 'package:cat_directory_app/features/breed_detail/presentation/cubit/breed_detail_cubit.dart';
import 'package:cat_directory_app/features/breed_detail/presentation/cubit/breed_detail_state.dart';

class MockFactRepository extends Mock implements FactRepository {}

void main() {
  late MockFactRepository mockFactRepository;

  setUp(() {
    mockFactRepository = MockFactRepository();
  });

  const testFact = CatFactModel(
    fact: 'Cats sleep 70% of their lives.',
    length: 30,
  );

  group('BreedDetailCubit Unit Tests (Phase 14 - F.I.R.S.T.)', () {
    blocTest<BreedDetailCubit, BreedDetailState>(
      'emits [BreedDetailFactLoading, BreedDetailFactLoaded] when fact loading succeeds',
      build: () {
        when(() => mockFactRepository.getRandomFact()).thenAnswer((_) async => testFact);
        return BreedDetailCubit(factRepository: mockFactRepository);
      },
      act: (cubit) => cubit.loadRandomFact(),
      expect: () => [
        const BreedDetailFactLoading(),
        const BreedDetailFactLoaded(testFact),
      ],
    );

    blocTest<BreedDetailCubit, BreedDetailState>(
      'emits [BreedDetailFactLoading, BreedDetailFactError] when fact loading fails',
      build: () {
        when(() => mockFactRepository.getRandomFact()).thenThrow(Exception('Server error'));
        return BreedDetailCubit(factRepository: mockFactRepository);
      },
      act: (cubit) => cubit.loadRandomFact(),
      expect: () => [
        const BreedDetailFactLoading(),
        isA<BreedDetailFactError>(),
      ],
    );
  });
}
