import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_exceptions.dart';

class ApiClient {
  final Dio dio;
  static const String baseUrl = 'https://catfact.ninja';

  ApiClient({Dio? customDio})
      : dio = customDio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 15),
                headers: {'Accept': 'application/json'},
              ),
            ) {
    if (customDio == null) {
      dio.interceptors.add(_createRetryInterceptor());
      if (kDebugMode) {
        dio.interceptors.add(
          LogInterceptor(
            requestHeader: false,
            responseHeader: false,
            requestBody: false,
            responseBody: false,
          ),
        );
      }
    }
  }

  Interceptor _createRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException err, ErrorInterceptorHandler handler) async {
        if (_shouldRetry(err)) {
          int retryCount = err.requestOptions.extra['retry_count'] ?? 0;
          const maxRetries = 3;

          if (retryCount < maxRetries) {
            retryCount++;
            err.requestOptions.extra['retry_count'] = retryCount;

            final delaySeconds = 1 << (retryCount - 1); // Exponential backoff: 1s, 2s, 4s
            await Future.delayed(Duration(seconds: delaySeconds));

            try {
              final response = await dio.fetch(err.requestOptions);
              return handler.resolve(response);
            } on DioException catch (retryErr) {
              return handler.next(retryErr);
            }
          }
        }
        return handler.next(err);
      },
    );
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response != null && err.response!.statusCode! >= 500);
  }

  ApiException mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null && statusCode >= 500) {
          return ServerException('Server error: $statusCode', statusCode);
        }
        return UnknownApiException('Bad response: $statusCode', statusCode);
      default:
        if (error.error is SocketException) {
          return const NetworkException();
        }
        return UnknownApiException(error.message ?? 'Unknown network error');
    }
  }
}
