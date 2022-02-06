class WinExp {
  late int? WinExpId;
  late String Paths;
  late List<String> pathlist =
      []; //NOT IN THE DATABASE, ADDED FOR TO BE USED IN CODE

  WinExp({this.WinExpId, required this.Paths});

  Map<String, dynamic> toMap() {
    return {
      'WinExpId': WinExpId,
      'Paths': Paths,
    };
  }
}
