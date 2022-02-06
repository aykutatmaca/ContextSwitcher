import 'package:context_switcher/DatabaseModels/Context.dart';
import 'package:context_switcher/Singletons/current_user.dart';
import 'package:context_switcher/ViewModels/context_viewmodel.dart';
import 'package:context_switcher/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'context_tile_settings_dialog.dart';

class ContextTile extends StatefulWidget {
  ContextTile({Key? key, required this.context}) : super(key: key);
  Context context;

  @override
  State<ContextTile> createState() => _ContextTile();
}

class _ContextTile extends State<ContextTile> {
  double padding = 5;

  Color contextColor = Colors.grey;

  final ImageProvider userImage = AssetImage("lib/assets/profile_pictures/" +
      Constants.profilePictures[CurrentUser.instance.userProfilePicture]);

  void onPressedSettings() async {
    BuildContext buildContext = context;
    await showDialog(
        barrierDismissible: false,
        useRootNavigator: false,
        context: buildContext,
        builder: (context) {
          return ContextTileDialog(
            context: widget.context,
            key: UniqueKey(),
            newlyCreated: false,
          );
        });
  }

  void onPressedDeleteShowAlert() async {
    Widget okButton = TextButton(
      child: Text("Delete",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      onPressed: () {
        deleteContext();
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
          "Are you sure you want to delete context ${widget.context.ContextName}?",
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

  void deleteContext() {
    Provider.of<ContextViewModel>(context, listen: false)
        .deleteContext(widget.context);
  }

  @override
  Widget build(BuildContext context) {
    contextColor = getAvgColorFor(widget.context);
    return Container(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          Expanded(
              flex: 80,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: userImage,
                    colorFilter:
                        ColorFilter.mode(contextColor, BlendMode.color),
                  )),
                ),
              )),
          //Image.asset("lib/assets/profile_placeholder.png")),
          Expanded(
              flex: 20,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.context.ContextName,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "CTRL+SHIFT+" + widget.context.Hotkey,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 10),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: onPressedDeleteShowAlert),
                              IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: onPressedSettings)
                            ],
                          )))
                ],
              ))
        ],
      ),
    );
  }

  Color getAvgColorFor(Context context) {
    int r = 0, g = 0, b = 0;
    int numSubcontexts = 0;
    Color avgColor = Colors.grey;

    // MS Word:   #2D559B - 45, 85, 155
    Color wordColor = const Color.fromRGBO(45, 85, 155, 1);

    // MS Excel:  #1F6D42 - 31, 109, 66
    Color excelColor = const Color.fromRGBO(31, 109, 66, 1);

    // Firefox:   #F28902 - 242, 137, 2
    Color firefoxColor = const Color.fromRGBO(242, 137, 2, 1);

    // Notepad++: #A1E778 - 161, 231, 120
    Color nppColor = const Color.fromRGBO(161, 231, 120, 1);

    // WinExp:    #F2CC5E - 242, 204, 94
    Color winExpColor = const Color.fromRGBO(242, 204, 94, 1);

    if (context.word != null) {
      r += wordColor.red;
      g += wordColor.green;
      b += wordColor.blue;
      numSubcontexts++;
    }

    if (context.excel != null) {
      r += excelColor.red;
      g += excelColor.green;
      b += excelColor.blue;
      numSubcontexts++;
    }

    if (context.firefox != null) {
      r += firefoxColor.red;
      g += firefoxColor.green;
      b += firefoxColor.blue;
      numSubcontexts++;
    }

    if (context.npp != null) {
      r += nppColor.red;
      g += nppColor.green;
      b += nppColor.blue;
      numSubcontexts++;
    }

    if (context.winExp != null) {
      r += winExpColor.red;
      g += winExpColor.green;
      b += winExpColor.blue;
      numSubcontexts++;
    }

    if (numSubcontexts == 0) {
      return Colors.orange;
    }

    int avgR = r ~/ numSubcontexts;
    int avgG = g ~/ numSubcontexts;
    int avgB = b ~/ numSubcontexts;

    avgColor = Color.fromRGBO(avgR, avgG, avgB, 1);
    return avgColor;
  }
}
