import 'dart:io';

import 'package:demo/core/service/network/custom_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_paths.dart';
import 'custom_response.dart';

final class ApiServiceOption {
  final ContentType? contentType;
  final ResponseType? responseType;

  const ApiServiceOption({this.contentType, this.responseType});

  @override
  String toString() {
    return 'content type is $contentType and response type is $responseType';
  }
}

class ApiService {
  late Dio _dio;

  ApiService(ApiServiceOption? option) {
    _dio = Dio(BaseOptions(
        baseUrl: ApiPaths.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: option?.contentType?.toString() ?? 'application/json',
        responseType: option?.responseType ?? ResponseType.json));
    _dio.interceptors.add(CustomInterceptor(this));
    _dio.interceptors.add(PrettyDioLogger(
      error: true,
      requestHeader: true,
      requestBody: true,
    ));
  }

  Future<AppResponse> get(String path, {Map<String, dynamic>? query}) async {
    return _dio
        .get(path, queryParameters: query)
        .then((value) => value.data as AppResponse)
        .onError<DioException>(
          (error, stackTrace) => error.response!.data as ErrorResponse,
        );
  }

  Future<AppResponse> post(String path,
      {Map<String, dynamic>? query, Object? body}) async {
    print(body);
    return _dio
        .post(path, data: body, queryParameters: query)
        .then((value) {
          print(value);
          return value.data as AppResponse;
        })
        .onError<DioException>(
            (error, stackTrace) {
              return error.response!.data as ErrorResponse;
            });
  }

  Future<AppResponse> put(String path, {Object? body}) async {
    return _dio
        .put(path, data: body)
        .then((value) => value.data as AppResponse)
        .onError<DioException>((error, stackTrace) => error.response!.data as ErrorResponse);
  }
}
