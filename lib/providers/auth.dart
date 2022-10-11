import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Auth with ChangeNotifier {
  String _token;
  String _email;
  String _denomination;
  DateTime _expiryDate;
  String _userId;
  String _selectedCustomerId;
  String _authMode = "login";
  Timer _authTimer;
  Status _status;
  DateTime _createdAt;
  bool _useFingerprint = false;
  String _password;

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

  String get selectedCustomerId {
    return _selectedCustomerId;
  }

  bool get isAuth {
    return _token != null;
  }

  String get authMode {
    return _authMode;
  }

  String get email {
    return _email;
  }

  String get denomination {
    return _denomination;
  }

  DateTime get createdAt => _createdAt == null ? DateTime.now() : _createdAt;

  Status get status => _status;

  bool get useFingerprint => _useFingerprint;

  String get password => _password;

  void setLogin() {
    _authMode = "login";
    notifyListeners();
  }

  void setCustomerId(String selectedCustomerId) {
    _selectedCustomerId = selectedCustomerId;
    notifyListeners();
  }

  void setPassword(String password) async {
    _password = password;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('password', password);
    } catch (error) {
      print(error);
    }
  }

  void setUseFingerprint(bool value) async {
    _useFingerprint = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('useFingerprint', value);
    } catch (error) {
      print(error);
    }
  }

  Future<bool> _authenticate(
      String email, String password, String segment, Function method) async {
    final url = '${Constants.appLink}auth/$segment';
    try {
      final response = await method(url, body: {
        "email": email,
        "user_password": password,
      }).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error']) {
        throw Exception(responseData['message']);
      }
      _token = responseData['accessToken'];
      _expiryDate = DateTime.now().add(Duration(seconds: responseData['expT']));
      if (_status == Status.USER)
        _denomination = responseData['denomination'];
      else
        _denomination = responseData['username'];
      if (_status == Status.USER)
        _userId = responseData['agent_id'].toString();
      else
        _userId = responseData['admin_id'].toString();
      _createdAt = DateTime.parse(responseData['creation_time']);
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "email": _email,
        "denomination": _denomination,
        "expiryDate": _expiryDate.toIso8601String(),
        "status": _status.toString(),
        "createdAt": DateFormat('yyyy-MM-dd').format(_createdAt)
      });
      prefs.setString('userData', userData);
      return true;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> fLogin(String password) async {
    return _authenticate(_email, password, 'firstlogin', http.post);
  }

  Future<bool> uLogin(String password) async {
    return _authenticate(_email, password, 'login', http.post);
  }

  Future<bool> fLoginAdmin(String password) async {
    return _authenticate(_email, password, 'firstloginadmin', http.post);
  }

  Future<bool> uLoginAdmin(String password) async {
    return _authenticate(_email, password, 'loginadmin', http.post);
  }

  Future<void> login(String email) async {
    final url = '${Constants.appLink}userverification';
    try {
      final response = await http.post(url, body: {
        "email": email,
      }).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      print(response.body);
      final responseData = json.decode(response.body);
      if (responseData['error']) {
        throw Exception(responseData['message']);
      }
      _email = email;
      _authMode = responseData['message'];
      if (responseData['message'] == 'fLogin' ||
          responseData['message'] == 'uLogin') _status = Status.USER;
      if (responseData['message'] == 'fLoginAdminAdmin' ||
          responseData['message'] == 'uLoginAdminAdmin') _status = Status.ADMIN;
      if (responseData['message'] == 'fLoginSuperAdmin' ||
          responseData['message'] == 'uLoginSuperAdmin')
        _status = Status.SUPERADMIN;

      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('password') &&
          prefs.containsKey('useFingerprint')) {
        _password = prefs.getString('password');
        _useFingerprint = prefs.getBool('useFingerprint');
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void changeAccount() {
    _email = null;
    _authMode = null;
    _status = null;
    notifyListeners();
  }

  Future<bool> resetPassword() async {
    final url = '${Constants.appLink}sendresetpasswordemail';
    try {
      final response = await http.post(url, headers: {
        "x-access-token": token,
      }, body: {
        "email": _email,
      }).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error']) {
        return false;
      }
      return true;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractUserData['token'];
    _userId = extractUserData['userId'];
    _email = extractUserData['email'];
    _denomination = extractUserData['denomination'];
    _status = getStatusFromString(extractUserData['status']);
    _createdAt = DateTime.parse(extractUserData['createdAt']);

    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _email = null;
    _status = null;
    _denomination = null;
    _expiryDate = null;
    _createdAt = null;
    _authMode = "login";
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer.cancel();

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Status getStatusFromString(String statusAsString) {
    for (Status element in Status.values) {
      if (element.toString() == statusAsString) {
        return element;
      }
    }
    return null;
  }
}
