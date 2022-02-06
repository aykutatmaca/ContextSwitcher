class CurrentUser {
  late int userId;
  late String userName;
  late int userProfilePicture;
  late String authorization;
  late List<int> authCodeList;

  static final CurrentUser _currentUser = CurrentUser._internal();

  CurrentUser._internal();

  static CurrentUser get instance => _currentUser;
}
