import 'package:context_switcher/DatabaseModels/Excel.dart';
import 'package:context_switcher/DatabaseModels/Firefox.dart';
import 'package:context_switcher/DatabaseModels/Npp.dart';
import 'package:context_switcher/DatabaseModels/WinExp.dart';
import 'package:context_switcher/DatabaseModels/Word.dart';

class Context {
  late int ContextId;
  late String Hotkey;
  late String ContextName;
  late int? ExcelId;
  late int? WordId;
  late int? WinExpId;
  late int? FirefoxId;
  late int? NppId;
  Word? word; //NOT IN THE DATABASE, ADDED FOR TO BE USED IN CODE
  Excel? excel;
  Npp? npp;
  Firefox? firefox;
  WinExp? winExp;
  bool newlyCreated =
      false; //NOT IN THE DATABASE, USED TO DETERMINE IF THIS CONTEXT IS CREATED NEW. IF SO INSERT TO DATABASE RATHER THAN UPDATE.

  Context(
      {this.newlyCreated = false,
      required this.ContextId,
      required this.Hotkey,
      required this.ContextName,
      required this.ExcelId,
      required this.FirefoxId,
      required this.NppId,
      required this.WinExpId,
      required this.WordId});

  Map<String, dynamic> toMap() {
    return {
      'Hotkey': Hotkey,
      'ContextName': ContextName,
      'ExcelId': ExcelId,
      'FirefoxId': FirefoxId,
      'NppId': NppId,
      'WinExpId': WinExpId,
      'WordId': WordId
    };
  }
}
