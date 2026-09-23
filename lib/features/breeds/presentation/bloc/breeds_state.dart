import 'package:equatable/equatable.dart';
import '../../domain/entities/breed.dart';

class BreedsState extends Equatable {
  final List<Breed> breeds;
  final List<Breed> filteredBreeds;
  final int currentPage;
  final int lastPage;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final String searchQuery;
  final String? errorMessage;
  final bool isFromCache;
  final DateTime? lastUpdated;

  const BreedsState({
    this.breeds = const [],
    this.filteredBreeds = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.searchQuery = '',
    this.errorMessage,
    this.isFromCache = false,
    this.lastUpdated,
  });

  BreedsState copyWith({
    List<Breed>? breeds,
    List<Breed>? filteredBreeds,
    int? currentPage,
    int? lastPage,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    String? searchQuery,
    String? errorMessage,
    bool? isFromCache,
    DateTime? lastUpdated,
  }) {
    return BreedsState(
      breeds: breeds ?? this.breeds,
      filteredBreeds: filteredBreeds ?? this.filteredBreeds,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
      isFromCache: isFromCache ?? this.isFromCache,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        breeds,
        filteredBreeds,
        currentPage,
        lastPage,
        isLoading,
        isLoadingMore,
        hasReachedEnd,
        searchQuery,
        errorMessage,
        isFromCache,
        lastUpdated,
      ];
}
