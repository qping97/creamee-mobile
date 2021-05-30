import 'package:flutter/material.dart';

Future<bool> loadingDialog(BuildContext context) {
  Widget contentWidget = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      ]);
  return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Container(),
          content: contentWidget,
          actions: <Widget>[
            Container(),
          ],
        ),
      ) ??
      false;
}
