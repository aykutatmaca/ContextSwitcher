import 'package:context_switcher/DatabaseModels/User.dart';
import 'package:context_switcher/Singletons/db_helper.dart';

class UserModel {
  Future<List<User>> getAllUsers() async {
    var db = await DBHelper.instance.database;
    var result = await db.query("USERS");
    final List<Map<String, dynamic>> maps = result;
    List<User> users = List.generate(maps.length, (i) {
      return User(
          userId: maps[i]['userId'],
          userName: maps[i]['userName'],
          userProfilePicture: maps[i]['userProfilePicture'],
          authorization: maps[i]['authorization'],
          password: maps[i]["password"]);
    });
    return users;
  }

  Future<User> getUser(userId) async {
    var db = await DBHelper.instance.database;

    List<Map<String, dynamic>> user = await db
        .query("USERS", where: "UserId = ?", whereArgs: [userId.toString()]);

    List<User> userList = List.generate(user.length, (index) {
      return User(
          userId: user[index]['userId'],
          userName: user[index]['userName'],
          userProfilePicture: user[index]['userProfilePicture'],
          authorization: user[index]['authorization'],
          password: user[index]["password"]
      );
    });

    return userList.first;
  }

  Future<int> createUser(User user) async {
    var db = await DBHelper.instance.database;
    return db.insert("USERS", user.toMap());
  }

  Future<int> updateUser(User user) async {
    var db = await DBHelper.instance.database;

    return db.update("USERS", user.toMap(), where: "userId = ?", whereArgs: [user.userId]);
  }

  Future<int> deleteUser(User user) async {
    var db = await DBHelper.instance.database;

    return db.delete("USERS", where: "userId = ?", whereArgs: [user.userId.toString()]);
  }
}
