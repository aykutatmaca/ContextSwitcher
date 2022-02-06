import 'package:context_switcher/CustomWidgets/context_tile.dart';
import 'package:context_switcher/CustomWidgets/context_tile_settings_dialog.dart';
import 'package:context_switcher/DatabaseModels/Context.dart';
import 'package:context_switcher/Singletons/db_helper.dart';
import 'package:context_switcher/ViewModels/context_viewmodel.dart';
import 'package:context_switcher/ViewModels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:context_switcher/constants.dart';
import 'package:provider/provider.dart';

import 'package:hotkey_manager/hotkey_manager.dart';

class ContextsScreen extends StatefulWidget {
  const ContextsScreen({Key? key}) : super(key: key);

  @override
  State<ContextsScreen> createState() => _ContextsScreen();
}

class _ContextsScreen extends State<ContextsScreen>
    with AutomaticKeepAliveClientMixin<ContextsScreen> {
  @override
  bool get wantKeepAlive => true;

  List<ContextTile> contexts = [];

  void createContext(BuildContext context) {
    if (contexts.length < Constants.maxProfileCount) {
      //contexts.add(ContextTile(key: UniqueKey()));
    }
    Provider.of<ContextViewModel>(context, listen: false)
        .getContextsOfCurrentUser();
  }

  void createContextTilesFromContexts(List<Context> contexts) {
    this.contexts.clear();
    for (var context in contexts) {
      this.contexts.add(ContextTile(context: context, key: UniqueKey()));
    }
  }

  void showMaximumContextLimitReachedDialog() {
    Widget okButton = TextButton(
      child: Text("OK",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text(
        "Warning",
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      content: Text(
          "You can't create more than ${Constants.maxContextPerProfileCount} contexts.",
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

  double padding = 10;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Provider.of<ContextViewModel>(context, listen: false)
        .getContextsOfCurrentUser();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () async {
            //createContext(context);
            if (contexts.length < Constants.maxContextPerProfileCount) {
              await showDialog(
                  barrierDismissible: false,
                  useRootNavigator: false,
                  context: context,
                  builder: (context) {
                    return ContextTileDialog(
                      context: Context(
                          newlyCreated: true,
                          ContextName: "",
                          ContextId: -1,
                          Hotkey: "",
                          WordId: null,
                          ExcelId: null,
                          WinExpId: null,
                          NppId: null,
                          FirefoxId: null),
                      key: UniqueKey(),
                      newlyCreated: true,
                    );
                  });
            } else {
              showMaximumContextLimitReachedDialog();
            }
          },
        ),
        body: Consumer<ContextViewModel>(
          builder: (context, viewModel, child) {
            createContextTilesFromContexts(viewModel.currentUsersContexts);
            return Container(
                color: Theme.of(context).colorScheme.secondary,
                child: GridView.extent(
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 0.833,
                    children: [
                      ...contexts
                    ])); //... is needed for gridview to update properly dont know why?
          },
        ));
  }
}
