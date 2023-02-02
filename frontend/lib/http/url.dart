import 'package:flutter/foundation.dart';

final Uri baseUrl =
    kReleaseMode ? Uri.base.resolve('../') : Uri.parse('http://localhost:8000/');
final Uri apiUrl = baseUrl.resolve('api/');
