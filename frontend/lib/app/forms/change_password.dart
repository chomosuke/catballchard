import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/states/state.dart' as state;
import 'package:frontend/actions/reducer.dart' as action;

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool attempted = false;
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    passwordRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? passwordError;
    String? passwordRepeatError;
    if (attempted) {
      // means it has failed
      // display error
      if (passwordController.text == '') {
        passwordError = 'password can not be empty!';
      } else if (passwordRepeatController.text != passwordController.text) {
        passwordRepeatError = 'passwords does not match!';
      }
    }

    const double padding = 25;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Container(
        height: 225,
        width: 300,
        margin: const EdgeInsets.only(left: padding, right: padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'new password',
                errorText: passwordError,
              ),
              controller: passwordController,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'repeat password',
                errorText: passwordRepeatError,
              ),
              controller: passwordRepeatController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      attempted = true;
                    });
                    if (passwordController.text != '' &&
                        passwordController.text ==
                            passwordRepeatController.text) {
                      StoreProvider.of<Future<state.State>>(context).dispatch(
                          action.AccountPatch(
                              password: passwordController.text));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
