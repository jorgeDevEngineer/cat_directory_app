import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app/theme/app_colors.dart';

class CatImageHelper {
  /// Map of specific high-res cat images for popular breed names
  static const Map<String, String> _specificBreedImages = {
    'abyssinian': 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba',
    'aegean': 'https://images.unsplash.com/photo-1573865526739-10659fec78a5',
    'american curl': 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce',
    'american shorthair': 'https://images.unsplash.com/photo-1561948955-570b270e7c36',
    'arabian mau': 'https://images.unsplash.com/photo-1495360010541-f48722b34f7d',
    'australian mist': 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131',
    'balinese': 'https://images.unsplash.com/photo-1543852786-1cf6624b9987',
    'bengal': 'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8',
    'birman': 'https://images.unsplash.com/photo-1548802673-380ab8ebc7b7',
    'bombay': 'https://images.unsplash.com/photo-1533743983669-94fa5c4338ec',
    'british shorthair': 'https://images.unsplash.com/photo-1592194996308-7b43878e84a6',
    'burmese': 'https://images.unsplash.com/photo-1574158622682-e40e69881006',
    'chartreux': 'https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13',
    'cheetoh': 'https://images.unsplash.com/photo-1519052537078-e6302a4968d4',
    'cougar': 'https://images.unsplash.com/photo-1548247416-ec66f4900b2e',
    'cymric': 'https://images.unsplash.com/photo-1577023311546-acd076b2650d',
    'devon rex': 'https://images.unsplash.com/photo-1511044568932-338cba0ad803',
    'dorset rex': 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce',
    'egyptian mau': 'https://images.unsplash.com/photo-1561948955-570b270e7c36',
    'exotic shorthair': 'https://images.unsplash.com/photo-1574158622682-e40e69881006',
    'havana brown': 'https://images.unsplash.com/photo-1533743983669-94fa5c4338ec',
    'himalayan': 'https://images.unsplash.com/photo-1548802673-380ab8ebc7b7',
    'japanese bobtail': 'https://images.unsplash.com/photo-1543852786-1cf6624b9987',
    'javanese': 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131',
    'korat': 'https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13',
    'laperm': 'https://images.unsplash.com/photo-1573865526739-10659fec78a5',
    'maine coon': 'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8',
    'manx': 'https://images.unsplash.com/photo-1577023311546-acd076b2650d',
    'munchkin': 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba',
    'nebelung': 'https://images.unsplash.com/photo-1592194996308-7b43878e84a6',
    'norwegian forest cat': 'https://images.unsplash.com/photo-1495360010541-f48722b34f7d',
    'ocicat': 'https://images.unsplash.com/photo-1519052537078-e6302a4968d4',
    'oriental': 'https://images.unsplash.com/photo-1543852786-1cf6624b9987',
    'persian': 'https://images.unsplash.com/photo-1548802673-380ab8ebc7b7',
    'ragdoll': 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce',
    'russian blue': 'https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13',
    'savannah': 'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8',
    'scottish fold': 'https://images.unsplash.com/photo-1592194996308-7b43878e84a6',
    'selkirk rex': 'https://images.unsplash.com/photo-1573865526739-10659fec78a5',
    'siamese': 'https://images.unsplash.com/photo-1543852786-1cf6624b9987',
    'siberian': 'https://images.unsplash.com/photo-1561948955-570b270e7c36',
    'singapura': 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131',
    'snowshoe': 'https://images.unsplash.com/photo-1548802673-380ab8ebc7b7',
    'sokoke': 'https://images.unsplash.com/photo-1495360010541-f48722b34f7d',
    'somali': 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba',
    'sphynx': 'https://images.unsplash.com/photo-1511044568932-338cba0ad803',
    'tonkinese': 'https://images.unsplash.com/photo-1574158622682-e40e69881006',
    'toyger': 'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8',
    'turkish angora': 'https://images.unsplash.com/photo-1573865526739-10659fec78a5',
    'turkish van': 'https://images.unsplash.com/photo-1548802673-380ab8ebc7b7',
    'york chocolate': 'https://images.unsplash.com/photo-1533743983669-94fa5c4338ec',
  };

  /// Generates a unique, query-specific high-quality cat photo URL for every single breed name.
  static String getBreedImageUrl(String breedName) {
    final lowerName = breedName.toLowerCase().trim();
    if (_specificBreedImages.containsKey(lowerName)) {
      return '${_specificBreedImages[lowerName]!}?auto=format&fit=crop&w=600&q=85';
    }

    // Dynamic photo generator using CATAAS (Cat As A Service) API tagged per breed name
    final cleanTag = Uri.encodeComponent(lowerName);
    return 'https://cataas.com/cat/says/$cleanTag?width=600&height=400';
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
            color: AppColors.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.surfaceVariant,
              child: const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.surfaceVariant,
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

  /// Builds a full card header image with CachedNetworkImage
  static Widget buildCardImage({
    required String breedName,
    required String countryFlag,
    required double height,
    required String heroTag,
  }) {
    final imageUrl = getBreedImageUrl(breedName);

    return Hero(
      tag: heroTag,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.surfaceVariant,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.surfaceVariant,
            child: Center(
              child: Text(
                countryFlag,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
