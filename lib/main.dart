import 'package:context_switcher/Screens/login_profile_screen.dart';
import 'package:context_switcher/ViewModels/context_viewmodel.dart';
import 'package:context_switcher/ViewModels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:window_size/window_size.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'ViewModels/profile_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  await hotKeyManager.unregisterAll();

  windowManager.waitUntilReadyToShow().then((_) async {
    // Set to frameless window
    // await windowManager.setAsFrameless();
    // await windowManager.setSize(Size(600, 600));
    // await windowManager.setPosition(Offset.zero);
    // await windowManager.setMinimizable(false);
    windowManager.show();
  });

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Context Switcher');
    DesktopWindow.setWindowSize(const Size(1280, 720));
    DesktopWindow.setMinWindowSize(const Size(1280, 720));
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LoginViewModel()),
    ChangeNotifierProvider(create: (context) => ContextViewModel()),
    ChangeNotifierProvider(create: (context) => ProfileViewModel()),
  ], child: const ContextSwitcher()));
}

class ContextSwitcher extends StatelessWidget {
  const ContextSwitcher({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ContextSwitcher',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: const MaterialColor(
        0xff212936,
        // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
        <int, Color>{
          50: Color(0xff1e2531), //10%
          100: Color(0xff1a212b), //20%
          200: Color(0xff171d26), //30%
          300: Color(0xff141920), //40%
          400: Color(0xff11151b), //50%
          500: Color(0xff0d1016), //60%
          600: Color(0xff0a0c10), //70%
          700: Color(0xff07080b), //80%
          800: Color(0xff030405), //90%
          900: Color(0xff000000), //100%
        },
      )).copyWith(
              onSecondary: const Color(0xff56657F),
              secondary: const MaterialColor(
                0xff2B3648,
                // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
                <int, Color>{
                  50: Color(0xff4d5b72), //10%
                  100: Color(0xff455166), //20%
                  200: Color(0xff3c4759), //30%
                  300: Color(0xff343d4c), //40%
                  400: Color(0xff2b3340), //50%
                  500: Color(0xff222833), //60%
                  600: Color(0xff1a1e26), //70%
                  700: Color(0xff111419), //80%
                  800: Color(0xff090a0d), //90%
                  900: Color(0xff000000), //100%
                },
              ))),
      home: const LoginProfileScreen(),
    );
  }
}
