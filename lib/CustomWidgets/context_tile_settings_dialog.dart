import 'package:context_switcher/DatabaseModels/Context.dart';
import 'package:context_switcher/DatabaseModels/Excel.dart';
import 'package:context_switcher/DatabaseModels/Firefox.dart';
import 'package:context_switcher/DatabaseModels/Npp.dart';
import 'package:context_switcher/DatabaseModels/WinExp.dart';
import 'package:context_switcher/DatabaseModels/Word.dart';
import 'package:context_switcher/Singletons/current_user.dart';
import 'package:context_switcher/ViewModels/context_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:context_switcher/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class ModifiedContext extends ChangeNotifier {
  //when user modifies context by adding removing apps etc this gets modified and saved
  ModifiedContext({required this.context});

  List<String> appsNotSelectedYet = Constants.supportedApps.toList();
  Context context;

  void addItem(String string) {
    appsNotSelectedYet.add(string);
    notifyListeners();
  }

  void removeItem(String string) {
    appsNotSelectedYet.remove(string);
    notifyListeners();
  }
}

//THE POPUP THAT OPENS WHEN THE SETTINGS ON A CONTEXT IS CLICKED
class ContextTileDialog extends StatefulWidget {
  late Context context;
  late ModifiedContext modifiedContext;
  late bool newlyCreated;

  ContextTileDialog(
      {Key? key, required this.context, required this.newlyCreated})
      : super(key: key) {
    modifiedContext = ModifiedContext(context: context);
  }

  @override
  State<ContextTileDialog> createState() => _ContextTileDialog();
}

class _ContextTileDialog extends State<ContextTileDialog> {
  List<ContextTileDialogItem> options = [];
  final TextEditingController _controller = TextEditingController();

  void onOptionDelete(ContextTileDialogItem item, BuildContext buildContext) {
    options.remove(item);

    if (item.value == Constants.MICROSOFT_WORD) {
      Provider.of<ModifiedContext>(buildContext, listen: false).context.word =
          null;
      Provider.of<ModifiedContext>(buildContext, listen: false).context.WordId =
          null;
    }
    if (item.value == Constants.MICROSOFT_EXCEL) {
      Provider.of<ModifiedContext>(buildContext, listen: false).context.excel =
          null;
      Provider.of<ModifiedContext>(buildContext, listen: false)
          .context
          .ExcelId = null;
    }
    if (item.value == Constants.NOTEPADPP) {
      Provider.of<ModifiedContext>(buildContext, listen: false).context.npp =
          null;
      Provider.of<ModifiedContext>(buildContext, listen: false).context.NppId =
          null;
    }
    if (item.value == Constants.WINDOWS_EXPLORER) {
      Provider.of<ModifiedContext>(buildContext, listen: false).context.winExp =
          null;
      Provider.of<ModifiedContext>(buildContext, listen: false)
          .context
          .WinExpId = null;
    }
    if (item.value == Constants.MOZILLA_FIREFOX) {
      Provider.of<ModifiedContext>(buildContext, listen: false)
          .context
          .firefox = null;
      Provider.of<ModifiedContext>(buildContext, listen: false)
          .context
          .FirefoxId = null;
    }
    setState(() {});
    Provider.of<ModifiedContext>(buildContext, listen: false)
        .addItem(item.value!);
  }

  @override
  void initState() {
    if (!widget.newlyCreated) {
      buildOptionsFromContext();
    }
    super.initState();
  }

  void addOption() {
    if (options.length < Constants.supportedApps.length) {
      options.add(ContextTileDialogItem(
          onDeleteOption: onOptionDelete, key: UniqueKey()));
    }
  }

