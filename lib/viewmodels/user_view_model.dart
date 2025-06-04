import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/database_helper.dart';

class UserViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  User? currentUser;

  Future<bool> register(String username, String password, String name) async {
    try {
      await _dbHelper.insertUser(User(username: username, password: password, name: name));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> login(String username, String password) async {
    final user = await _dbHelper.getUser(username, password);
    if (user != null && user.password == password) {
      currentUser = user;
      notifyListeners();
      return user;
    }
    return null;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}