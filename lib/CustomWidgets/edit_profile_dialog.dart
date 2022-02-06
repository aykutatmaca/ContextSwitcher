import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../DatabaseModels/User.dart';
import '../Screens/login_profile_screen.dart';
import '../Singletons/current_user.dart';
import '../ViewModels/profile_viewmodel.dart';
import '../constants.dart';

class ModifiedUser extends ChangeNotifier {
  ModifiedUser({required this.user});

  User user;

  void setName(String name) {
    user.userName = name;
    notifyListeners();
  }

  void setPw(String pw) {
    user.password = pw;
    notifyListeners();
  }

  void setPicture(int pp) {
    user.userProfilePicture = pp;
    notifyListeners();
  }

  void setAuth(bool word, bool npp, bool excel, bool firefox, bool winExp) {
    var authString = "";

    if (user.authorization.contains(Constants.isAdmin.toString())) {
      authString += "99.";
    }
    if (word) {
      authString += "1.";
    }
    if (excel) {
      authString += "2.";
    }
    if (npp) {
      authString += "3.";
    }
    if (firefox) {
      authString += "4.";
    }
    if (winExp) {
      authString += "5";
    }

    if (authString.endsWith('.')) {
      authString = authString.substring(0, authString.length - 1);
    }

    user.authorization = authString;
    notifyListeners();
  }
}

class NameTextbox extends StatefulWidget {
  NameTextbox({Key? key}) : super(key: key);

  @override
  _NameTextboxState createState() => _NameTextboxState();
}

class _NameTextboxState extends State<NameTextbox> {
  final nameController = TextEditingController();