  void buildOptionsFromContext() {
    if (widget.context.word != null) {
      if (CurrentUser.instance.authCodeList.contains(Constants.canUseWord)) {
        //check permissions if doesnt have permission delete that app from the context
        options.add(ContextTileDialogItem(
            onDeleteOption: onOptionDelete,
            key: UniqueKey(),
            value: Constants.MICROSOFT_WORD,
            word: widget.context.word));
      } else {
        widget.context.WordId = null;
        widget.context.word = null;
      }
    }
    if (widget.context.excel != null) {
      if (CurrentUser.instance.authCodeList.contains(Constants.canUseExcel)) {
        options.add(ContextTileDialogItem(
            onDeleteOption: onOptionDelete,
            key: UniqueKey(),
            value: Constants.MICROSOFT_EXCEL,
            excel: widget.context.excel));
      } else {
        widget.context.ExcelId = null;
        widget.context.excel = null;
      }
    }
    if (widget.context.npp != null) {
      if (CurrentUser.instance.authCodeList.contains(Constants.canUseNpp)) {
        options.add(ContextTileDialogItem(
            onDeleteOption: onOptionDelete,
            key: UniqueKey(),
            value: Constants.NOTEPADPP,
            npp: widget.context.npp));
      } else {
        widget.context.NppId = null;
        widget.context.npp = null;
      }
    }
    if (widget.context.firefox != null) {
      if (CurrentUser.instance.authCodeList.contains(Constants.canUseFirefox)) {
        options.add(ContextTileDialogItem(
            onDeleteOption: onOptionDelete,
            key: UniqueKey(),
            value: Constants.MOZILLA_FIREFOX,
            firefox: widget.context.firefox));
      } else {
        widget.context.FirefoxId = null;
        widget.context.firefox = null;
      }
    }
    if (widget.context.winExp != null) {
      if (CurrentUser.instance.authCodeList.contains(Constants.canUseWinExp)) {
        options.add(ContextTileDialogItem(
            onDeleteOption: onOptionDelete,
            key: UniqueKey(),
            value: Constants.WINDOWS_EXPLORER,
            winExp: widget.context.winExp));
      } else {
        widget.context.WinExpId = null;
        widget.context.winExp = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        alignment: Alignment.center,
        child: Container(
            width: 400,
            height: 650,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.deepOrange,
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  setState(() {
                    addOption();
                  });
                },
              ),
              appBar: AppBar(
                title: (widget.newlyCreated
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                  hintText: "Enter a name...",
                                  hintStyle: TextStyle(color: Colors.grey)),
                              controller: _controller,
                              cursorColor: Colors.grey,
                              onChanged: (str) {
                                if (_controller.text.isNotEmpty) {
                                  widget.modifiedContext.context.ContextName =
                                      _controller.text;
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    : Text(widget.context.ContextName)),
              ),
              extendBody: true,
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              body: ChangeNotifierProvider(
                  create: (context) {
                    return widget.modifiedContext;
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).colorScheme.onSecondary,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ...options,
                            HotKeySelector(
                              key: UniqueKey(),
                            ),
                            SaveButton(key: UniqueKey())
                          ],
                        ),
                      ))),
            )));
  }
}

class HotKeySelector extends StatefulWidget {
  const HotKeySelector({Key? key}) : super(key: key);

  @override
  State<HotKeySelector> createState() => _HotKeySelectorState();
}

class _HotKeySelectorState extends State<HotKeySelector> {
  List<String> hotkeys = [];
  String? selectedHotkey;

  @override
  void initState() {
    hotkeys =
        Provider.of<ContextViewModel>(context, listen: false).availableHotkeys;
    selectedHotkey =
        Provider.of<ModifiedContext>(context, listen: false).context.Hotkey;
    if (selectedHotkey != null && selectedHotkey!.isEmpty) {
      selectedHotkey = null;
    } else if (!hotkeys.contains(selectedHotkey)) {
      hotkeys.add(selectedHotkey!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: const Text("Select your hotkey."),
      dropdownColor: Theme.of(context).colorScheme.secondary,
      isExpanded: true,
      alignment: Alignment.centerLeft,
      value: selectedHotkey,
      icon: Icon(Icons.arrow_downward,
          color: Theme.of(context).colorScheme.primaryVariant),
      elevation: 16,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      underline: Container(
        height: 2,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      onChanged: (String? newValue) {
        setState(() {
          selectedHotkey = newValue!;
          Provider.of<ModifiedContext>(context, listen: false).context.Hotkey =
              selectedHotkey!;
        });
      },
      items: hotkeys.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text("CTRL+SHIFT+" + value),
        );
      }).toList(),
    );
  }
}

