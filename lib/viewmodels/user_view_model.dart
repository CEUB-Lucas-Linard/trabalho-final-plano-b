import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/database_helper.dart';

class UserViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<bool> register(String username, String password) async {
    try {
      await _dbHelper.insertUser(User(username: username, password: password));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> login(String username, String password) async {
    return await _dbHelper.getUser(username, password);
  }
}