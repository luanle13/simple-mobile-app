import 'dart:async';

import 'package:demo/core/constants/app_constants.dart';
import 'package:demo/core/service/app_log.dart';
import 'package:demo/core/service/network/api_paths.dart';
import 'package:demo/core/service/network/custom_response.dart';
import 'package:demo/core/service/network/network_service.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomInterceptor implements InterceptorsWrapper {
  final ApiService apiService;

  const CustomInterceptor(this.apiService);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final errCode = err.response?.statusCode ?? 0;
    AppLog.print(err);
    //If 401 then refresh token
    if (errCode == 400) {
      return handler.reject(err.copyWith(response: Response<ErrorResponse>(
          requestOptions: err.requestOptions,
          data: ErrorResponse.fromCode(400, message: err.response?.data['message']))));
    }
    // if (errCode == 401) {
    //   final refreshed = await _refreshToken();
    //   //If refresh success then continue request
    //   if (refreshed) {
    //     return handler.resolve(err.response!);
    //   }
    //   //else move back to login
    //   else {
    //     //TODO: back to login
    //     return handler.reject(err.copyWith(response: Response<ErrorResponse>(
    //         requestOptions: err.requestOptions,
    //         data: ErrorResponse.fromCode(401))));
    //   }
    // }
    return handler.reject(err.copyWith(
        response: Response<ErrorResponse>(
            requestOptions: err.requestOptions,
            data: ErrorResponse.fromCode(errCode))));
  }

  // FutureOr<bool> _refreshToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString(PrefsConstants.refresh_token) ?? '';
  //   final res = await apiService
  //       .post(ApiPaths.refreshToken, body: {'refreshToken': token});
  //   return res.map((response) async {
  //     await prefs.setString(
  //         PrefsConstants.access_token, response.data['access_token']);
  //     await prefs.setString(
  //         PrefsConstants.refresh_token, response.data['refresh_token']);
  //     return true;
  //   }, (response) {
  //     return false;
  //   });
  // }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.containsKey(PrefsConstants.access_token)
        ? pref.getString(PrefsConstants.access_token)!
        : '';
    AppLog.print(token);
    final newOptions = options.copyWith(headers: {
      ...options.headers,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token'
    });

    return handler.next(newOptions);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is Map == false) {
      return handler.reject(DioException.badResponse(
          statusCode: 0,
          requestOptions: response.requestOptions,
          response: Response<Map<String, dynamic>>(
              requestOptions: response.requestOptions,
              data: {
                'status': 0,
                'message': 'The server response is not readable(not json).'
              })));
    }

    if ((response.statusCode ?? 0) >= 400) {
      final {'statusCode': status as int, 'message': message} =
          response.data as Map;
      return handler.reject(DioException.badResponse(
          statusCode: 0,
          requestOptions: response.requestOptions,
          response: Response<Map<String, dynamic>>(
              requestOptions: response.requestOptions,
              data: {'status': status, 'message': message})));
    }

    return handler.next(Response<AppResponse>(
        requestOptions: response.requestOptions,
        data: AppResponse.map(response.statusCode ?? 0, json: response.data)));
  }
}
