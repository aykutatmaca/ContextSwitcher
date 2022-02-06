import 'package:flutter/material.dart';
import 'package:context_switcher/ViewModels/profile_viewmodel.dart';
import 'package:context_switcher/DatabaseModels/User.dart';
import 'package:provider/provider.dart';
import 'package:context_switcher/constants.dart';
import 'package:context_switcher/Singletons/current_user.dart';

import 'edit_profile_dialog.dart';

class ProfileWidget extends StatefulWidget {
  ProfileWidget({Key? key, required this.user}) : super(key: key);
  User user;

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  double padding = 5;

  @override
  Widget build(BuildContext context) {
    final currentUser = CurrentUser.instance;
    final isAdmin =
        currentUser.authorization.contains(Constants.isAdmin.toString());
    final isCurrent = widget.user.userId == currentUser.userId;
    return Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(color: Theme.of(context).colorScheme.primary)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              minRadius: 50,
              maxRadius: 80,
              backgroundImage: AssetImage("lib/assets/profile_pictures/" +
                  Constants.profilePictures[widget.user.userProfilePicture]),
            ),
            Expanded(
                flex: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.user.userName,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                isAdmin || isCurrent
                                    ? IconButton(
                                        icon: const Icon(Icons.settings),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext context) {
                                                return EditProfilePopup(
                                                  user: User(
                                                      userId:
                                                          widget.user.userId,
                                                      userName: widget
                                                          .user.userName,
                                                      userProfilePicture: widget
                                                          .user
                                                          .userProfilePicture,
                                                      authorization: widget
                                                          .user.authorization,
                                                      password: widget
                                                          .user.password),
                                                );
                                              });
                                        })
                                    : Text(''),
                              ],
                            )))
                  ],
                )),
          ],
        ));
  }
}
