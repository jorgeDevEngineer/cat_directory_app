enum CachePolicy {
  cacheFirst,
  networkFirst,
  staleWhileRevalidate,
}

class CachedData<T> {
  final T data;
  final DateTime cachedAt;
  final Duration ttl;

  CachedData({
    required this.data,
    required this.cachedAt,
    this.ttl = const Duration(minutes: 30),
  });

  bool get isExpired => DateTime.now().difference(cachedAt) > (ttl * 4); // Expired after 2 hours (30m * 4)

  bool get isStale {
    final age = DateTime.now().difference(cachedAt);
    return age > ttl && age <= (ttl * 4); // Stale between 30m and 2h
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => {
        'data': toJsonT(data),
        'cachedAt': cachedAt.toIso8601String(),
        'ttlMinutes': ttl.inMinutes,
      };

  factory CachedData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return CachedData<T>(
      data: fromJsonT(json['data']),
      cachedAt: DateTime.parse(json['cachedAt'] as String),
      ttl: Duration(minutes: json['ttlMinutes'] as int? ?? 30),
    );
  }
}
