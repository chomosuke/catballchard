import 'package:flutter/material.dart';

class WarningDialog extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback callback;
  const WarningDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      title: Text(title),
      content: Text(description),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Confirm',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            callback();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
