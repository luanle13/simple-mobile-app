import 'dart:io';

import 'package:demo/core/service/app_log.dart';
import 'package:demo/core/service/network/api_paths.dart';
import 'package:demo/core/service/network/custom_response.dart';
import 'package:demo/core/service/network/network_service.dart';
import 'package:demo/data/datasource/api/enitity/sign_in_response.dart';
import 'package:demo/domain/model/user.dart';

import '../base/auth_datasource.dart';

class AuthApiDatasource implements IAuthDataSource {
  const AuthApiDatasource(this._apiService);

  final ApiService _apiService;

  @override
  Future<SignInResponse> signInWithEmailPassword(
      {required String email, required String password}) async {

    final res = await _apiService.post(ApiPaths.signin, body: {
      'username': email,
      'password': password,
    });

    return res.map((response) {
      print(response.toString());
      print(response);
      return SignInResponse.fromMap(response.data);
    },
        (response) => Future.error(response.message));
  }

  @override
  Future<bool> changePassword(
      {required String email,
      required String currentPassword,
      required String newPassword}) async {
    final res = await _apiService.post(ApiPaths.changePassword, body: {
      "email": email,
      "currentPass": currentPassword,
      "newPass": newPassword
    });

    return res.map(
        (response) => true, (response) => Future.error(response.message));
  }

  @override
  Future<bool> forgotPassword({String email = '', String fullName = '', String password = '', String userName =''}) async {
    print('ajsdflkasdjfkasldfa');
    final res = await _apiService.post(ApiPaths.resetPassword, body: {
      "email": email,
      "fullName": fullName,
      "password": password,
      "userName": userName,
    });
    print('-23=-3-=23-=23323-=-=23');
    print(res);
    AppLog.print('aaaaaaaaa');
    return res.map(
        (response) => true, (response) => Future.error(response.message));
  }

  @override
  Future<User> getUser() async {
    final res = await _apiService.get(ApiPaths.profile);
    print(res);
    return res.map((response) {
      print('02303293209329023');
      print(response.data);
      print(response);
      return User.fromMap(response.data);
    },
        (response) => Future.error(response.message));
  }

  @override
  Future<bool> saveUser({required String email, required String fullName, required String password}) async {
    final res = await _apiService.put(ApiPaths.profile, body: {
      "email": email,
      "fullName": fullName,
      "password": password
    });

    return res.map(
        (response) => true, (response) => Future.error(response.message));
  }

  // @override
  // Future<bool> checkToken(String token) async {
  //   final res =
  //       await _apiService.post(ApiPaths.checkToken, body: {'token': token});
  //   return res.map((response) => true, (response) => false);
  // }

  // Future<String> refreshToken(String token) async {
  //   final res = await _apiService
  //       .post(ApiPaths.refreshToken, body: {'refreshToken': token});
  //
  //   return res.map<String>((response) {
  //     return response.data['access_token'];
  //   }, (response) {
  //     return '';
  //   });
  // }

}
