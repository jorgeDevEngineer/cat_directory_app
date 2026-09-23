import '../../data/models/cat_fact_model.dart';

abstract class FactRepository {
  Future<CatFactModel> getRandomFact({int? maxLength});
}
