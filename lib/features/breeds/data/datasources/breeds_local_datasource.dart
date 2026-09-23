import 'dart:convert';
import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/cache_policy.dart';
import '../models/breed_model.dart';

abstract class BreedsLocalDataSource {
  Future<void> cacheBreeds(int page, List<BreedModel> breeds);
  Future<CachedData<List<BreedModel>>?> getCachedBreeds(int page);
  Future<DateTime?> getLastCachedTimestamp();
  Future<void> clearCache();
}

class BreedsLocalDataSourceImpl implements BreedsLocalDataSource {
  final CacheManager cacheManager;
  static const String pagePrefix = 'breeds_page_';
  static const String timestampKey = 'breeds_last_updated';

  BreedsLocalDataSourceImpl({required this.cacheManager});

  @override
  Future<void> cacheBreeds(int page, List<BreedModel> breeds) async {
    final cachedData = CachedData<List<BreedModel>>(
      data: breeds,
      cachedAt: DateTime.now(),
      ttl: const Duration(minutes: 30),
    );

    final jsonMap = cachedData.toJson(
      (list) => (list as List<BreedModel>).map((e) => e.toJson()).toList(),
    );

    await cacheManager.saveRaw('$pagePrefix$page', jsonEncode(jsonMap));
    await cacheManager.saveRaw(timestampKey, DateTime.now().toIso8601String());
  }

  @override
  Future<CachedData<List<BreedModel>>?> getCachedBreeds(int page) async {
    final raw = await cacheManager.getRaw('$pagePrefix$page');
    if (raw == null) return null;

    try {
      final jsonMap = jsonDecode(raw) as Map<String, dynamic>;
      return CachedData<List<BreedModel>>.fromJson(
        jsonMap,
        (json) => (json as List)
            .map((e) => BreedModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<DateTime?> getLastCachedTimestamp() async {
    final raw = await cacheManager.getRaw(timestampKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  @override
  Future<void> clearCache() async {
    await cacheManager.clearAll();
  }
}
