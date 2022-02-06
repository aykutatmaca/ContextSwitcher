class Firefox {
  late int? FirefoxId;
  late int OpenNew;
  late String URLs;
  late List<String> urlList =
      []; //NOT IN THE DATABASE, ADDED FOR TO BE USED IN CODE

  Firefox({this.FirefoxId, required this.OpenNew, required this.URLs});

  Map<String, dynamic> toMap() {
    return {
      'FirefoxId': FirefoxId,
      'OpenNew': OpenNew,
      'URLs': URLs,
    };
  }
}
