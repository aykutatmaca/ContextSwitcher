import 'package:context_switcher/DatabaseModels/Log.dart';
import 'package:context_switcher/Singletons/db_helper.dart';

class LogModel {
  Future<List<Log>> getAllLogs() async {
    var db = await DBHelper.instance.database;
    var result = await db.query("Log", orderBy: "LogId DESC");
    final List<Map<String, dynamic>> maps = result;
    List<Log> logs = List.generate(maps.length, (i) {
      return Log(
        LogId: maps[i]['LogId'],
        UserId: maps[i]['UserId'],
        ContextId: maps[i]['ContextId'],
        TimeStamp: maps[i]['TimeStamp'],
      );
    });
    
    for(var log in logs) {
      log.contextName = (await db.rawQuery("SELECT ContextName FROM Contexts WHERE ContextId = ${log.ContextId};"))[0]["ContextName"] as String;
      log.userName = (await db.rawQuery("SELECT userName FROM USERS WHERE userId = ${log.UserId};"))[0]["userName"] as String;
    }
    
    return logs;
  }

  Future<void> createLog(Log log) async {
    var db = await DBHelper.instance.database;
    await db.insert("Log", log.toMap());
  }
}
