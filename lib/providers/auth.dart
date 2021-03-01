import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authtimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authendicate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:/$urlSegment?key=AIzaSyAJ4NEaXMXctkcprkGsb8vq1IEua_zAPGA';
    try {
      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final resdata = json.decode(res.body);
      if (resdata['error'] != null) {
        throw HttpException(resdata['error']['message']);
      }
      _token = resdata['idToken'];
      _userId = resdata['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(resdata['expiresIn'])));
      autologgout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userdata = json.encode({
        'token': _token,
        'userId': _userId,
        'expirydate': _expiryDate.toIso8601String()
      });
      pref.setString('userdata', userdata);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authendicate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authendicate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authtimer != null) {
      _authtimer.cancel();
      _authtimer = null;
    }

    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void autologgout() {
    if (_authtimer != null) {
      _authtimer.cancel();
    }
    final timetoexpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authtimer = Timer(Duration(seconds: timetoexpiry), logout);
  }

  Future<bool> tryautolog() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }
    final extractedata =
        json.decode(pref.getString('userData')) as Map<String, Object>;
    final exdate = DateTime.parse(extractedata['expirydate']);
    if (exdate.isAfter(DateTime.now())) {
      return false;
    }
    _token = extractedata['token'];
    _userId = extractedata['userId'];
    _expiryDate = extractedata['expirydate'];
    notifyListeners();
    autologgout();
    return true;
  }
}
