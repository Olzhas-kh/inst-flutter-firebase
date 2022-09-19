import 'package:flutter/material.dart';
import 'package:inst_fire/models/user.dart';
import 'package:inst_fire/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    //notifyListeners();
  }
}
