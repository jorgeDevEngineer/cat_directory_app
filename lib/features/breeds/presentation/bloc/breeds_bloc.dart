import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../domain/repositories/breeds_repository.dart';
import 'breeds_event.dart';
import 'breeds_state.dart';

EventTransformer<E> droppable<E>() {
  return (events, mapper) => events.asyncExpand((event) async* {
        yield* mapper(event);
      });
}

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class BreedsBloc extends Bloc<BreedsEvent, BreedsState> {
  final BreedsRepository repository;

  BreedsBloc({required this.repository}) : super(const BreedsState()) {
    on<BreedsLoadStarted>(_onLoadStarted, transformer: droppable());
    on<BreedsNextPageRequested>(_onNextPageRequested, transformer: droppable());
    on<BreedsRefreshRequested>(_onRefreshRequested);
    on<BreedsSearchQueryChanged>(_onSearchQueryChanged, transformer: debounce(const Duration(milliseconds: 300)));
  }

  Future<void> _onLoadStarted(
    BreedsLoadStarted event,
    Emitter<BreedsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final result = await repository.getBreeds(page: 1, forceRefresh: event.forceRefresh);
      final filtered = await repository.searchBreeds(state.searchQuery, result.breeds);

      emit(state.copyWith(
        isLoading: false,
        breeds: result.breeds,
        filteredBreeds: filtered,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        hasReachedEnd: result.currentPage >= result.lastPage,
        isFromCache: result.isFromCache,
        lastUpdated: result.lastUpdated,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onNextPageRequested(
    BreedsNextPageRequested event,
    Emitter<BreedsState> emit,
  ) async {
    if (state.hasReachedEnd || state.isLoadingMore || state.isLoading) return;

    emit(state.copyWith(isLoadingMore: true, errorMessage: null));

    try {
      final nextPage = state.currentPage + 1;
      final result = await repository.getBreeds(page: nextPage);
      final updatedList = List.of(state.breeds)..addAll(result.breeds);
      final filtered = await repository.searchBreeds(state.searchQuery, updatedList);

      emit(state.copyWith(
        isLoadingMore: false,
        breeds: updatedList,
        filteredBreeds: filtered,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        hasReachedEnd: result.currentPage >= result.lastPage,
        isFromCache: result.isFromCache,
        lastUpdated: result.lastUpdated ?? state.lastUpdated,
      ));
    } catch (e) {
      // Preserves existing loaded list 1..N-1 on pagination failure
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Failed to load page ${state.currentPage + 1}: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRefreshRequested(
    BreedsRefreshRequested event,
    Emitter<BreedsState> emit,
  ) async {
    add(const BreedsLoadStarted(forceRefresh: true));
  }

  Future<void> _onSearchQueryChanged(
    BreedsSearchQueryChanged event,
    Emitter<BreedsState> emit,
  ) async {
    final query = event.query;
    final filtered = await repository.searchBreeds(query, state.breeds);
    emit(state.copyWith(
      searchQuery: query,
      filteredBreeds: filtered,
    ));
  }
}
