import 'package:context_switcher/CustomWidgets/profile_widget.dart';
import 'package:context_switcher/Singletons/current_user.dart';
import 'package:context_switcher/ViewModels/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../DatabaseModels/User.dart';
import '../constants.dart';
import 'package:context_switcher/CustomWidgets/new_profile_dialog.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({Key? key}) : super(key: key);

  @override
  State<ProfilesScreen> createState() => _ProfilesScreen();
}

class _ProfilesScreen extends State<ProfilesScreen>
    with AutomaticKeepAliveClientMixin<ProfilesScreen> {
  @override
  bool get wantKeepAlive => true;

  List<ProfileWidget> profiles = [];

  void createProfile(BuildContext context) {
    Provider.of<ProfileViewModel>(context, listen: false).getCurrentUsers();
  }

  void createProfileWidgets(List<User> users) {
    profiles.clear();
    for (var user in users) {
      profiles.add(ProfileWidget(user: user, key: UniqueKey()));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Provider.of<ProfileViewModel>(context, listen: false).getCurrentUsers();
    return Scaffold(
      floatingActionButton: !(CurrentUser.instance.authorization.contains(Constants.isAdmin.toString())) ? null : FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return NewProfilePopup(
                  user: User(
                    userId: -1,
                    userName: "",
                    userProfilePicture: -1,
                    authorization: "",
                    password: ""
                  ),
                );
              });
        },
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          createProfileWidgets(viewModel.users);
          return Container(
              color: Theme.of(context).colorScheme.secondary,
              child: GridView.extent(
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  maxCrossAxisExtent: 220,
                  childAspectRatio: 0.833,
                  children: [...profiles]));
        },
      ),
    );
  }
}
