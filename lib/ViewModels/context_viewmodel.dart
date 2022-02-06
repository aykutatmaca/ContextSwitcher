import 'dart:io';
import 'package:context_switcher/DatabaseModels/Context.dart';
import 'package:context_switcher/DatabaseModels/WinExp.dart';
import 'package:context_switcher/DatabaseModels/Word.dart';
import 'package:context_switcher/DatabaseModels/Excel.dart';
import 'package:context_switcher/DatabaseModels/Firefox.dart';
import 'package:context_switcher/DatabaseModels/Npp.dart';
import 'package:context_switcher/DatabaseModels/Log.dart';
import 'package:context_switcher/Models/ContextModel.dart';
import 'package:context_switcher/Models/log_model.dart';
import 'package:context_switcher/Singletons/current_user.dart';
import 'package:context_switcher/constants.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:process_run/shell.dart';
import 'package:intl/intl.dart';

class ContextViewModel extends ChangeNotifier {
  ContextModel model = ContextModel();
  LogModel logModel = LogModel();

  List<Context> currentUsersContexts = [];
  List<String> availableHotkeys = Constants.allowedHotkeys.toList();
  List<Log> logs = [];

  final Shell shell = Shell();

  void getContextsOfCurrentUser() async {
    List<Context> contexts =
        await model.getContextsByUser(CurrentUser.instance.userId);

    availableHotkeys =
        Constants.allowedHotkeys.toList(); //reset available hotkeys

    await unregisterHotkeys();

    for (var context in contexts) {
      context.word = await model.getWordByContext(context.WordId);
      context.word?.pathlist =
          (context.word?.Paths.split(Constants.breakBetweenPaths))!;

      context.excel = await model.getExcelByContext(context.ExcelId);
      context.excel?.pathlist =
          (context.excel?.Paths.split(Constants.breakBetweenPaths))!;

      context.firefox = await model.getFirefoxByContext(context.FirefoxId);
      context.firefox?.urlList =
          (context.firefox?.URLs.split(Constants.breakBetweenPaths))!;

      context.winExp = await model.getWinExpyContext(context.WinExpId);
      context.winExp?.pathlist =
          (context.winExp?.Paths.split(Constants.breakBetweenPaths))!;

      context.npp = await model.getNppByContext(context.NppId);
      context.npp?.pathlist =
          (context.npp?.Paths.split(Constants.breakBetweenPaths))!;

      availableHotkeys.remove(
          context.Hotkey); //remove already taken hotkeys from available list

      await setHotkeyFor(context);
    }
    currentUsersContexts = contexts;
    notifyListeners();
  }

  void updateContext(Context context) async {
    // if apps are empty, set them to null
    if (context.excel != null &&
            (context.excel?.OpenNew == 0 &&
                (context.excel?.pathlist.isEmpty)!) ||
        (context.excel?.pathlist.length == 1 &&
            (context.excel?.pathlist[0].isEmpty)!)) {
      context.excel = null;
      context.ExcelId = null;
    }
    if (context.word != null &&
            (context.word?.OpenNew == 0 && (context.word?.pathlist.isEmpty)!) ||
        (context.word?.pathlist.length == 1 &&
            (context.word?.pathlist[0].isEmpty)!)) {
      context.word = null;
      context.WordId = null;
    }
    if (context.winExp != null && (context.winExp?.pathlist.isEmpty)! ||
        (context.winExp?.pathlist.length == 1 &&
            (context.winExp?.pathlist[0].isEmpty)!)) {
      context.winExp = null;
      context.WinExpId = null;
    }
    if (context.firefox != null &&
            (context.firefox?.OpenNew == 0 &&
                (context.firefox?.urlList.isEmpty)!) ||
        (context.firefox?.urlList.length == 1 &&
            (context.firefox?.urlList[0].isEmpty)!)) {
      context.firefox = null;
      context.FirefoxId = null;
    }
    if (context.npp != null &&
            (context.npp?.OpenNew == 0 && (context.npp?.pathlist.isEmpty)!) ||
        (context.npp?.pathlist.length == 1 &&
            (context.npp?.pathlist[0].isEmpty)!)) {
      context.npp = null;
      context.NppId = null;
    }
    if (!context.newlyCreated) {
      await model.updateContext(context);
    } else {
      await model.insertContext(context);
    }
    getContextsOfCurrentUser();
  }

  void deleteContext(Context context) async {
    await model.deleteContext(context);
    getContextsOfCurrentUser();
  }

  Future<void> setHotkeyFor(Context context) async {
    KeyCode? keycode;

    switch (context.Hotkey.toLowerCase()) {
      case "f1":
        keycode = KeyCode.f1;
        break;
      case "f2":
        keycode = KeyCode.f2;
        break;
      case "f3":
        keycode = KeyCode.f3;
        break;
      case "f4":
        keycode = KeyCode.f4;
        break;
      case "f5":
        keycode = KeyCode.f5;
        break;
      case "f6":
        keycode = KeyCode.f6;
        break;
      case "f7":
        keycode = KeyCode.f7;
        break;
      case "f8":
        keycode = KeyCode.f8;
        break;
      case "f9":
        keycode = KeyCode.f9;
        break;
      case "f10":
        keycode = KeyCode.f10;
        break;
      default:
        keycode = null;
        break;
    }

    if (keycode == null) return;

    HotKey _hotKey = HotKey(
      keycode,
      modifiers: [KeyModifier.control, KeyModifier.shift],
      scope: HotKeyScope.system,
    );

    await hotKeyManager.register(
      _hotKey,
      keyDownHandler: (hotKey) {
        print("Hotkey " +
            hotKey.toString() +
            " runs the context " +
            context.ContextName);
        runContext(context);
      },
    );
  }

