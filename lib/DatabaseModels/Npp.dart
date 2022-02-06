class Npp {
  late int? NppId;
  late int OpenNew;
  late String Paths;
  late List<String> pathlist =
      []; //NOT IN THE DATABASE, ADDED FOR TO BE USED IN CODE

  Npp({this.NppId, required this.OpenNew, required this.Paths});

  Map<String, dynamic> toMap() {
    return {
      'NppId': NppId,
      'OpenNew': OpenNew,
      'Paths': Paths,
    };
  }
}
