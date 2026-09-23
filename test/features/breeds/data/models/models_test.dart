import 'package:flutter_test/flutter_test.dart';
import 'package:cat_directory_app/features/breeds/data/models/breed_model.dart';
import 'package:cat_directory_app/features/breeds/data/models/paginated_response.dart';
import 'package:cat_directory_app/features/breed_detail/data/models/cat_fact_model.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';

void main() {
  group('Data Models Tests (Phase 1)', () {
    test('BreedModel deserialization from json', () {
      final json = {
        'breed': 'Abyssinian',
        'country': 'Ethiopia',
        'origin': 'Natural/Standard',
        'coat': 'Short',
        'pattern': 'Ticked'
      };

      final model = BreedModel.fromJson(json);

      expect(model.breed, equals('Abyssinian'));
      expect(model.country, equals('Ethiopia'));
      expect(model.origin, equals('Natural/Standard'));
      expect(model.coat, equals('Short'));
      expect(model.pattern, equals('Ticked'));
    });

    test('PaginatedResponse deserialization with BreedModel', () {
      final json = {
        'current_page': 1,
        'data': [
          {
            'breed': 'Abyssinian',
            'country': 'Ethiopia',
            'origin': 'Natural/Standard',
            'coat': 'Short',
            'pattern': 'Ticked'
          }
        ],
        'last_page': 20,
        'per_page': 5,
        'total': 98
      };

      final response = PaginatedResponse<BreedModel>.fromJson(
        json,
        (data) => BreedModel.fromJson(data as Map<String, dynamic>),
      );

      expect(response.currentPage, equals(1));
      expect(response.lastPage, equals(20));
      expect(response.total, equals(98));
      expect(response.data.length, equals(1));
      expect(response.data.first.breed, equals('Abyssinian'));
    });

    test('CatFactModel deserialization from json', () {
      final json = {
        'fact': 'Cats sleep 70% of their lives.',
        'length': 30
      };

      final model = CatFactModel.fromJson(json);

      expect(model.fact, equals('Cats sleep 70% of their lives.'));
      expect(model.length, equals(30));
    });

    test('Breed entity equality check', () {
      const breed1 = Breed(
        breed: 'Siamese',
        country: 'Thailand',
        origin: 'Natural',
        coat: 'Short',
        pattern: 'Colorpoint',
      );
      const breed2 = Breed(
        breed: 'Siamese',
        country: 'Thailand',
        origin: 'Natural',
        coat: 'Short',
        pattern: 'Colorpoint',
      );

      expect(breed1, equals(breed2));
    });
  });
}
