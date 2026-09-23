import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/cat_fact_model.dart';

abstract class FactRemoteDataSource {
  Future<CatFactModel> getRandomFact({int? maxLength});
}

class FactRemoteDataSourceImpl implements FactRemoteDataSource {
  final ApiClient apiClient;

  FactRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CatFactModel> getRandomFact({int? maxLength}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (maxLength != null) {
        queryParams['max_length'] = maxLength;
      }

      final response = await apiClient.dio.get(
        '/fact',
        queryParameters: queryParams,
      );

      return CatFactModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw apiClient.mapDioException(e);
    } catch (e) {
      throw UnknownApiException(e.toString());
    }
  }
}
