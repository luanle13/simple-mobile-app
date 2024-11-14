import 'package:demo/data/datasource/api/enitity/sign_in_response.dart';
import 'package:demo/domain/model/user.dart';

abstract interface class IAuthRepository {
  Future<SignInResponse> signIn(
      {required String email, required String password});
  Future<bool> saveUser({required String email, required String fullName, required String password});
  Future<bool> saveToken(String token);
  Future<bool> saveRefreshToken(String token);
  Future<bool> updateUser({required String email, required String fullName, required String password});
  Future<User> getUser();
  Future<bool> checkPin(String email, String pin);
  Future<bool> changePassword({required String email, required String currentPassword, required String newPassword});
  Future<bool> forgotPassword({String email, String password, String userName, String fullName});
  // Future<bool> checkToken(String token);
  // Future<String> refreshToken(String token);
}