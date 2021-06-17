import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Dialogs {
  static info(BuildContext context, {String title, String content}) {
    showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  static alert(
    BuildContext context,
    String title,
    String content,
    String cancelActionText,
    String defaultActionText,
  ) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            child: Text(defaultActionText),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  static validateData(
    BuildContext context,
    String title,
    String content,
    String cancelActionText,
    String defaultActionText,
  ) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            child: Text(defaultActionText),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}

class ProgressDialog {
  final BuildContext context;

  ProgressDialog(this.context);

  void show() {
    showCupertinoDialog(
      context: this.context,
      builder: (_) => Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void dismiss() {
    Navigator.pop(context);
  }
}
