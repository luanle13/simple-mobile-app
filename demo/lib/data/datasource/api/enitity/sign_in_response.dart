import '../../../../domain/model/user.dart';

class SignInResponse {
  final String accessToken;
  // final String refreshToken;
  // final User userData;

//<editor-fold desc="Data Methods">
  const SignInResponse({
    required this.accessToken,
    // required this.refreshToken,
    // required this.userData,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SignInResponse &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken
          //&& refreshToken == other.refreshToken &&
          // userData == other.userData
          );

  // @override
  // int get hashCode =>
  //     accessToken.hashCode ^ refreshToken.hashCode ^ userData.hashCode;

  @override
  String toString() {
    return 'SignInResponse{ accessToken: $accessToken';//, refreshToken: $refreshToken, userData: $userData,}';
  }

  SignInResponse copyWith({
    String? accessToken,
    String? refreshToken,
    User? userData,
  }) {
    return SignInResponse(
      accessToken: accessToken ?? this.accessToken,
      // refreshToken: refreshToken ?? this.refreshToken,
      // userData: userData ?? this.userData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      // 'refreshToken': refreshToken,
      // 'userData': userData,
    };
  }

  factory SignInResponse.fromMap(Map<String, dynamic> map) {
    return SignInResponse(
      accessToken: map['token'] as String,
      // refreshToken: map['refreshToken'] as String,
      // userData: User.fromMap(map['userData']),
    );
  }

//</editor-fold>
}
