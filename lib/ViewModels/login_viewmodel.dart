import 'package:context_switcher/DatabaseModels/User.dart';
import 'package:context_switcher/Models/UserModel.dart';
import 'package:context_switcher/Screens/login_profile_screen.dart';
import 'package:context_switcher/Singletons/current_user.dart';
import 'package:flutter/material.dart';
import 'package:context_switcher/constants.dart';

class LoginViewModel extends ChangeNotifier {
  String username = "aykut";
  List<ProfileSelectionCard> profileCards = [];
  UserModel model = UserModel();

  void increment() {
    username += "1";
    notifyListeners();
  }

  void getProfileCards() async {
    var users = await model.getAllUsers();
    profileCards.clear();
    for (var user in users) {
      profileCards.add(ProfileSelectionCard(
        user: user,
      ));
    }
    notifyListeners();
  }

  bool loginUser(User user, String password) {
    if (password == user.password) {
      CurrentUser.instance.userId = user.userId;
      CurrentUser.instance.userName = user.userName;
      CurrentUser.instance.userProfilePicture = user.userProfilePicture;
      CurrentUser.instance.authorization = user.authorization;
      var authCodeList =
          user.authorization.split(Constants.breakBetweenAuthCodes);

      //convert authorization string to int list to be used more easily
      CurrentUser.instance.authCodeList =
          List.generate(authCodeList.length, (index) {
        return int.parse(authCodeList[index]);
      });
      return true;
    }
    return false;
  }
}