  void runContext(Context context) {
    Word? word = context.word;
    if (word != null) {
      if (word.OpenNew == 1) runWord();
      runWord(pathList: word.pathlist);
    }

    Excel? excel = context.excel;
    if (excel != null) {
      if (excel.OpenNew == 1) runExcel();
      runExcel(pathList: excel.pathlist);
    }

    Firefox? firefox = context.firefox;
    if (firefox != null) {
      runFirefox(openNew: (firefox.OpenNew == 1), urlList: firefox.urlList);
    }

    Npp? npp = context.npp;
    if (npp != null) {
      if (npp.OpenNew == 1) runNpp();
      runNpp(pathList: npp.pathlist);
    }

    WinExp? winExp = context.winExp;
    if (winExp != null) {
      runWinExp(pathList: winExp.pathlist);
    }
    var now = DateTime.now();
    var timeStamp = DateFormat("dd/MM/yyyy, kk:mm").format(now);
    Log log = Log(
        UserId: CurrentUser.instance.userId,
        ContextId: context.ContextId,
        TimeStamp: timeStamp);
    createLog(log);
  }

  void runWord({List<String>? pathList}) async {
    if (pathList == null) {
      Process.start("start winword", ["/q", "/w"], runInShell: true);
      return;
    }

    if (pathList.length == 1 && pathList[0].isEmpty) return;

    List<String> dirList =
        pathList.where((p) => p.isNotEmpty && p[p.length - 1] == "\\").toList();

    List<String> fileList =
        pathList.where((p) => !dirList.contains(p)).toList();

    for (String dirStr in dirList) {
      Directory dir = Directory(dirStr);
      List<FileSystemEntity> entities = await dir.list().toList();

      for (var element in entities) {
        if (element is File &&
            Constants.wordExtensions.contains(element.path.split(".").last)) {
          fileList.add(element.path);
        }
      }
    }

    if (fileList.isEmpty) return;
    String fileArg = fileList.map((p) => "\"$p\"").join(" ");
    await shell.run("start winword /q $fileArg");
  }

  void runExcel({List<String>? pathList}) async {
    if (pathList == null) {
      Process.start("start excel", ["/x"], runInShell: true);
      return;
    }

    if (pathList.length == 1 && pathList[0].isEmpty) return;

    List<String> dirList =
        pathList.where((p) => p.isNotEmpty && p[p.length - 1] == "\\").toList();

    List<String> fileList =
        pathList.where((p) => !dirList.contains(p)).toList();

    for (String dirStr in dirList) {
      Directory dir = Directory(dirStr);
      List<FileSystemEntity> entities = await dir.list().toList();

      for (var element in entities) {
        if (element is File &&
            Constants.excelExtensions.contains(element.path.split(".").last)) {
          fileList.add(element.path);
        }
      }
    }

    if (fileList.isEmpty) return;
    String fileArg = fileList.map((p) => "\"$p\"").join(" ");
    await shell.run("start excel $fileArg");
  }

  /*
  void runExcel({List<String>? pathList}) {
    if (pathList == null) {
      Process.run("start excel", ["/x"], runInShell: true);
      return;
    }
    if (!(pathList.length == 1 && pathList[0].isEmpty)) {
      String pathArg = pathList.map((p) => "\"$p\"").join(" ");
      shell.run("start excel $pathArg");
    }
  }
  */

  void runFirefox({bool openNew = false, List<String>? urlList}) {
    urlList!.removeWhere((element) => element == "");
    List<String> urlArgs = [];
    for (var url in urlList) {
      urlArgs.add("-new-tab");
      urlArgs.add("-url");
      urlArgs.add(url);
    }

    if (openNew) {
      urlArgs.add("-new-tab");
      urlArgs.add("-url");
      urlArgs.add("about:newtab");
    }

    if (urlArgs.isNotEmpty) {
      // print(urlArgs);
      Process.start("start firefox", urlArgs, runInShell: true);
    }
  }

  void runNpp({List<String>? pathList}) {
    if (pathList == null) {
      Process.run("start notepad++", ["-multiInst", "-nosession"],
          runInShell: true);
      return;
    }
    if (!(pathList.length == 1 && pathList[0].isEmpty)) {
      String pathArg = pathList.map((p) => "\"$p\"").join(" ");
      shell.run("start notepad++ -multiInst -nosession $pathArg");
    }
  }

  void runWinExp({List<String>? pathList}) {
    if (pathList == null) {
      Process.run("start explorer", [], runInShell: true);
      return;
    }
    if (!(pathList.length == 1 && pathList[0].isEmpty)) {
      for (String path in pathList) {
        shell.run("start explorer $path");
      }
    }
  }

  Future<void> unregisterHotkeys() async {
    await hotKeyManager.unregisterAll();
  }

  void getAllLogs() async {
    logs.clear();
    logs = await logModel.getAllLogs();
    notifyListeners();
  }

  void createLog(Log log) {
    logModel.createLog(log);
    getAllLogs();
  }
}
