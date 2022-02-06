import 'package:context_switcher/CustomWidgets/log_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:context_switcher/ViewModels/context_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen>
    with AutomaticKeepAliveClientMixin<SettingsScreen> {
  @override
  bool get wantKeepAlive => true;
  bool run_at_start_value = false;
  bool minimize = false;

  void run_at_start(bool boolean) {
    setState(() {
      run_at_start_value = boolean;
    });
  }

  void minimize_app(bool boolean) {
    setState(() {
      minimize = boolean;
    });
  }

  createAlertDialog(BuildContext context) {
    //   TextEditingController customController = new TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Version: 1.0\n\nContributors:\nAykut Atmaca\nAli Özgür Solak\nErkin Şahin\nTalha Yavaş", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            backgroundColor:Theme.of(context).colorScheme.secondary,
            title: Text("Context Switcher", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
          );
        });
  }

  void showLogsDialog() {
    showDialog(
        barrierDismissible: false,
        useRootNavigator: false,
        context: context,
        builder: (context) {
          return LogDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Provider.of<ContextViewModel>(context, listen: false).getAllLogs();
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      child: Container(
        padding: EdgeInsets.all(40),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
            Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              GestureDetector(
                  onTap: () => run_at_start(!run_at_start_value),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        border: Border.all(
                          color: Colors.blueGrey,
                          width: 3,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Run at Start            ",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 20,
                                  color: Colors.white38)),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                                activeColor: Colors.greenAccent,
                                value: run_at_start_value,
                                onChanged: (value) {
                                  setState(() {
                                    run_at_start_value = value;
                                  });
                                }),
                          ),
                        ]),
                    width: 330,
                    height: 40,
                  )),
            ]),
            const Divider(),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  //background color of button
                  side: const BorderSide(width: 3, color: Colors.blueGrey),
                  //border width and color
                  elevation: 3,
                  //elevation of button
                  shape: RoundedRectangleBorder(
                      //to set border radius to button
                      borderRadius: BorderRadius.circular(
                          10)), //content padding inside button
                ),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: const Text("Check for updates",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 20,
                          color: Colors.white38)),
                  width: 300,
                  height: 40,
                )),
            const Divider(),
            ElevatedButton(
                onPressed: () {
                  createAlertDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  //background color of button
                  side: const BorderSide(width: 3, color: Colors.blueGrey),
                  //border width and color
                  elevation: 3,
                  //elevation of button
                  shape: RoundedRectangleBorder(
                      //to set border radius to button
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: const Text("About",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 20,
                          color: Colors.white38)),
                  width: 300,
                  height: 40,
                )),
            const Divider(),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  //background color of button
                  side: const BorderSide(width: 3, color: Colors.blueGrey),
                  //border width and color
                  elevation: 3,
                  //elevation of button
                  shape: RoundedRectangleBorder(
                      //to set border radius to button
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: const Text("Import",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 20,
                          color: Colors.white38)),
                  width: 300,
                  height: 40,
                )),
            const Divider(),
            ElevatedButton(
                onPressed: () {
                  showLogsDialog();
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  //background color of button
                  side: const BorderSide(width: 3, color: Colors.blueGrey),
                  //border width and color
                  elevation: 3,
                  //elevation of button
                  shape: RoundedRectangleBorder(
                      //to set border radius to button
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: const Text("Logs",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 20,
                          color: Colors.white38)),
                  width: 300,
                  height: 40,
                )),
          ]),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              GestureDetector(
                  onTap: () => minimize_app(!minimize),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        border: Border.all(
                          color: Colors.blueGrey,
                          width: 3,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),

                    padding: const EdgeInsets.all(1.0),

                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Minimize when closed          ",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 20,
                                  color: Colors.white38)),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                                activeColor: Colors.greenAccent,
                                value: minimize,
                                onChanged: (value) {
                                  setState(() {
                                    minimize = value;
                                  });
                                }),
                          ),
                        ]),
                    width: 330,
                    height:
                        40, //   color: Theme.of(context).colorScheme.primary,
                  )),
            ]),
            const Divider(),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  //background color of button
                  side: const BorderSide(width: 3, color: Colors.blueGrey),
                  //border width and color
                  elevation: 3,
                  //elevation of button
                  shape: RoundedRectangleBorder(
                      //to set border radius to button
                      borderRadius: BorderRadius.circular(10)),
                  // padding: EdgeInsets.all(20) //content padding inside button
                ),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: const Text("Reset",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 20,
                          color: Colors.white38)),
                  width: 300,
                  height: 40,
                )),
            const Divider(),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  //background color of button
                  side: const BorderSide(width: 3, color: Colors.blueGrey),
                  //border width and color
                  elevation: 3,
                  //elevation of button
                  shape: RoundedRectangleBorder(
                      //to set border radius to button
                      borderRadius: BorderRadius.circular(10)),
                  // padding: EdgeInsets.all(20) //content padding inside button
                ),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: const Text("Help",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 20,
                          color: Colors.white38)),
                  width: 300,
                  height: 40,
                )),
            const Divider(),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  //background color of button
                  side: const BorderSide(width: 3, color: Colors.blueGrey),
                  //border width and color
                  elevation: 3,
                  //elevation of button
                  shape: RoundedRectangleBorder(
                      //to set border radius to button
                      borderRadius: BorderRadius.circular(10)),
                  // padding: EdgeInsets.all(20) //content padding inside button
                ),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: const Text("Export",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 20,
                          color: Colors.white38)),
                  width: 300,
                  height: 40,
                )),
          ]),
        ]),
      ),
    );
  }
}
