import 'dart:convert';

import 'package:demo/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Gender {
  male('Male'),
  female('Female'),
  unknown('');

  final String title;

  const Gender(this.title);

  factory Gender.map(String? name) {
    return switch (name) {
      'M' => Gender.male,
      'F' => Gender.female,
      _ => Gender.unknown
    };
  }

  @override
  String toString() => switch (this) {
        Gender.male => 'M',
        Gender.female => 'F',
        Gender.unknown => ''
      };
}

enum GiftType {
  amazon('Amazon'),
  timHortons('Tim Hortons'),
  starbucks('Starbucks Card');

  final String title;

  const GiftType(this.title);

  factory GiftType.map(String? name) {
    return switch (name) {
      'Amazon' => GiftType.amazon,
      'Tim Hortons' => GiftType.timHortons,
      _ => GiftType.starbucks
    };
  }

  @override
  String toString() => switch (this) {
    GiftType.amazon => 'Amazon',
    GiftType.timHortons => 'Tim Hortons',
    GiftType.starbucks => 'Starbucks Card'
  };
}
enum TypeOfFeedback {
  bugs('Bugs'),
  generalInquiry('General Inquiry'),
  unknown('');

  final String title;

  const TypeOfFeedback(this.title);

  factory TypeOfFeedback.map(String name) {
    return switch (name) {
      'Bugs' => TypeOfFeedback.bugs,
      'General Inquiry' => TypeOfFeedback.generalInquiry,
      _ => TypeOfFeedback.unknown
    };
  }

  @override
  String toString() => switch (this) {
        TypeOfFeedback.bugs => 'Bugs',
        TypeOfFeedback.generalInquiry => 'General Inquiry',
        TypeOfFeedback.unknown => ''
      };
}

class User {
  final int id;
  final String email;
  final String fullName;
  final String username;
  String get obscuredEmail => '${email.split('@').firstOrNull ?? ''}@*****';

  const User.empty({
    this.id = -1,
    this.email = '',
    this.fullName = '',
    this.username = '',
  });

//<editor-fold desc="Data Methods">
  const User(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.username});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          fullName == other.fullName &&
          username == other.username);

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      fullName.hashCode ^
      username.hashCode;

  @override
  String toString() {
    return 'User{ id: $id, email: $email, fullName: $fullName, username: $username}';
  }

  User copyWith({
    int? id,
    String? email,
    String? fullName,
    String? username,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'username': username,
    };
  }

  factory User.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const User.empty();
    return User(
      id: map['id'] as int,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      username: map['username'] as String,
    );
  }

  static Future<User> fromLocal() async {
    final pref = await SharedPreferences.getInstance();
    final json = pref.getString(PrefsConstants.user);
    if (json == null) return const User.empty();
    return User.fromMap(jsonDecode(json));
  }
//</editor-fold>
}
