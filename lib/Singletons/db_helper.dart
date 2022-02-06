import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  static final DBHelper _db = DBHelper._internal();

  DBHelper._internal();

  static DBHelper get instance => _db;
  static late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    Directory appDocDir =
        await getApplicationDocumentsDirectory(); //Documents folder
    String appDocPath = appDocDir.path;

    //Create or open database in Documents/ContextSwitcher/ContextSwitcherDatabase
    return await databaseFactory //TODO ADD ON CREATE
        .openDatabase(
            join(appDocPath, "ContextSwitcher", 'ContextSwitcherDatabase.db'),
            options: OpenDatabaseOptions(version: 1, onCreate: (db, version) async {
      await onCreateDataBase(db);
    }));
  }

  Future<void> onCreateDataBase(Database db) async {
    await db.execute('''CREATE TABLE "Contexts" ("ContextId"	INTEGER,
        "Hotkey"	TEXT,
        "ContextName"	TEXT,
        "WordId"	INTEGER,
        "ExcelId"	INTEGER,
        "WinExpId"	INTEGER,
        "FirefoxId"	INTEGER,
        "NppId"	INTEGER,
        PRIMARY KEY("ContextId" AUTOINCREMENT)
    );''');

    await db.execute('''CREATE TABLE "Excel" (
	"ExcelId"	INTEGER,
	"OpenNew"	INTEGER,
	"Paths"	TEXT,
	PRIMARY KEY("ExcelId")
);''');

    await db.execute("""CREATE TABLE "Firefox" (
	"FirefoxId"	INTEGER,
	"OpenNew"	INTEGER,
	"URLs"	TEXT,
	PRIMARY KEY("FirefoxId")
);""");

    await db.execute('''CREATE TABLE "Log" (
	"LogId"	INTEGER,
	"UserId"	INTEGER,
	"ContextId"	INTEGER,
	"TimeStamp"	TEXT,
	PRIMARY KEY("LogId" AUTOINCREMENT)
);''');

    await db.execute('''CREATE TABLE "Npp" (
	"NppId"	INTEGER,
	"OpenNew"	INTEGER,
	"Paths"	TEXT,
	PRIMARY KEY("NppId")
);''');

    await db.execute('''CREATE TABLE "USERS" (
	"userId"	INTEGER,
	"userName"	TEXT,
	"userProfilePicture"	INTEGER,
	"authorization"	TEXT,
	"password"	TEXT,
	PRIMARY KEY("userId")
);''');

    await db.execute('''CREATE TABLE "UserContext" (
	"UserId"	INTEGER,
	"ContextId"	INTEGER,
	PRIMARY KEY("UserId","ContextId"),
	FOREIGN KEY("ContextId") REFERENCES "Contexts"("ContextId"),
	FOREIGN KEY("UserId") REFERENCES "USERS"("userId")
);''');

    await db.execute('''CREATE TABLE "WinExp" (
	"WinExpId"	INTEGER,
	"Paths"	TEXT,
	PRIMARY KEY("WinExpId")
);''');

    await db.execute('''CREATE TABLE "Word" (
	"WordId"	INTEGER,
	"OpenNew"	INTEGER,
	"Paths"	TEXT,
	PRIMARY KEY("WordId" AUTOINCREMENT)
);''');

    await db.rawInsert(
        '''INSERT INTO USERS (userName, userProfilePicture, authorization, password) VALUES ('admin', 1, '99.1.2.3.4.5', 'admin');''');
  }
}
