import 'package:demo/core/di/dependency_injections.dart';
import 'package:demo/core/service/app_log.dart';
import 'package:demo/data/repository/auth_repository.dart';
import 'package:demo/domain/repository_interface/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SignInState {
  final bool submitting;
  final bool? success;
  final String? error;
  final bool willGotoPinScreen;

//<editor-fold desc="Data Methods">
  const SignInState({
    this.submitting = false,
    this.success = false,
    this.error,
    this.willGotoPinScreen = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SignInState &&
          runtimeType == other.runtimeType &&
          submitting == other.submitting &&
          success == other.success &&
          willGotoPinScreen == other.willGotoPinScreen &&
          error == other.error);

  @override
  int get hashCode => submitting.hashCode ^ success.hashCode ^ error.hashCode;

  @override
  String toString() {
    return 'SignInState{ submitting: $submitting, error: $error,}';
  }

  SignInState copyWith({
    bool? submitting,
    bool? success,
    String? error,
    bool? willGoToPin,
  }) {
    return SignInState(
      willGotoPinScreen: willGoToPin ?? willGotoPinScreen,
      success: success,
      submitting: submitting ?? this.submitting,
      error: error,
    );
  }

//</editor-fold>
}

class SignInNotifier extends StateNotifier<SignInState> {
  SignInNotifier(this._authRepository) : super(const SignInState());

  final IAuthRepository _authRepository;

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(submitting: true);

    await _authRepository
        .signIn(email: email, password: password)
        .then((value) async {
      //Save user data and token
      final saved = (await Future.wait([
        // _authRepository.saveUser(value.userData),
        _authRepository.saveToken(value.accessToken),
        // _authRepository.saveRefreshToken(value.refreshToken)
      ]))
          .every((element) => element);

      if (saved) {
        state = state.copyWith(success: saved, submitting: false);
      } else {
        state = state.copyWith(submitting: false, error: 'Could not save user');
      }
    }).onError((error, stackTrace) {
      AppLog.error(error);
      AppLog.error(stackTrace);
      state = state.copyWith(error: error.toString(), submitting: false);
    });
  }
}

var signInProvider = StateNotifierProvider<SignInNotifier, SignInState>(
  (ref) => SignInNotifier(
    locator<AuthRepository>(),
  ),
);