class SaveButton extends StatefulWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool checkValues() {
    var result = true;
    var alertContent = "";
    ModifiedContext modifiedContext =
        Provider.of<ModifiedContext>(context, listen: false);
    if (modifiedContext.context.ContextName.isEmpty) {
      alertContent = "Please enter a name for the context.";
      result = false;
    } else if (modifiedContext.context.Hotkey.isEmpty) {
      alertContent = "Please select your hotkey for the context.";
      result = false;
    } else if (modifiedContext.context.word == null &&
        modifiedContext.context.excel == null &&
        modifiedContext.context.winExp == null &&
        modifiedContext.context.npp == null &&
        modifiedContext.context.firefox == null) {
      alertContent = "Please select at least one app for the context.";
      result = false;
    }
    if (!result) {
      Widget okButton = TextButton(
        child: Text("OK",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          "Warning",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        content: Text(alertContent,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        actions: [
          okButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        onPressed: () {
          if (checkValues()) {
            Provider.of<ContextViewModel>(context, listen: false).updateContext(
                Provider.of<ModifiedContext>(context, listen: false).context);
            Navigator.pop(context);
          }
        },
        child: const Text("Save"),
      ),
    );
  }
}

//THE APPLICATONS THAT ARE SELECTED
class ContextTileDialogItem extends StatefulWidget {
  ContextTileDialogItem(
      {Key? key,
      required this.onDeleteOption,
      this.value,
      this.word,
      this.excel,
      this.winExp,
      this.firefox,
      this.npp})
      : super(key: key);
  late String? value;
  Function onDeleteOption;
  Word? word;
  Excel? excel;
  Npp? npp;
  Firefox? firefox;
  WinExp? winExp;

  @override
  State<ContextTileDialogItem> createState() => _ContextTileDialogItem();
}

class _ContextTileDialogItem extends State<ContextTileDialogItem> {
  String? dropDownValue;
  Widget options = Container();

  @override
  void initState() {
    dropDownValue = widget.value;
    setInitialOptions();
    super.initState();
  }

  void setInitialOptions() {
    if (dropDownValue == Constants.MICROSOFT_WORD) {
      Provider.of<ModifiedContext>(context, listen: false)
          .removeItem(Constants.MICROSOFT_WORD);

      options = WordOptions(
        key: UniqueKey(),
        paths: widget.word?.Paths,
        openNew: widget.word?.OpenNew == 1 ? true : false,
      );
    } else if (dropDownValue == Constants.MICROSOFT_EXCEL) {
      Provider.of<ModifiedContext>(context, listen: false)
          .removeItem(Constants.MICROSOFT_EXCEL);

      options = ExcelOptions(
        key: UniqueKey(),
        paths: widget.excel?.Paths,
        openNew: widget.excel?.OpenNew == 1 ? true : false,
      );
    } else if (dropDownValue == Constants.NOTEPADPP) {
      Provider.of<ModifiedContext>(context, listen: false)
          .removeItem(Constants.NOTEPADPP);

      options = NppOptions(
        key: UniqueKey(),
        paths: widget.npp?.Paths,
        openNew: widget.npp?.OpenNew == 1 ? true : false,
      );
    } else if (dropDownValue == Constants.MOZILLA_FIREFOX) {
      Provider.of<ModifiedContext>(context, listen: false)
          .removeItem(Constants.MOZILLA_FIREFOX);

      options = FirefoxOptions(
        key: UniqueKey(),
        openNew: widget.firefox?.OpenNew == 1 ? true : false,
        urls: widget.firefox?.URLs,
      );
    } else if (dropDownValue == Constants.WINDOWS_EXPLORER) {
      Provider.of<ModifiedContext>(context, listen: false)
          .removeItem(Constants.WINDOWS_EXPLORER);
      options = WinExpOptions(key: UniqueKey(), paths: widget.winExp?.Paths);
    } else {
      options = Container(
        key: UniqueKey(),
      );
    }
  }

  void setOptions() {
    if (dropDownValue == Constants.MICROSOFT_WORD) {
      Provider.of<ModifiedContext>(context, listen: false)
          .removeItem(Constants.MICROSOFT_WORD);
      options = WordOptions(
        key: UniqueKey(),
      );
    } else if (dropDownValue == Constants.MICROSOFT_EXCEL) {
      Provider.of<ModifiedContext>(context, listen: false)
          .removeItem(Constants.MICROSOFT_EXCEL);

      options = ExcelOptions(key: UniqueKey());
    } else if (dropDownValue == Constants.NOTEPADPP) {
      Provider.of<ModifiedContext>(context, listen: false)
          .removeItem(Constants.NOTEPADPP);

      options = NppOptions(
        key: UniqueKey(),
      );
    } else if (dropDownValue == Constants.MOZILLA_FIREFOX) {
      Provider.of<ModifiedContext>(context, listen: false)
          .removeItem(Constants.MOZILLA_FIREFOX);

      options = FirefoxOptions(
        key: UniqueKey(),
      );
    } else if (dropDownValue == Constants.WINDOWS_EXPLORER) {
      Provider.of<ModifiedContext>(context, listen: false)
          .removeItem(Constants.WINDOWS_EXPLORER);
      options = WinExpOptions(
        key: UniqueKey(),
      );
    } else {
      options = Container(
        key: UniqueKey(),
      );
    }

    setState(() {});
  }

  List<String> checkAuthCodesForApps(List<String> list) {
    var appList = list.toList();

    if (dropDownValue != null) {
      appList.add(dropDownValue!);
    }

    if (!CurrentUser.instance.authCodeList.contains(Constants.canUseExcel)) {
      appList.remove(Constants.MICROSOFT_EXCEL);
    }
    if (!CurrentUser.instance.authCodeList.contains(Constants.canUseFirefox)) {
      appList.remove(Constants.MOZILLA_FIREFOX);
    }
    if (!CurrentUser.instance.authCodeList.contains(Constants.canUseWord)) {
      appList.remove(Constants.MICROSOFT_WORD);
    }
    if (!CurrentUser.instance.authCodeList.contains(Constants.canUseNpp)) {
      appList.remove(Constants.NOTEPADPP);
    }
    if (!CurrentUser.instance.authCodeList.contains(Constants.canUseWinExp)) {
      appList.remove(Constants.WINDOWS_EXPLORER);
    }

    return appList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
                flex: 90,
                child: Consumer<ModifiedContext>(
                  builder: (context, modifiedContext, child) {
                    return DropdownButton<String>(
                        hint: const Text("Select an app."),
                        dropdownColor: Theme.of(context).colorScheme.secondary,
                        isExpanded: true,
                        alignment: Alignment.centerLeft,
                        value: dropDownValue,
                        icon: Icon(Icons.arrow_downward,
                            color:
                                Theme.of(context).colorScheme.primaryVariant),
                        elevation: 16,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            if (dropDownValue == Constants.MICROSOFT_WORD) {
                              Provider.of<ModifiedContext>(context,
                                      listen: false)
                                  .context
                                  .word = null;
                              Provider.of<ModifiedContext>(context,
                                      listen: false)
                                  .context
                                  .WordId = null;
                            } else if (dropDownValue ==
                                Constants.MICROSOFT_EXCEL) {
                              Provider.of<ModifiedContext>(context,
                                      listen: false)
                                  .context
                                  .excel = null;
                              Provider.of<ModifiedContext>(context,
                                      listen: false)
                                  .context
                                  .ExcelId = null;
                            } else if (dropDownValue == Constants.NOTEPADPP) {
                              Provider.of<ModifiedContext>(context,
                                      listen: false)
                                  .context
                                  .npp = null;
                              Provider.of<ModifiedContext>(context,
                                      listen: false)
                                  .context
                                  .NppId = null;
                            } else if (dropDownValue ==
                                Constants.MOZILLA_FIREFOX) {
                              Provider.of<ModifiedContext>(context,
                                      listen: false)
                                  .context
                                  .firefox = null;
                              Provider.of<ModifiedContext>(context,
                                      listen: false)
                                  .context
                                  .FirefoxId = null;
                            } else if (dropDownValue ==
                                Constants.WINDOWS_EXPLORER) {
                              Provider.of<ModifiedContext>(context,
                                      listen: false)
                                  .context
                                  .winExp = null;
                              Provider.of<ModifiedContext>(context,
                                      listen: false)
                                  .context
                                  .WinExpId = null;
                            }
                            if (dropDownValue != null) {
                              Provider.of<ModifiedContext>(context,
                                      listen: false)
                                  .addItem(dropDownValue!);
                            }
                            widget.value = newValue;
                            dropDownValue = newValue;
                            setOptions();
                          });
                        },
                        items: mounted
                            ? checkAuthCodesForApps(
                                    Provider.of<ModifiedContext>(context,
                                            listen: false)
                                        .appsNotSelectedYet)
                                .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()
                            : ([dropDownValue] as List<String>).map((String e) {
                                return DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList());
                  },
                )),
            Expanded(
                flex: 10,
                child: IconButton(
                    splashRadius: 0.1,
                    onPressed: () {
                      setState(() {
                        widget.onDeleteOption(widget, context);
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ))),
          ],
        ),
        options
      ],
    );
  }
}

