import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatImageHelper {
  /// Generates a deterministic high-quality cat photo URL for the given breed name.
  static String getBreedImageUrl(String breedName) {
    // Generate deterministic index (0 to 15) for high-res cat photos
    final hash = breedName.toLowerCase().codeUnits.fold(0, (prev, elem) => prev + elem);
    final photoIds = [
      '1514888286974-6c03e2ca1dba',
      '1573865526739-10659fec78a5',
      '1533738363-b7f9aef128ce',
      '1561948955-570b270e7c36',
      '1495360010541-f48722b34f7d',
      '1518791841217-8f162f1e1131',
      '1543852786-1cf6624b9987',
      '1513360371669-4adf3dd7dff8',
      '1548802673-380ab8ebc7b7',
      '1533743983669-94fa5c4338ec',
      '1592194996308-7b43878e84a6',
      '1574158622682-e40e69881006',
      '1526336024174-e58f5cdd8e13',
      '1519052537078-e6302a4968d4',
      '1548247416-ec66f4900b2e',
      '1577023311546-acd076b2650d',
    ];
    final selectedId = photoIds[hash % photoIds.length];
    return 'https://images.unsplash.com/photo-$selectedId?auto=format&fit=crop&w=400&q=80';
  }

  /// Builds a cached image avatar with fallback to flag emoji
  static Widget buildAvatar({
    required String breedName,
    required String countryFlag,
    required double size,
    required String heroTag,
  }) {
    final imageUrl = getBreedImageUrl(breedName);

    return Hero(
      tag: heroTag,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE65100),
            width: 1.5,
          ),
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: const Color(0xFFFFF3E0),
              child: const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE65100)),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: const Color(0xFFFFF3E0),
              child: Center(
                child: Text(
                  countryFlag,
                  style: TextStyle(fontSize: size * 0.45),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
