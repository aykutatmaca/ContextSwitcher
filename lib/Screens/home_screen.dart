import 'package:context_switcher/Screens/contexts_screen.dart';
import 'package:context_switcher/Screens/login_profile_screen.dart';
import 'package:context_switcher/Screens/profiles_screen.dart';
import 'package:context_switcher/Screens/settings_page.dart';
import 'package:context_switcher/Singletons/current_user.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'package:context_switcher/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> with WindowListener {
  int _selectedIndex = 0;
  final PageController controller = PageController();

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CurrentUser currentUser = CurrentUser.instance;
    final ImageProvider currentUserPicture = AssetImage(
        "lib/assets/profile_pictures/" +
            Constants.profilePictures[currentUser.userProfilePicture]);

    return Scaffold(
      body: Row(
        children: <Widget>[
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: Column(children: [
              Expanded(
                  flex: 30,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Hero(
                      tag: "avatar-user-" + currentUser.userId.toString(),
                      child: CircleAvatar(
                        minRadius: 80,
                        maxRadius: 100,
                        backgroundImage: currentUserPicture,
                      ),
                    ),
                  )),
              Expanded(
                  flex: 15,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(CurrentUser.instance.userName,
                            style: TextStyle(
                                fontSize: 20,
                                color:
                                    Theme.of(context).colorScheme.onSecondary)),
                      ))),
              Expanded(
                flex: 65,
                child: NavigationRail(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  selectedLabelTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20),
                  unselectedLabelTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 18),
                  selectedIconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.onPrimary),
                  unselectedIconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.onSecondary),
                  selectedIndex: _selectedIndex,
                  extended: true,
                  minExtendedWidth: 200,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                      controller.jumpToPage(_selectedIndex);
                    });
                  },
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.restore_page),
                      selectedIcon: Icon(Icons.restore_page),
                      label: Text('Contexts'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profiles'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      selectedIcon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                ),
              )
            ]),
          ),
          // This is the main content.
          Expanded(
              flex: 80,
              child: PageView(
                controller: controller,
                children: const [
                  ContextsScreen(),
                  ProfilesScreen(),
                  SettingsScreen()
                ],
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginProfileScreen()),
          )
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