class WordOptions extends StatefulWidget {
  WordOptions({Key? key, this.paths, this.openNew = false}) : super(key: key);
  final List<String> fileExtensions = ["docx", "doc"];
  final String? paths;
  bool openNew = false;

  @override
  State<StatefulWidget> createState() {
    return _WordOptions();
  }
}

class _WordOptions extends State<WordOptions> {
  List<SelectedFile> paths = [];
  var openNew = false;

  void setInitialValues() {
    openNew = widget.openNew;
    List<String> stringPaths = widget.paths != null
        ? widget.paths!.split(Constants.breakBetweenPaths)
        : [];
    for (var path in stringPaths) {
      if (path.isNotEmpty) {
        paths.add(SelectedFile(
          path: path,
          onDeleteSelectedFile: onSelectedFileDelete,
          key: UniqueKey(),
        ));
      }
    }
    if (paths.isEmpty && !openNew) {
      //If there is no word before create it
      Provider.of<ModifiedContext>(context, listen: false).context.word =
          Word(OpenNew: 0, Paths: "");
      Provider.of<ModifiedContext>(context, listen: false).context.WordId =
          null;
    }
  }

  @override
  void initState() {
    setInitialValues();
    super.initState();
  }

  void onAddFile(List<String?> files) {
    for (var path in files) {
      paths.add(SelectedFile(
        key: UniqueKey(),
        path: path!,
        onDeleteSelectedFile: onSelectedFileDelete,
      ));
      Provider.of<ModifiedContext>(context, listen: false)
          .context
          .word
          ?.pathlist
          .add(path);
      print(Provider.of<ModifiedContext>(context, listen: false)
          .context
          .word
          ?.pathlist);
    }
    setState(() {});
  }

