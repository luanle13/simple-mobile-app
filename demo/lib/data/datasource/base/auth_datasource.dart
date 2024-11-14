import 'package:demo/data/datasource/api/enitity/sign_in_response.dart';

import '../../../domain/model/user.dart';

abstract interface class IAuthDataSource {
  Future<SignInResponse> signInWithEmailPassword(
      {required String email, required String password});

  Future<User?> getUser();

  Future<bool> saveUser({required String email, required String fullName, required String password}) ;
  // Future<bool> checkToken(String token);
}
