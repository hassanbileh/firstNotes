import 'package:flutter/material.dart';
import 'package:registration/utilities/dialogs/generic_dialog.dart';

//! Error message for login/register page
Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'An error has occured',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