  void onSelectedFileDelete(SelectedFile file) {
    paths.remove(file);
    Provider.of<ModifiedContext>(context, listen: false)
        .context
        .word
        ?.pathlist
        .remove(file.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              value: openNew,
              onChanged: (bool? value) {
                setState(() {
                  openNew = value!;
                  Provider.of<ModifiedContext>(context, listen: false)
                      .context
                      .word
                      ?.OpenNew = openNew == true ? 1 : 0;
                });
              },
            ),
            const Text("Open a new document"),
          ],
        ),
        ...paths,
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                allowedExtensions: widget.fileExtensions,
                type: widget.fileExtensions != null
                    ? FileType.custom
                    : FileType.any);
            List<String?> files = [];
            if (result != null) {
              files = result.paths;
            }
            onAddFile(files);
          },
          child: const Text("Pick file"),
        ),
        ElevatedButton(
          onPressed: () async {
            String? selectedDirectory =
                await FilePicker.platform.getDirectoryPath();
            onAddFile([selectedDirectory! + "\\"]);
          },
          child: const Text("Pick Directory"),
        )
      ],
    ));
  }
}

class ExcelOptions extends StatefulWidget {
  ExcelOptions({Key? key, this.paths, this.openNew = false}) : super(key: key);
  final List<String> fileExtensions = ["xlsx"];
  final String? paths;
  bool openNew = false;

