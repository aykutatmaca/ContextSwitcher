import 'package:context_switcher/DatabaseModels/Context.dart';
import 'package:context_switcher/DatabaseModels/Excel.dart';
import 'package:context_switcher/DatabaseModels/Firefox.dart';
import 'package:context_switcher/DatabaseModels/Npp.dart';
import 'package:context_switcher/DatabaseModels/UserContext.dart';
import 'package:context_switcher/DatabaseModels/WinExp.dart';
import 'package:context_switcher/DatabaseModels/Word.dart';
import 'package:context_switcher/Singletons/current_user.dart';
import 'package:context_switcher/Singletons/db_helper.dart';
import 'package:context_switcher/constants.dart';

class ContextModel {
  Future<List<Context>> getContextsByUser(userId) async {
    var db = await DBHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.query("UserContext",
        columns: ["ContextId"],
        where: "UserId = ?",
        whereArgs: [userId.toString()]);
    List<String> contextIds = List.generate(
        maps.length, (index) => maps[index]["ContextId"].toString());
    //maps = await db.query("Contexts",
    //  where: "ContextId IN ?", whereArgs: contextIds); //MIGHT NOT WORK

    maps = await db.rawQuery(
        "SELECT * FROM Contexts WHERE ContextId IN (${contextIds.join(", ")});");
    List<Context> contexts = List.generate(maps.length, (index) {
      return Context(
          ContextId: maps[index]["ContextId"],
          Hotkey: maps[index]["Hotkey"],
          ContextName: maps[index]["ContextName"],
          ExcelId: maps[index]["ExcelId"],
          FirefoxId: maps[index]["FirefoxId"],
          NppId: maps[index]["NppId"],
          WinExpId: maps[index]["WinExpId"],
          WordId: maps[index]["WordId"]);
    });
    return contexts;
  }

  Future<Word?> getWordByContext(wordId) async {
    var db = await DBHelper.instance.database;
    List<Map<String, dynamic>> maps =
        await db.query("Word", where: "WordId = ?", whereArgs: [wordId]);
    List<Word> word = List.generate(maps.length, (index) {
      return Word(
        WordId: maps[index]["WordId"],
        OpenNew: maps[index]["OpenNew"],
        Paths: maps[index]["Paths"],
      );
    });
    return word.isEmpty ? null : word.first;
  }

  Future<Excel?> getExcelByContext(excelId) async {
    var db = await DBHelper.instance.database;
    List<Map<String, dynamic>> maps =
        await db.query("Excel", where: "ExcelId = ?", whereArgs: [excelId]);
    List<Excel> excel = List.generate(maps.length, (index) {
      return Excel(
        ExcelId: maps[index]["ExcelId"],
        OpenNew: maps[index]["OpenNew"],
        Paths: maps[index]["Paths"],
      );
    });
    return excel.isEmpty ? null : excel.first;
  }

  Future<Npp?> getNppByContext(nppId) async {
    var db = await DBHelper.instance.database;
    List<Map<String, dynamic>> maps =
        await db.query("Npp", where: "NppId = ?", whereArgs: [nppId]);
    List<Npp> npp = List.generate(maps.length, (index) {
      return Npp(
        NppId: maps[index]["NppId"],
        OpenNew: maps[index]["OpenNew"],
        Paths: maps[index]["Paths"],
      );
    });
    return npp.isEmpty ? null : npp.first;
  }

  Future<Firefox?> getFirefoxByContext(firefoxId) async {
    var db = await DBHelper.instance.database;
    List<Map<String, dynamic>> maps = await db
        .query("Firefox", where: "FirefoxId = ?", whereArgs: [firefoxId]);
    List<Firefox> firefox = List.generate(maps.length, (index) {
      return Firefox(
        FirefoxId: maps[index]["FirefoxId"],
        OpenNew: maps[index]["OpenNew"],
        URLs: maps[index]["URLs"],
      );
    });
    return firefox.isEmpty ? null : firefox.first;
  }

  Future<WinExp?> getWinExpyContext(winExpId) async {
    var db = await DBHelper.instance.database;
    List<Map<String, dynamic>> maps =
        await db.query("WinExp", where: "WinExpId = ?", whereArgs: [winExpId]);
    List<WinExp> winExp = List.generate(maps.length, (index) {
      return WinExp(
        WinExpId: maps[index]["WinExpId"],
        Paths: maps[index]["Paths"],
      );
    });
    return winExp.isEmpty ? null : winExp.first;
  }

