import 'package:demo/core/di/dependency_injections.dart';
import 'package:demo/data/repository/auth_repository.dart';
import 'package:demo/domain/model/user.dart';
import 'package:demo/domain/repository_interface/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAccountState {
  final User user;
  final User temp;
  final bool loading;
  final String? err;
  final bool? success;
  final bool submitting;

  bool get isUpdating => user != temp;

//<editor-fold desc="Data Methods">
  const MyAccountState({
    this.user = const User.empty(),
    this.temp = const User.empty(),
    this.loading = true,
    this.submitting = false,
    this.err,
    this.success,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MyAccountState &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          temp == other.temp &&
          loading == other.loading &&
          success == other.success &&
          submitting == other.submitting &&
          err == other.err);

  @override
  int get hashCode =>
      user.hashCode ^
      temp.hashCode ^
      loading.hashCode ^
      submitting.hashCode ^
      err.hashCode;

  @override
  String toString() {
    return 'MyAccountState{ user: $user, loading: $loading, err: $err,}';
  }

  MyAccountState copyWith({
    User? user,
    User? temp,
    bool? loading,
    String? err,
    bool? submitting,
    bool? success,
  }) {
    return MyAccountState(
        temp: temp ?? this.temp,
        user: user ?? this.user,
        loading: loading ?? this.loading,
        err: err,
        success: success,
        submitting: submitting ?? this.submitting);
  }

//</editor-fold>
}

class MyAccountNotifier extends StateNotifier<MyAccountState> {
  MyAccountNotifier(this._authRepository) : super(const MyAccountState());
  final IAuthRepository _authRepository;

  void init() async {
    final user = await _authRepository.getUser();
    state = state.copyWith(
      loading: false,
      user: user,
      temp: user,
    );
  }

  Future<void> updateEmail(String value) async {
    state = state.copyWith(user: state.user.copyWith(email: value));
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    state = state.copyWith(submitting: true);
    await _authRepository.changePassword(email: state.user.email, currentPassword: currentPassword, newPassword: newPassword).then((saved) {
      state = state.copyWith(
        success: saved,
      );
    }).onError((error, stackTrace) {
      state = state.copyWith(
        err: error.toString(),
      );
    }).whenComplete(() {
      state = state.copyWith(submitting: false);
    });
  }

  Future<void> updatePin(String value) async {
    state = state.copyWith(user: state.user.copyWith());
  }

  Future<void> updateGroup(String value) async {
    state = state.copyWith(user: state.user.copyWith());
  }

  void resetUser() {
    state = state.copyWith(user: state.temp);
  }

  Future<void> submit({required String email, required String fullName, String? password}) async {
    state = state.copyWith(submitting: true);
    await _authRepository.updateUser(
        email: email,
        fullName: fullName,
        password: password ?? ''
    ).then((saved) {
      if (!saved) {
        state = state.copyWith(err: 'Could not save data. Please try again');
        resetUser();
        return;
      }
      state = state.copyWith(
        success: true,
        temp: state.user,
      );
    }).onError((error, stackTrace) {
      state = state.copyWith(
        err: error.toString(),
        user: state.temp,
      );
    }).whenComplete(() {
      state = state.copyWith(submitting: false);
    });
  }
}

var myAccountProvider =
    StateNotifierProvider.autoDispose<MyAccountNotifier, MyAccountState>((ref) {
  final notifier = MyAccountNotifier(locator<AuthRepository>());
  notifier.init();

  return notifier;
});
