import 'package:demo/core/di/dependency_injections.dart';
import 'package:demo/core/service/app_log.dart';
import 'package:demo/data/repository/auth_repository.dart';
import 'package:demo/domain/repository_interface/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class ForgotPasswordState {
  final bool submitting;
  final bool? success;
  final String? error;

//<editor-fold desc="Data Methods">
  const ForgotPasswordState({
    this.submitting = false,
    this.success = false,
    this.error,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ForgotPasswordState &&
          runtimeType == other.runtimeType &&
          submitting == other.submitting &&
          success == other.success &&
          error == other.error);

  @override
  int get hashCode => submitting.hashCode ^ success.hashCode ^ error.hashCode;

  @override
  String toString() {
    return 'ForgotPasswordState{ submitting: $submitting, error: $error,}';
  }

  ForgotPasswordState copyWith({
    bool? submitting,
    bool? success,
    String? error,
  }) {
    return ForgotPasswordState(
      success: success,
      submitting: submitting ?? this.submitting,
      error: error,
    );
  }

//</editor-fold>
}

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordNotifier(this._authRepository)
      : super(const ForgotPasswordState());

  final IAuthRepository _authRepository;

  Future<void> forgotPassword({String email = '', String fullName = '', String password = '', String userName = ''}) async {
    state = state.copyWith(submitting: true);

    await _authRepository.forgotPassword(email: email, password: password, fullName: fullName, userName: userName).then((value) async {
      if (value) {
        state = state.copyWith(success: value, submitting: false);
      } else {
        state = state.copyWith(
            submitting: false, error: 'Could not change password');
      }
    }).onError((error, stackTrace) {
      print('hehehehehehhehehehe');
      AppLog.error(error);
      AppLog.error(stackTrace);
      state = state.copyWith(error: error.toString(), submitting: false);
    });
  }
}

var forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
  (ref) => ForgotPasswordNotifier(
    locator<AuthRepository>(),
  ),
);
