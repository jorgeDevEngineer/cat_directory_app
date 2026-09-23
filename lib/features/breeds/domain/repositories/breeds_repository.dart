import '../entities/breed.dart';
import '../../data/models/paginated_response.dart';

class BreedsResult {
  final List<Breed> breeds;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool isFromCache;
  final DateTime? lastUpdated;

  const BreedsResult({
    required this.breeds,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.isFromCache = false,
    this.lastUpdated,
  });
}

abstract class BreedsRepository {
  Future<BreedsResult> getBreeds({required int page, bool forceRefresh = false});
  Future<List<Breed>> searchBreeds(String query, List<Breed> currentList);
}
