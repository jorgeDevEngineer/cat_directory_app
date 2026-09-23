import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cat_directory_app/core/network/api_client.dart';
import 'package:cat_directory_app/core/network/api_exceptions.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ApiClient apiClient;

  setUp(() {
    apiClient = ApiClient();
  });

  group('ApiClient Exception Mapping Tests (Phase 2)', () {
    test('maps connection error to NetworkException', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      final exception = apiClient.mapDioException(dioError);
      expect(exception, isA<NetworkException>());
    });

    test('maps connection timeout to TimeoutException', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final exception = apiClient.mapDioException(dioError);
      expect(exception, isA<TimeoutException>());
    });

    test('maps 500 bad response to ServerException', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
      );

      final exception = apiClient.mapDioException(dioError);
      expect(exception, isA<ServerException>());
      expect(exception.statusCode, equals(500));
    });

    test('maps 404 bad response to UnknownApiException', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
        ),
      );

      final exception = apiClient.mapDioException(dioError);
      expect(exception, isA<UnknownApiException>());
      expect(exception.statusCode, equals(404));
    });
  });
}
