import 'package:flutter/material.dart';
import 'package:context_switcher/DatabaseModels/User.dart';
import 'package:context_switcher/Models/UserModel.dart';

class ProfileViewModel extends ChangeNotifier {
  UserModel model = UserModel();

  List<User> users = [];

  void createUser(User user) async {
    await model.createUser(user);
    getCurrentUsers();
  }

  void getCurrentUsers() async {
    users = await model.getAllUsers();
    notifyListeners();
  }

  void updateUser(User user) async {
    await model.updateUser(user);
    getCurrentUsers();
  }

  void deleteUser(User user) async {
    await model.deleteUser(user);
    getCurrentUsers();
  }
}