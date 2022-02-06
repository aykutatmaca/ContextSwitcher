import 'package:context_switcher/DatabaseModels/User.dart';
import 'package:context_switcher/ViewModels/login_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';

class LoginAuthScreen extends StatefulWidget {
  LoginAuthScreen({Key? key, required this.user, required this.image})
      : super(key: key);

  final ImageProvider image;
  final User user;

  @override
  State<LoginAuthScreen> createState() => _LoginAuthScreenState();
}

class _LoginAuthScreenState extends State<LoginAuthScreen> {
  String password = "";
  final fieldText = TextEditingController();
  Color textFieldColor = Colors.white;

  late FocusNode textFieldFocusNode = FocusNode();
  late FocusNode pageFocusNode = FocusNode();

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: pageFocusNode,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onTap: () {
          textFieldFocusNode.requestFocus();
        },
        child: Scaffold(
          floatingActionButton: SizedBox(
            height: 65,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () => {
                  Navigator.pop(context),
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          body: Container(
            constraints: const BoxConstraints.expand(),
            color: Theme.of(context).colorScheme.secondary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: "avatar-user-" + widget.user.userId.toString(),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: widget.image,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.user.userName,
                  style: TextStyle(color: textFieldColor, fontSize: 26),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                    width: 250,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (text) {
                              password = text;
                            },
                            onSubmitted: (text) {
                              submitPassword(context);
                            },
                            controller: fieldText,
                            autofocus: true,
                            focusNode: textFieldFocusNode,
                            obscureText: true,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.login),
                                  color: textFieldColor,
                                  onPressed: () {
                                    submitPassword(context);
                                  }),
                              labelText: "Password",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: textFieldColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: textFieldColor,
                                  width: 2,
                                ),
                              ),
                              focusColor: textFieldColor,
                              labelStyle: TextStyle(color: textFieldColor),
                            ),
                            cursorColor: textFieldColor,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitPassword(context) {
    if (Provider.of<LoginViewModel>(context, listen: false)
        .loginUser(widget.user, password)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        textFieldColor = Colors.red;
        password = "";
        fieldText.clear();
        textFieldFocusNode.requestFocus();
      });
      Future.delayed(const Duration(milliseconds: 250), () {
        setState(() {
          textFieldColor = Colors.white;
        });
      });
    }
  }
}