  @override
  State<StatefulWidget> createState() {
    return _ExcelOptions();
  }
}

class _ExcelOptions extends State<ExcelOptions> {
  List<SelectedFile> paths = [];
  var openNew = false;

  void setInitialValues() {
    openNew = widget.openNew;
    List<String> stringPaths = widget.paths != null
        ? widget.paths!.split(Constants.breakBetweenPaths)
        : [];
    for (var path in stringPaths) {
      if (path.isNotEmpty) {
        paths.add(SelectedFile(
          path: path,
          onDeleteSelectedFile: onSelectedFileDelete,
          key: UniqueKey(),
        ));
      }
    }
    if (paths.isEmpty && !openNew) {
      //If there is no excel before create it
      Provider.of<ModifiedContext>(context, listen: false).context.excel =
          Excel(OpenNew: 0, Paths: "");
      Provider.of<ModifiedContext>(context, listen: false).context.ExcelId =
          null;
    }
  }

  @override
  void initState() {
    setInitialValues();
    super.initState();
  }

  void onAddFile(List<String?> files) {
    for (var path in files) {
      paths.add(SelectedFile(
        key: UniqueKey(),
        path: path!,
        onDeleteSelectedFile: onSelectedFileDelete,
      ));
      Provider.of<ModifiedContext>(context, listen: false)
          .context
          .excel
          ?.pathlist
          .add(path);
    }
    setState(() {});
  }

  void onSelectedFileDelete(SelectedFile file) {
    paths.remove(file);
    Provider.of<ModifiedContext>(context, listen: false)
        .context
        .excel
        ?.pathlist
        .remove(file.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              value: openNew,
              onChanged: (bool? value) {
                setState(() {
                  openNew = value!;
                  Provider.of<ModifiedContext>(context, listen: false)
                      .context
                      .excel
                      ?.OpenNew = openNew == true ? 1 : 0;
                });
              },
            ),
            const Text("Open a new document"),
          ],
        ),
        ...paths,
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                allowedExtensions: widget.fileExtensions,
                type: widget.fileExtensions != null
                    ? FileType.custom
                    : FileType.any);
            List<String?> files = [];
            if (result != null) {
              files = result.paths;
            }
            onAddFile(files);
          },
          child: const Text("Pick file"),
        ),
        ElevatedButton(
          onPressed: () async {
            String? selectedDirectory =
                await FilePicker.platform.getDirectoryPath();
            onAddFile([selectedDirectory! + "\\"]);
          },
          child: const Text("Pick Directory"),
        )
      ],
    ));
  }
}