  @override
  void initState() {
    nameController.text =
        Provider.of<ModifiedUser>(context, listen: false).user.userName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              flex: 16,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Profile Name: '),
              ),
            ),
            Expanded(
              flex: 90,
              child: TextField(
                controller: nameController,
                onChanged: (str) {
                  if (nameController.text.isNotEmpty) {
                    Provider.of<ModifiedUser>(context, listen: false)
                        .setName(nameController.text);
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

class PwTextbox extends StatefulWidget {
  const PwTextbox({Key? key}) : super(key: key);

  @override
  _PwTextboxState createState() => _PwTextboxState();
}

class _PwTextboxState extends State<PwTextbox> {
  final pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            const Expanded(
              flex: 16,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Password: '),
              ),
            ),
            Expanded(
              flex: 90,
              child: TextField(
                obscureText: true,
                controller: pwController,
                onChanged: (str) {
                  if (pwController.text.isNotEmpty) {
                    Provider.of<ModifiedUser>(context, listen: false)
                        .setPw(pwController.text);
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

class PicturePopup extends StatefulWidget {
  const PicturePopup({Key? key}) : super(key: key);

  @override
  _PicturePopupState createState() => _PicturePopupState();
}

class _PicturePopupState extends State<PicturePopup> {
  void profilePictureSelected(BuildContext buildContext, int index) {
    Provider.of<ModifiedUser>(buildContext, listen: false).setPicture(index);
    Navigator.pop(context);
  }

  void profilePicturePressed(BuildContext buildContext) {
    List<ElevatedButton> pictures =
        List.generate(Constants.profilePictures.length, (index) {
      return ElevatedButton(
          onPressed: () {
            profilePictureSelected(buildContext, index);
          },
          child: CircleAvatar(
            minRadius: 30,
            maxRadius: 50,
            backgroundImage: AssetImage("lib/assets/profile_pictures/" +
                Constants.profilePictures[index]),
          ));
    });

    showDialog(
        context: context,
        builder: (context) {
          return SizedBox(
            width: 200,
            height: 300,
            child: GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              //maxCrossAxisExtent: 100,
              childAspectRatio: 0.833,
              children: [...pictures],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var pp = Provider.of<ModifiedUser>(context, listen: false)
        .user
        .userProfilePicture;

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Profile Picture: '),
            ),
            Provider.of<ModifiedUser>(context, listen: false)
                        .user
                        .userProfilePicture !=
                    -1
                ? ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(shape: const CircleBorder()),
                    onPressed: () {
                      profilePicturePressed(context);
                      setState(() {});
                    },
                    child: CircleAvatar(
                      minRadius: 30,
                      maxRadius: 50,
                      backgroundImage: AssetImage(
                          "lib/assets/profile_pictures/" +
                              Constants.profilePictures[
                                  Provider.of<ModifiedUser>(context,
                                          listen: false)
                                      .user
                                      .userProfilePicture]),
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      profilePicturePressed(context);
                      setState(() {});
                    },
                    icon: const Icon(Icons.add)),
            const SizedBox(
              height: 15,
            ),
          ],
        )
      ],
    );
  }
}

class AuthSelect extends StatefulWidget {
  const AuthSelect({Key? key}) : super(key: key);

  @override
  _AuthSelectState createState() => _AuthSelectState();
}

class _AuthSelectState extends State<AuthSelect> {
  String authValues = "";

  List<String> authOptions = [];

  bool isAdmin = false;
  bool word = false;
  bool npp = false;
  bool excel = false;
  bool firefox = false;
  bool winExp = false;

  @override
  void initState() {
    authOptions = List.generate(Constants.supportedApps.length, (index) {
      return Constants.supportedApps[index];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = CurrentUser.instance;
    isAdmin = currentUser.authorization.contains(Constants.isAdmin.toString());
    word = Provider.of<ModifiedUser>(context, listen: false)
        .user
        .authorization
        .contains(Constants.canUseWord.toString());
    npp = Provider.of<ModifiedUser>(context, listen: false)
        .user
        .authorization
        .contains(Constants.canUseNpp.toString());
    excel = Provider.of<ModifiedUser>(context, listen: false)
        .user
        .authorization
        .contains(Constants.canUseExcel.toString());
    firefox = Provider.of<ModifiedUser>(context, listen: false)
        .user
        .authorization
        .contains(Constants.canUseFirefox.toString());
    winExp = Provider.of<ModifiedUser>(context, listen: false)
        .user
        .authorization
        .contains(Constants.canUseWinExp.toString());
    if (isAdmin) {
      return Column(
        children: [
          Row(
            children: const [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Authorization: '),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(authOptions[0]),
                    Checkbox(
                        value: word,
                        onChanged: (value) {
                          setState(() {
                            word = value!;
                          });
                          Provider.of<ModifiedUser>(context, listen: false)
                              .setAuth(word, npp, excel, firefox, winExp);
                        })
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(authOptions[1]),
                    Checkbox(
                        value: excel,
                        onChanged: (value) {
                          setState(() {
                            excel = value!;
                          });
                          Provider.of<ModifiedUser>(context, listen: false)
                              .setAuth(word, npp, excel, firefox, winExp);
                        })
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(authOptions[2]),
                    Checkbox(
                        value: npp,
                        onChanged: (value) {
                          setState(() {
                            npp = value!;
                          });
                          Provider.of<ModifiedUser>(context, listen: false)
                              .setAuth(word, npp, excel, firefox, winExp);
                        })
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(authOptions[3]),
                    Checkbox(
                        value: firefox,
                        onChanged: (value) {
                          setState(() {
                            firefox = value!;
                          });
                          Provider.of<ModifiedUser>(context, listen: false)
                              .setAuth(word, npp, excel, firefox, winExp);
                        })
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(authOptions[4]),
                    Checkbox(
                        value: winExp,
                        onChanged: (value) {
                          setState(() {
                            winExp = value!;
                          });
                          Provider.of<ModifiedUser>(context, listen: false)
                              .setAuth(word, npp, excel, firefox, winExp);
                        })
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class SaveButton extends StatefulWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    bool pwChanged =
        Provider.of<ModifiedUser>(context, listen: false).user.password.isEmpty;
    if (pwChanged) {}
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        child: ElevatedButton(
          onPressed: () {
            if (Provider.of<ModifiedUser>(context, listen: false)
                    .user
                    .authorization != "") {
              Provider.of<ProfileViewModel>(context, listen: false).updateUser(
                  Provider.of<ModifiedUser>(context, listen: false).user);
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    title: Text(
                      "Missing Information",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    content: Text("Please enter all the information",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    actions: [
                      TextButton(
                        child: Text("OK",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                },
              );
            }
          },
          child: const Text("Save"),
        ),
      ),
    );
  }
}

class EditProfilePopup extends StatefulWidget {
  late User user;
  late ModifiedUser modifiedUser;

  EditProfilePopup({Key? key, required this.user}) : super(key: key) {
    modifiedUser = ModifiedUser(user: user);
  }

  _EditProfilePopupState createState() => _EditProfilePopupState();
}

class _EditProfilePopupState extends State<EditProfilePopup> {
  var nameBox = NameTextbox();
  var pwBox = PwTextbox();
  var ppPopup = PicturePopup();
  var authSelect = AuthSelect();
  var saveButton = SaveButton();

  List<Widget> widgets = [];

  @override
  void initState() {
    widgets.add(ppPopup);
    widgets.add(nameBox);
    widgets.add(pwBox);
    widgets.add(authSelect);
    widgets.add(saveButton);
    super.initState();
  }

  void onPressedDeleteShowAlert() async {
    final currentUser = CurrentUser.instance;
    final currentIsDeleted = widget.user.userId == currentUser.userId;
    Widget okButton = TextButton(
      child: Text("Delete",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      onPressed: () {
        if (currentIsDeleted) {
          deleteUser();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginProfileScreen()),
          );
        } else {
          deleteUser();
          Navigator.pop(context);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text(
        "Delete Profile",
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      content: Text(
          "Are you sure you want to delete profile ${widget.user.userName}?",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void deleteUser() {
    Provider.of<ProfileViewModel>(context, listen: false)
        .deleteUser(widget.user);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = CurrentUser.instance;
    final isAdmin =
        currentUser.authorization.contains(Constants.isAdmin.toString());
    final isCurrent = widget.user.userId == currentUser.userId;
    return SimpleDialog(
      alignment: Alignment.center,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      children: <Widget>[
        SizedBox(
            width: 800,
            height: 600,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Edit Profile: ' + widget.user.userName),
                actions: <Widget>[
                  (isAdmin || isCurrent) && !(isAdmin && isCurrent)
                      ? IconButton(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            onPressedDeleteShowAlert();
                          },
                        )
                      : Text(''),
                ],
              ),
              extendBody: true,
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              body: ChangeNotifierProvider(
                create: (context) {
                  return widget.modifiedUser;
                },
                child: Column(
                  children: [...widgets],
                ),
              ),
            ))
      ],
    );
  }
}
