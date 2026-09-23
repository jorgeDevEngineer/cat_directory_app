import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/breed_model.dart';
import '../models/paginated_response.dart';

abstract class BreedsRemoteDataSource {
  Future<PaginatedResponse<BreedModel>> getBreeds({
    required int page,
    int limit = 25,
    CancelToken? cancelToken,
  });
}

class BreedsRemoteDataSourceImpl implements BreedsRemoteDataSource {
  final ApiClient apiClient;
  CancelToken? _currentCancelToken;

  BreedsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedResponse<BreedModel>> getBreeds({
    required int page,
    int limit = 25,
    CancelToken? cancelToken,
  }) async {
    // Concurrency control: cancel ongoing request if a new one arrives with internal token
    if (cancelToken == null) {
      _currentCancelToken?.cancel('Cancelled due to new request');
      _currentCancelToken = CancelToken();
    }

    final activeToken = cancelToken ?? _currentCancelToken;

    try {
      final response = await apiClient.dio.get(
        '/breeds',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
        cancelToken: activeToken,
      );

      return PaginatedResponse<BreedModel>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => BreedModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw const UnknownApiException('Request cancelled');
      }
      throw apiClient.mapDioException(e);
    } catch (e) {
      throw UnknownApiException(e.toString());
    }
  }
}
