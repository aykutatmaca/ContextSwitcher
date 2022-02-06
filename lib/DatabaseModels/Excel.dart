class Excel {
  late int? ExcelId;
  late int OpenNew;
  late String Paths;
  late List<String> pathlist =
      []; //NOT IN THE DATABASE, ADDED FOR TO BE USED IN CODE

  Excel({this.ExcelId, required this.OpenNew, required this.Paths});

  Map<String, dynamic> toMap() {
    return {
      'ExcelId': ExcelId,
      'OpenNew': OpenNew,
      'Paths': Paths,
    };
  }
}
