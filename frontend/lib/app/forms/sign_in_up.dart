import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/actions/account.dart';
import 'package:frontend/helpers/as_non_null.dart';
import 'package:frontend/states/state.dart' as state;
import 'package:redux/redux.dart';

class SignInUp extends StatefulWidget {
  const SignInUp({Key? key}) : super(key: key);

  @override
  State<SignInUp> createState() => _SignInUpState();
}

class _SignInUpState extends State<SignInUp> {
  bool signIn = true;
  final usernameController = TextEditingController();
  String get username => usernameController.text;
  final passwordController = TextEditingController();
  String get password => passwordController.text;
  final passwordRepeatController = TextEditingController();
  String get passwordRepeat => passwordRepeatController.text;
  bool attempted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<Future<state.State>>(
      builder: _build,
    );
  }

  Widget _build(BuildContext context, Store<Future<state.State>> store) {
    Widget build(
      BuildContext context,
      AsyncSnapshot<AsNonNull<String>> snapshot,
    ) {
      if (snapshot.hasError) {
        return Text('Opps, something went wrong: ${snapshot.error}');
      }

      String? usernameError;
      String? passwordError;
      String? passwordRepeatError;

      final bool processing = !snapshot.hasData;

      if (!processing) {
        if (snapshot.data!.nullable != null) {
          // logged in already, pop the dialog
          Navigator.of(context).pop();
        } else {
          if (attempted) {
            // show some error
            if (signIn) {
              // password or username incorrect
              passwordError = 'password or username incorrect!';
            } else {
              // could be password
              if (password == '') {
                passwordError = 'password can\'t be empty';
              } else if (password != passwordRepeat) {
                passwordRepeatError = 'does not match!';
              } else {
                // then must be username conflict
                usernameError = 'username already in use';
              }
            }
          }
        }
      }

      return Dialog(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'username',
                errorText: usernameError,
              ),
              controller: usernameController,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'password',
                errorText: passwordError,
              ),
              controller: passwordController,
            ),
            if (!signIn)
              TextField(
                decoration: InputDecoration(
                  labelText: 'repeat password',
                  errorText: passwordRepeatError,
                ),
                controller: passwordRepeatController,
              ),
            ElevatedButton(
              onPressed: processing
                  ? null
                  : () {
                      setState(() {
                        attempted = true;
                      });
                      if (signIn) {
                        store.dispatch(Login(username, password));
                      } else {
                        if (password != '' && password == passwordRepeat) {
                          store.dispatch(Register(username, password));
                        }
                      }
                    },
              child: Text(signIn ? 'Sign In' : 'Sign Up'),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  signIn = !signIn;
                  attempted = false;
                });
                usernameController.clear();
                passwordController.clear();
                passwordRepeatController.clear();
              },
              child: Text(signIn ? 'Sign Up instead' : 'Sign In instead'),
            )
          ],
        ),
      );
    }

    return FutureBuilder<AsNonNull<String>>(
      future:
          (() async => AsNonNull<String>(await (await store.state).username))(),
      builder: build,
    );
  }
}
