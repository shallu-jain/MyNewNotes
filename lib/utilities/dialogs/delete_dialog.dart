import 'package:flutter/material.dart';
import 'package:my_notes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to Delete?',
    optionsBuilder: () => {
      'Cancel':false,
      'Yes':true,
    },
  ).then((value) => value ?? false);
}
