class User {
  int userId;
  String userName;
  int userProfilePicture;
  String authorization;
  String password;

  User(
      {required this.userId,
      required this.userName,
      required this.userProfilePicture,
      required this.authorization,
      required this.password});

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'authorization': authorization,
      'password': password
    };
  }
}
