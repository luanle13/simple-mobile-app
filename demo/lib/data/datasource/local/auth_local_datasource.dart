import 'dart:convert';

import 'package:demo/core/constants/app_constants.dart';
import 'package:demo/core/service/local_service.dart';
import 'package:demo/data/datasource/api/enitity/sign_in_response.dart';
import 'package:demo/data/datasource/base/auth_datasource.dart';
import 'package:demo/domain/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource implements IAuthDataSource {
  final LocalService localService;

  const AuthLocalDatasource(this.localService);
  @override
  Future<SignInResponse> signInWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement signInWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<bool> saveUser({required String email, required String fullName, required String password}) async {
    final pref = await SharedPreferences.getInstance();

    return false;//pref.setString(PrefsConstants.user, jsonEncode(user.toMap()));
  }

  @override
  Future<User?> getUser() async {
    // final pref = await SharedPreferences.getInstance();
    // final undecoded = pref.getString(PrefsConstants.user);
    // if (undecoded == null) return const User.empty();
    // final json = jsonDecode(undecoded);
    return localService.user;
    // return User.fromMap(json);
  }

  Future<bool> saveToken(String token) async {
    // final pref = await SharedPreferences.getInstance();
    // return pref.setString(PrefsConstants.access_token, token);
    return localService.setToken(token: token);
  }
  Future<bool> saveRefreshToken(String token) async {
    // final pref = await SharedPreferences.getInstance();
    // return pref.setString(PrefsConstants.refresh_token, token);
    return localService.setToken(refreshToken: token);
  }

  @override
  Future<bool> checkToken(String token) {
    return Future.value(true);
  }
}
