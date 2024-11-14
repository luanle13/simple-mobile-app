import 'package:demo/data/datasource/api/auth_api_datasource.dart';
import 'package:demo/data/datasource/api/enitity/sign_in_response.dart';
import 'package:demo/data/datasource/local/auth_local_datasource.dart';
import 'package:demo/domain/model/user.dart';
import 'package:demo/domain/repository_interface/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements IAuthRepository {
  const AuthRepository(
      {required this.cacheDatasource, required this.remoteDatasource});

  final AuthApiDatasource remoteDatasource;
  final AuthLocalDatasource cacheDatasource;

  @override
  Future<SignInResponse> signIn(
          {required String email, required String password}) =>
      remoteDatasource.signInWithEmailPassword(
          email: email, password: password);
  @override
  Future<bool> changePassword({required String email, required String currentPassword, required String newPassword}) async {
    return await remoteDatasource.changePassword(email: email, currentPassword: currentPassword, newPassword: newPassword);
  }
  @override
  Future<bool> saveUser({required String email, required String fullName, required String password}) async {
    return false;//await cacheDatasource.saveUser(user);
  }

  @override
  Future<User> getUser() async {
    // final cache = await cacheDatasource.getUser();
    // if (cache != null) return cache;
    return (await remoteDatasource.getUser());
  }

  @override
  Future<bool> updateUser({required String email, required String fullName, required String password}) async {
    return await Future.wait([
      remoteDatasource.saveUser(email: email, fullName: fullName, password: password),
      // cacheDatasource.saveUser(user),
    ]).then(
      (value) => value.every((element) => element),
    );
  }

  @override
  Future<bool> saveToken(String token) {
    return cacheDatasource.saveToken(token);
  }

  @override
  Future<bool> checkPin(String email, String input) async {
    final pref = await SharedPreferences.getInstance();
    final pin =  pref.getString(email);
    return pin == input;
  }

  @override
  Future<bool> forgotPassword({String email = '', String fullName = '', String password = '', String userName = ''}) async {
      return await remoteDatasource.forgotPassword(email: email, fullName: fullName, password: password, userName: userName);
  }

  // @override
  // Future<bool> checkToken(String token) => remoteDatasource.checkToken(token);
  //
  // @override
  // Future<String> refreshToken(String token) {
  //  return remoteDatasource.refreshToken(token);
  // }

  @override
  Future<bool> saveRefreshToken(String token) => cacheDatasource.saveRefreshToken(token);
}
