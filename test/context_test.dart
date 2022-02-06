import 'package:context_switcher/DatabaseModels/Context.dart';
import 'package:context_switcher/DatabaseModels/Word.dart';
import 'package:context_switcher/Singletons/current_user.dart';
import 'package:context_switcher/ViewModels/context_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

const testContextName = "testName";
const testPath = "C:\\test";

void main() async {
  test('context should be added', () async {
    final contextViewModel = ContextViewModel();
    CurrentUser.instance.userId = 1;
    CurrentUser.instance.userName = "admin";

    final context2add = Context(
        newlyCreated: true,
        ContextId: 0,
        ContextName: testContextName,
        Hotkey: "F1",
        FirefoxId: null,
        ExcelId: null,
        WinExpId: null,
        NppId: null,
        WordId: null);
    await contextViewModel.updateContext(context2add);
    await contextViewModel.getContextsOfCurrentUser();

    expect(
        contextViewModel.currentUsersContexts
            .where((element) => element.ContextName == testContextName)
            .isNotEmpty,
        true);
  });

  test("context should be updated", () async {
    final contextViewModel = ContextViewModel();
    CurrentUser.instance.userId = 1;
    CurrentUser.instance.userName = "admin";
    await contextViewModel.getContextsOfCurrentUser();
    var context2update = contextViewModel.currentUsersContexts
        .where((element) => element.ContextName == testContextName)
        .first;
    context2update.word = Word(OpenNew: 1, Paths: "");
    context2update.word?.pathlist = [testPath];
    await contextViewModel.updateContext(context2update);
    await contextViewModel.getContextsOfCurrentUser();
    expect(
        contextViewModel.currentUsersContexts
                .where((element) => element.ContextName == testContextName)
                .first
                .word !=
            null,
        true);
  });

  test("context should be deleted", () async {
    final contextViewModel = ContextViewModel();
    CurrentUser.instance.userId = 1;
    CurrentUser.instance.userName = "admin";
    await contextViewModel.getContextsOfCurrentUser();
    var context2delete = contextViewModel.currentUsersContexts
        .where((element) => element.ContextName == testContextName)
        .first;
    await contextViewModel.deleteContext(context2delete);
    await contextViewModel.getContextsOfCurrentUser();
    expect(
        contextViewModel.currentUsersContexts
            .where((element) => element.ContextName == testContextName)
            .isEmpty,
        true);
  });
}
