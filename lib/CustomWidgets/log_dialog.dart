import 'package:context_switcher/ViewModels/context_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LogDialog();
  }
}

class _LogDialog extends State<LogDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        alignment: Alignment.center,
        child: Container(
            width: 700,
            height: 600,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Logs"),
              ),
              extendBody: true,
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              body: Consumer<ContextViewModel>(
                  builder: (context, viewModel, child) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var log in viewModel.logs)
                          Text(
                            "${log.TimeStamp}: User ${log.userName} opened context ${log.contextName}.",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          )
                      ],
                    ),
                  ),
                );
              }),
            )));
  }
}
