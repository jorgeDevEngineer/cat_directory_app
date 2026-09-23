import 'dart:convert';
import 'package:hive_ce/hive.dart';

class CacheManager {
  static const String defaultBoxName = 'app_cache';
  Box? _box;

  Future<Box> get box async {
    _box ??= await Hive.openBox(defaultBoxName);
    return _box!;
  }

  Future<void> saveRaw(String key, String jsonString) async {
    final b = await box;
    await b.put(key, jsonString);
  }

  Future<String?> getRaw(String key) async {
    final b = await box;
    return b.get(key) as String?;
  }

  Future<void> invalidate(String key) async {
    final b = await box;
    await b.delete(key);
  }

  Future<void> clearAll() async {
    final b = await box;
    await b.clear();
  }
}