class NppOptions extends StatefulWidget {
  NppOptions({Key? key, this.paths, this.openNew = false}) : super(key: key);
  final String? paths;
  bool openNew = false;

  @override
  State<StatefulWidget> createState() {
    return _NppOptions();
  }
}

class _NppOptions extends State<NppOptions> {
  List<SelectedFile> paths = [];
  var openNew = false;

  void setInitialValues() {
    openNew = widget.openNew;
    List<String> stringPaths = widget.paths != null
        ? widget.paths!.split(Constants.breakBetweenPaths)
        : [];
    for (var path in stringPaths) {
      if (path.isNotEmpty) {
        paths.add(SelectedFile(
          path: path,
          onDeleteSelectedFile: onSelectedFileDelete,
          key: UniqueKey(),
        ));
      }
    }
    if (paths.isEmpty && !openNew) {
      //If there is no npp before create it
      Provider.of<ModifiedContext>(context, listen: false).context.npp =
          Npp(OpenNew: 0, Paths: "");
      Provider.of<ModifiedContext>(context, listen: false).context.NppId = null;
    }
  }

  @override
  void initState() {
    setInitialValues();
    super.initState();
  }

  void onAddFile(List<String?> files) {
    for (var path in files) {
      paths.add(SelectedFile(
        key: UniqueKey(),
        path: path!,
        onDeleteSelectedFile: onSelectedFileDelete,
      ));
      Provider.of<ModifiedContext>(context, listen: false)
          .context
          .npp
          ?.pathlist
          .add(path);
    }
    setState(() {});
  }

  void onSelectedFileDelete(SelectedFile file) {
    paths.remove(file);
    Provider.of<ModifiedContext>(context, listen: false)
        .context
        .npp
        ?.pathlist
        .remove(file.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              value: openNew,
              onChanged: (bool? value) {
                setState(() {
                  openNew = value!;
                  Provider.of<ModifiedContext>(context, listen: false)
                      .context
                      .npp
                      ?.OpenNew = openNew == true ? 1 : 0;
                });
              },
            ),
            const Text("Open a new document"),
          ],
        ),
        ...paths,
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform
                .pickFiles(allowMultiple: true, type: FileType.any);
            List<String?> files = [];
            if (result != null) {
              files = result.paths;
            }
            onAddFile(files);
          },
          child: const Text("Pick file"),
        ),
        ElevatedButton(
          onPressed: () async {
            String? selectedDirectory =
                await FilePicker.platform.getDirectoryPath();
            onAddFile([selectedDirectory! + "\\"]);
          },
          child: const Text("Pick Directory"),
        )
      ],
    ));
  }
}

class WinExpOptions extends StatefulWidget {
  //FOR WINDOWS EXPLORER
  const WinExpOptions({Key? key, this.paths}) : super(key: key);
  final String? paths;

  @override
  State<StatefulWidget> createState() {
    return _WinExpOptions();
  }
}

class _WinExpOptions extends State<WinExpOptions> {
  List<SelectedFile> paths = [];
  var openNew = false;

  void setInitialValues() {
    List<String> stringPaths = widget.paths != null
        ? widget.paths!.split(Constants.breakBetweenPaths)
        : [];
    for (var path in stringPaths) {
      if (path.isNotEmpty) {
        paths.add(SelectedFile(
          path: path,
          onDeleteSelectedFile: onSelectedFileDelete,
          key: UniqueKey(),
        ));
      }
    }
    if (paths.isEmpty && !openNew) {
      //If there is no winExp before create it
      Provider.of<ModifiedContext>(context, listen: false).context.winExp =
          WinExp(Paths: "");
      Provider.of<ModifiedContext>(context, listen: false).context.WinExpId =
          null;
    }
  }

  @override
  void initState() {
    setInitialValues();
    super.initState();
  }

