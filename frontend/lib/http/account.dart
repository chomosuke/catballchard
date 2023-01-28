import 'dart:convert';
import 'dart:io';
import 'package:frontend/main.dart';

import 'status_code_handling.dart';
import 'url.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:http_status_code/http_status_code.dart';

String hash(String str) => sha512.convert(utf8.encode(str)).toString();

Future<void> saveToken(String authToken) async {
  await storage.write(key: 'auth_token', value: authToken);
}

Future<String> getToken() async => await storage.read(key: 'auth_token') ?? '';

Future<void> deleteToken() => storage.delete(key: 'auth_token');

class AccountPost {
  final String username;
  final String password;
  AccountPost(this.username, this.password);
  toReq() {
    return <String, String>{
      'username': username,
      'password': hash(password),
    };
  }
}

Future<bool> login(AccountPost accountPost) async {
  final response = await http.post(
    apiUrl.resolve('login'),
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    },
    body: jsonEncode(accountPost.toReq()),
  );
  if (response.statusCode == StatusCode.OK) {
    await saveToken(jsonDecode(response.body)['auth_token']);
    return true;
  } else if (response.statusCode == StatusCode.UNAUTHORIZED) {
    return false;
  } else {
    throw StatusCodeError(response.statusCode);
  }
}

Future<void> logout() async {
  await deleteToken();
}

Future<bool> register(AccountPost accountPost) async {
  final response = await http.post(
    apiUrl.resolve('register'),
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    },
    body: jsonEncode(accountPost.toReq()),
  );
  if (response.statusCode == StatusCode.OK) {
    await saveToken(jsonDecode(response.body)['auth_token']);
    return true;
  } else if (response.statusCode == StatusCode.CONFLICT) {
    return false;
  } else {
    throw StatusCodeError(response.statusCode);
  }
}

class AccountPatch {
  final String? username;
  final String? password;
  AccountPatch(this.username, this.password);
  toReq() {
    final req = <String, String>{};
    if (username != null) {
      req['username'] = username!;
    }
    if (password != null) {
      req['password'] = hash(password!);
    }
    return req;
  }
}

Future<bool> patchAccount(AccountPatch accountPatch) async {
  final response = await http.patch(
    apiUrl.resolve('account'),
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await getToken(),
    },
    body: jsonEncode(accountPatch.toReq()),
  );
  if (response.statusCode == StatusCode.OK) {
    return true;
  } else if (response.statusCode == StatusCode.CONFLICT) {
    return false;
  } else {
    throw StatusCodeError(response.statusCode);
  }
}

class Username {
  final String username;
  Username.fromRes(Map<String, dynamic> res) : username = res['username']!;
}

Future<String?> getUsername() async {
  final response = await http.get(
    apiUrl.resolve('username'),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: await getToken(),
    },
  );
  if (response.statusCode == StatusCode.OK) {
    return Username.fromRes(jsonDecode(response.body)).username;
  } else if (response.statusCode == StatusCode.UNAUTHORIZED) {
    return null;
  } else {
    throw StatusCodeError(response.statusCode);
  }
}
