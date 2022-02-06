import 'dart:collection';

class Constants {
  static const int maxProfileCount = 5;
  static const int maxContextPerProfileCount = 10;

  //AUTH CODES
  static const int isAdmin = 99;

  static const int canUseWord = 1;
  static const int canUseExcel = 2;
  static const int canUseNpp = 3;
  static const int canUseFirefox = 4;
  static const int canUseWinExp = 5;

  static const breakBetweenAuthCodes = ".";

  //SUPPORTED APPS
  static const List<String> supportedApps = [
    MICROSOFT_WORD,
    MICROSOFT_EXCEL,
    NOTEPADPP,
    MOZILLA_FIREFOX,
    WINDOWS_EXPLORER
  ];

  //CTRL + SHIFT + F1-F10
  static const List<String> allowedHotkeys = [
    "F1",
    "F2",
    "F3",
    "F4",
    "F5",
    "F6",
    "F7",
    "F8",
    "F9",
    "F10"
  ];

  static const String MICROSOFT_WORD = 'Microsoft Word';
  static const String NOTEPADPP = 'Notepad++';
  static const String MICROSOFT_EXCEL = 'Microsoft Excel';
  static const String MOZILLA_FIREFOX = 'Mozilla Firefox';
  static const String WINDOWS_EXPLORER = 'Windows Explorer';

  static const Set<String> wordExtensions = {
    "docx",
    "docm",
    "dotx",
    "dotm",
    "doc",
    "dot",
    "htm",
    "html",
    "rtf",
    "mht",
    "mhtml",
    "xml",
    "odt",
    "pdf",
  };

  static const Set<String> excelExtensions = {
    "xl",
    "xlsx",
    "xlsm",
    "xlsb",
    "xlam",
    "xltx",
    "xltm",
    "xls",
    "xlt",
    "htm",
    "html",
    "mht",
    "mhtml",
    "xml",
    "xla",
    "xlm",
    "xlw",
    "odc",
    "ods",
  };

  static const List<String> profilePictures = [
    "books.jpg",
    "coding.jpg",
    "creative.jpg",
    "paint.jpg",
    "studying.jpg",
    "typing.jpg",
    "working.jpg"
  ];
  static const String breakBetweenPaths = " | ";
}