  void onAddFile(List<String?> files) {
    for (var path in files) {
      paths.add(SelectedFile(
        key: UniqueKey(),
        path: path!,
        onDeleteSelectedFile: onSelectedFileDelete,
      ));

      Provider.of<ModifiedContext>(context, listen: false)
          .context
          .winExp
          ?.pathlist
          .add(path);
    }
    setState(() {});
  }

  void onSelectedFileDelete(SelectedFile file) {
    paths.remove(file);
    Provider.of<ModifiedContext>(context, listen: false)
        .context
        .winExp
        ?.pathlist
        .remove(file.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        ...paths,
        ElevatedButton(
          onPressed: () async {
            String? selectedDirectory =
                await FilePicker.platform.getDirectoryPath();
            onAddFile([selectedDirectory! + "\\"]);
          },
          child: const Text("Pick Directory"),
        )
      ],
    ));
  }
}

class FirefoxOptions extends StatefulWidget {
  //FOR Firefox
  FirefoxOptions({Key? key, this.openNew = false, this.urls}) : super(key: key);
  final String? urls;
  bool openNew = false;

  @override
  State<StatefulWidget> createState() {
    return _FirefoxOptions();
  }
}

class _FirefoxOptions extends State<FirefoxOptions> {
  //For firefox
  List<SelectedFile> urls = [];
  var openNew = false;

  late TextEditingController _controller;

  @override
  void initState() {
    setInitialValues();
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setInitialValues() {
    openNew = widget.openNew;
    List<String> stringPaths = widget.urls != null
        ? widget.urls!.split(Constants.breakBetweenPaths)
        : [];
    for (var path in stringPaths) {
      if (path.isNotEmpty) {
        urls.add(SelectedFile(
          path: path,
          onDeleteSelectedFile: onSelectedFileDelete,
          key: UniqueKey(),
        ));
      }
    }
    if (urls.isEmpty && !openNew) {
      //If there is no firefox before create it
      Provider.of<ModifiedContext>(context, listen: false).context.firefox =
          Firefox(OpenNew: 0, URLs: "");
      Provider.of<ModifiedContext>(context, listen: false).context.FirefoxId =
          null;
    }
  }

  void onAddFile(List<String?> list) {
    for (var url in list) {
      urls.add(SelectedFile(
        key: UniqueKey(),
        path: url!,
        onDeleteSelectedFile: onSelectedFileDelete,
      ));
      Provider.of<ModifiedContext>(context, listen: false)
          .context
          .firefox
          ?.urlList
          .add(url);
    }

    setState(() {});
  }

  void onSelectedFileDelete(SelectedFile file) {
    urls.remove(file);
    Provider.of<ModifiedContext>(context, listen: false)
        .context
        .firefox
        ?.urlList
        .remove(file.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              value: openNew,
              onChanged: (bool? value) {
                setState(() {
                  openNew = value!;
                  Provider.of<ModifiedContext>(context, listen: false)
                      .context
                      .firefox
                      ?.OpenNew = openNew == true ? 1 : 0;
                });
              },
            ),
            const Text("Open a new tab"),
          ],
        ),
        ...urls,
        Row(
          children: [
            Expanded(
              flex: 90,
              child: TextField(
                controller: _controller,
              ),
            ),
            Expanded(
                flex: 10,
                child: IconButton(
                    splashRadius: 0.1,
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        onAddFile([_controller.text]);
                        _controller.clear();
                      }
                    },
                    icon: Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ))),
          ],
        )
      ],
    ));
  }
}

//FILE PATHS SELECTED
class SelectedFile extends StatelessWidget {
  const SelectedFile(
      {Key? key, required this.path, required this.onDeleteSelectedFile})
      : super(key: key);
  final String path;
  final Function onDeleteSelectedFile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 90, child: Text(path)),
        Expanded(
            flex: 10,
            child: IconButton(
                splashRadius: 0.1,
                onPressed: () => onDeleteSelectedFile(
                      this,
                    ),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.primaryVariant,
                ))),
      ],
    );
  }
}
