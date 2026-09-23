import '../datasources/fact_remote_datasource.dart';
import '../models/cat_fact_model.dart';
import '../../domain/repositories/fact_repository.dart';

class FactRepositoryImpl implements FactRepository {
  final FactRemoteDataSource remoteDataSource;

  FactRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CatFactModel> getRandomFact({int? maxLength}) {
    return remoteDataSource.getRandomFact(maxLength: maxLength);
  }
}
