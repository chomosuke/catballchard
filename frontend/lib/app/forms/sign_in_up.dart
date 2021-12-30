import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/actions/account.dart';
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
      builder: (context, store) => FutureBuilder<String?>(
        future: (() async => (await store.state).username)(),
        builder: (context, snapshot) => _build(context, snapshot, store),
      ),
    );
  }

  Widget _build(
    BuildContext context,
    AsyncSnapshot<String?> snapshot,
    Store<Future<state.State>> store,
  ) {
    if (snapshot.hasError) {
      return Text('Opps, something went wrong: ${snapshot.error}');
    }

    String? usernameError;
    String? passwordError;
    String? passwordRepeatError;

    final bool processing = snapshot.connectionState != ConnectionState.done;

    if (!processing) {
      if (snapshot.data != null) {
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
              usernameError = 'username taken!';
            }
          }
        }
      }
    }

    const double padding = 25;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Container(
        width: 300,
        margin: const EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.fromSize(size: const Size(0, 25)),
            TextField(
              decoration: InputDecoration(
                labelText: 'username',
                errorText: usernameError,
              ),
              controller: usernameController,
            ),
            SizedBox.fromSize(size: const Size(0, 25)),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'password',
                errorText: passwordError,
              ),
              controller: passwordController,
            ),
            SizedBox.fromSize(size: const Size(0, 25)),
            if (!signIn)
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'repeat password',
                  errorText: passwordRepeatError,
                ),
                controller: passwordRepeatController,
              ),
            if (!signIn) SizedBox.fromSize(size: const Size(0, 25)),
            SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                              if (password != '' &&
                                  password == passwordRepeat) {
                                store.dispatch(Register(username, password));
                              }
                            }
                          },
                    child: Text(signIn ? 'Sign In' : 'Sign Up'),
                  ),
                  SizedBox.fromSize(size: const Size(0, 25)),
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
            ),
            SizedBox.fromSize(size: const Size(0, 25)),
          ],
        ),
      ),
    );
  }
}
