import 'dart:convert';

import 'package:demo/core/constants/app_constants.dart';
import 'package:demo/domain/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  late SharedPreferences _pref;
  late User  user;
  late String accessToken;
  late String refreshToken;
  late bool onboard;
  late bool localAuth;

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
    for (final key in _pref.getKeys()) {
      print(key);
      print(_pref.get(key));
    }
    _markUpdate();
  }

  void _markUpdate() async {
    user = await User.fromLocal();
    accessToken = (_pref.getString(PrefsConstants.access_token)) ?? '';
    refreshToken = (_pref.getString(PrefsConstants.refresh_token)) ?? '';
    onboard = (_pref.getBool(PrefsConstants.onboard)) ?? true;
    localAuth = (_pref.getBool(PrefsConstants.local_auth)) ?? false;
  }

  Future<bool> setUser(User user) async {
    final updated =
        await _pref.setString(PrefsConstants.user, jsonEncode(user.toMap()));
    if (updated) _markUpdate();
    return updated;
  }

  Future<bool> setToken({String? token, String? refreshToken}) async {
    final updated = await Future.wait([
      if(token !=null)
      _pref.setString(PrefsConstants.access_token, token),
      if(refreshToken !=null)
      _pref.setString(PrefsConstants.refresh_token, refreshToken),
    ]);
    if (updated.every((element) => element)) _markUpdate();
    return updated.every((element) => element);
  }

  Future<bool> setOnboard(bool onboard) async {
    final updated = await _pref.setBool(PrefsConstants.onboard, onboard);

    if (updated) _markUpdate();
    return updated;
  }

  void setLocalAuth(bool localAuth) async {
    _pref.setBool(PrefsConstants.local_auth, localAuth);
    this.localAuth = localAuth;
  }

  Future<bool> getLocalAuth() async {
    if (_pref.containsKey(PrefsConstants.local_auth)){
      final value = _pref.getBool(PrefsConstants.local_auth);
      return value!;
    } else {
      return false;
    }
  }

  bool hasPin(String email) {
    final hasPin = _pref.containsKey(email);
    return hasPin && _pref.getString(email)?.isNotEmpty == true;
  }

  Future<bool> confirmPins(email, String confirmPins) async {
    if (!hasPin(email)) return false;

    final json = _pref.getString(email);
    if (json == null) return false;
    return (json == confirmPins);
  }

  Future<bool> savePins(String email, String pins) {
    return _pref.setString(email, pins);
  }

  Future<bool> removePin(String email) {
    return _pref.setString(email,'');
  }
}
