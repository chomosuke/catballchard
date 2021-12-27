import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:http_status_code/http_status_code.dart';

class StatusCodeException implements Exception {
  final int statusCode;
  StatusCodeException(this.statusCode);
}

class StatusCodeError extends Error {
  final int statusCode;
  StatusCodeError(this.statusCode);
}

Future<void> statusCodeAlert(int statusCode, String? title, String? content) {
  return showDialog(
    context: getContext()!,
    builder: (context) => AlertDialog(
      title: Text(title ?? 'Oops! Something went wrong!'),
      content: Text(content ?? '$statusCode! ${getStatusMessage(statusCode)}}'),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
