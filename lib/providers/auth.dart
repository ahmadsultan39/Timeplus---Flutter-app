import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String userId;
  String userName;
  String number;
  String _token;
  bool admin;

  Future<bool> isAuth() async {
    if (token == null) {
      return await tryAutoLogin();
    } else {
      return await validToken();
    }
  }

  String get token {
    return _token;
  }

  Future<bool> validToken() async {
    final ParseResponse parseResponse =
        await ParseUser.getCurrentUserFromServer(token);

    if (!parseResponse.success) {
      //Invalid session. Logout
      await logout();
      return false;
    } else {
      return true;
    }
  }

  Future<void> signIn(String username, String password) async {
    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (response.success) {
      userId = response.results.first['objectId'];
      userName = response.results.first['username'];
      number = response.results.first['number'];
      _token = response.results.first['sessionToken'];
      admin = response.results.first['admin'];
      saveToken();
      notifyListeners();
    } else {
      throw HttpException('LogIn failed');
    }
  }

  void signUp(
      String username, String usernumber, String email, String password) {
    final user = ParseUser(username, password, email)
      ..set('admin', false)
      ..set('number', usernumber);
    user.signUp().then((value) {
      if (value.statusCode == 202) {
        throw HttpException('username taken');
      } else if (value.statusCode == 203) {
        throw HttpException('email taken');
      }
      userId = value.results.first['objectId'];
      userName = username;
      number = usernumber;
      _token = value.results.first['sessionToken'];
      admin = value.results.first['admin'];
      saveToken();
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  void saveToken() async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(
        'userData',
        json.encode({
          'token': token,
          'userId': userId,
          'username': userName,
          'number': number,
          'admin': admin.toString(),
        }));
  }

  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) return false;

    final extractedData =
        json.decode(pref.getString('userData')) as Map<String, Object>;
    _token = extractedData['token'];
    userId = extractedData['userId'];
    userName = extractedData['username'];
    number = extractedData['number'];

    if (extractedData['admin'] == 'true')
      admin = true;
    else
      admin = false;
    //Checks whether the user's session token is valid
    return await validToken();
  }

  Future<void> logout() async {
    _token = null;
    userId = null;
    userName = null;
    number = null;
    admin = null;
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
    // ParseUser currentUser = await ParseUser.currentUser() as ParseUser;
    // await currentUser.logout();
  }
}