  Future<void> updateContext(Context context) async {
    var db = await DBHelper.instance.database;

    if (context.WordId != null) {
      //UPDATE EXISTING
      context.word?.pathlist.remove("");
      await db.rawUpdate(
          "UPDATE Word SET OpenNew = ${context.word?.OpenNew}, Paths = '${context.word?.pathlist.join(Constants.breakBetweenPaths)}' WHERE WordId = ${context.WordId};");
    } else if (context.word != null) {
      //CREATE NEW
      context.word?.Paths =
          (context.word?.pathlist.join(Constants.breakBetweenPaths))!;
      context.WordId = await db.insert("Word", (context.word?.toMap())!);
    }

    if (context.ExcelId != null) {
      //UPDATE EXISTING
      context.excel?.pathlist.remove("");
      await db.rawUpdate(
          "UPDATE Excel SET OpenNew = ${context.excel?.OpenNew}, Paths = '${context.excel?.pathlist.join(Constants.breakBetweenPaths)}' WHERE ExcelId = ${context.ExcelId};");
    } else if (context.excel != null) {
      //CREATE NEW
      context.excel?.Paths =
          (context.excel?.pathlist.join(Constants.breakBetweenPaths))!;
      context.ExcelId = await db.insert("Excel", (context.excel?.toMap())!);
    }

    if (context.NppId != null) {
      //UPDATE EXISTING
      context.npp?.pathlist.remove("");
      await db.rawUpdate(
          "UPDATE Npp SET OpenNew = ${context.npp?.OpenNew}, Paths = '${context.npp?.pathlist.join(Constants.breakBetweenPaths)}' WHERE NppId = ${context.NppId};");
    } else if (context.npp != null) {
      //CREATE NEW
      context.npp?.Paths =
          (context.npp?.pathlist.join(Constants.breakBetweenPaths))!;
      context.NppId = await db.insert("Npp", (context.npp?.toMap())!);
    }

    if (context.FirefoxId != null) {
      //UPDATE EXISTING
      context.firefox?.urlList.remove("");
      await db.rawUpdate(
          "UPDATE Firefox SET OpenNew = ${context.firefox?.OpenNew}, URLs = '${context.firefox?.urlList.join(Constants.breakBetweenPaths)}' WHERE FirefoxId = ${context.FirefoxId};");
    } else if (context.firefox != null) {
      //CREATE NEW
      context.firefox?.URLs =
          (context.firefox?.urlList.join(Constants.breakBetweenPaths))!;
      context.FirefoxId =
          await db.insert("Firefox", (context.firefox?.toMap())!);
    }

    if (context.WinExpId != null) {
      //UPDATE EXISTING
      context.winExp?.pathlist.remove("");
      await db.rawUpdate(
          "UPDATE WinExp SET Paths = '${context.winExp?.pathlist.join(Constants.breakBetweenPaths)}' WHERE WinExpId = ${context.WinExpId};");
    } else if (context.winExp != null) {
      //CREATE NEW
      context.winExp?.Paths =
          (context.winExp?.pathlist.join(Constants.breakBetweenPaths))!;
      context.WinExpId = await db.insert("WinExp", (context.winExp?.toMap())!);
    }

    await db.rawUpdate(
        "UPDATE Contexts SET Hotkey = '${context.Hotkey}', ContextName = '${context.ContextName}', WordId = ${context.WordId}, ExcelId = ${context.ExcelId}, WinExpId = ${context.WinExpId}, FirefoxId = ${context.FirefoxId}, NppId = ${context.NppId} WHERE ContextId = ${context.ContextId};");
  }

  Future<void> insertContext(Context context) async {
    var db = await DBHelper.instance.database;

    if (context.word != null) {
      //CREATE NEW
      context.word?.Paths =
          (context.word?.pathlist.join(Constants.breakBetweenPaths))!;
      context.WordId = await db.insert("Word", (context.word?.toMap())!);
    }
    if (context.excel != null) {
      //CREATE NEW
      context.excel?.Paths =
          (context.excel?.pathlist.join(Constants.breakBetweenPaths))!;
      context.ExcelId = await db.insert("Excel", (context.excel?.toMap())!);
    }
    if (context.npp != null) {
      //CREATE NEW
      context.npp?.Paths =
          (context.npp?.pathlist.join(Constants.breakBetweenPaths))!;
      context.NppId = await db.insert("Npp", (context.npp?.toMap())!);
    }
    if (context.firefox != null) {
      //CREATE NEW
      context.firefox?.URLs =
          (context.firefox?.urlList.join(Constants.breakBetweenPaths))!;
      context.FirefoxId =
          await db.insert("Firefox", (context.firefox?.toMap())!);
    }
    if (context.winExp != null) {
      //CREATE NEW
      context.winExp?.Paths =
          (context.winExp?.pathlist.join(Constants.breakBetweenPaths))!;
      context.WinExpId = await db.insert("WinExp", (context.winExp?.toMap())!);
    }

    var contextId = await db.rawInsert(
        "INSERT INTO Contexts (Hotkey, ContextName, WordId, ExcelId, WinExpId, FirefoxId, NppId) VALUES ('${context.Hotkey}', '${context.ContextName}', ${context.WordId}, ${context.ExcelId}, ${context.WinExpId}, ${context.FirefoxId}, ${context.NppId});");
    await db.insert(
        "UserContext",
        UserContext(UserId: CurrentUser.instance.userId, ContextId: contextId)
            .toMap());
  }

  Future<void> deleteContext(Context context) async {
    var db = await DBHelper.instance.database;
    
    await db.rawDelete("DELETE FROM UserContext WHERE ContextId = ${context.ContextId} AND UserId = ${CurrentUser.instance.userId};");
  }
}
