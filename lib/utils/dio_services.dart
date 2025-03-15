import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio() {
    _dio.options = BaseOptions(
      validateStatus: (status) => true,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    );

    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  T _handleResponse<T>(Response response, T Function(dynamic)? fromJson) {
    if (response.statusCode == 200) {
      return fromJson != null ? fromJson(response.data) : response.data as T;
    } else {
      throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: response.data["error"]["message"]);
    }
  }

  AppException _handleError(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final message = error.message;
    return AppException(
      message: message ?? 'Unknown error',
      statusCode: statusCode,
    );
  }
}

class AppException implements Exception {
  final String message;
  final int statusCode;

  AppException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => '[$statusCode] $message';
}
