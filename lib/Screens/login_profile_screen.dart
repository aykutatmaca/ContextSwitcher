import 'package:context_switcher/DatabaseModels/User.dart';
import 'package:context_switcher/Screens/login_auth_screen.dart';
import 'package:context_switcher/ViewModels/context_viewmodel.dart';
import 'package:context_switcher/ViewModels/login_viewmodel.dart';
import 'package:context_switcher/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:context_switcher/constants.dart';

class LoginProfileScreen extends StatefulWidget {
  const LoginProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginProfileScreen();
  }
}

class _LoginProfileScreen extends State<LoginProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<LoginViewModel>(context, listen: false).getProfileCards();

    return Material(
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 5,
            ),
            Image.asset(
              "lib/assets/cs_logo.png",
              height: 75,
            ),
            const Text(
              "Who's switching it?",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Roboto",
                fontSize: 36,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Consumer<LoginViewModel>(
                        builder: (context, loginViewModel, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [...loginViewModel.profileCards],
                  );
                })
                    ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ));
  }
}

class ProfileSelectionCard extends StatelessWidget {
  ProfileSelectionCard({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    Provider.of<ContextViewModel>(context, listen: false).unregisterHotkeys();

    final ImageProvider image = AssetImage("lib/assets/profile_pictures/" +
        Constants.profilePictures[user.userProfilePicture]);
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginAuthScreen(
                    user: user,
                    image: image,
                  )),
        )
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "avatar-user-" + user.userId.toString(),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: image,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              user.userName,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
