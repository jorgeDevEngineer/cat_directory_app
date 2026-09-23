import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fact_repository.dart';
import 'breed_detail_state.dart';

class BreedDetailCubit extends Cubit<BreedDetailState> {
  final FactRepository factRepository;

  BreedDetailCubit({required this.factRepository}) : super(const BreedDetailInitial());

  Future<void> loadRandomFact({int? maxLength}) async {
    emit(const BreedDetailFactLoading());

    try {
      final fact = await factRepository.getRandomFact(maxLength: maxLength);
      emit(BreedDetailFactLoaded(fact));
    } catch (e) {
      emit(BreedDetailFactError(e.toString()));
    }
  }
}
