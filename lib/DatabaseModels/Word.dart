class Word {
  late int? WordId;
  late int OpenNew;
  late String Paths;
  late List<String> pathlist =
      []; //NOT IN THE DATABASE, ADDED FOR TO BE USED IN CODE

  Word({this.WordId, required this.OpenNew, required this.Paths});

  Map<String, dynamic> toMap() {
    return {
      'WordId': WordId,
      'OpenNew': OpenNew,
      'Paths': Paths,
    };
  }
}
