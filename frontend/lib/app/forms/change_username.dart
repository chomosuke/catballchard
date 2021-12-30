import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/states/state.dart' as state;
import 'package:frontend/actions/reducer.dart' as action;

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  String? initUsername;
  bool attempted = false;

  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<Future<state.State>>(
      builder: (context, store) => FutureBuilder<String?>(
        future: (() async => (await store.state).username)(),
        builder: _build,
      ),
    );
  }

  Widget _build(BuildContext context, AsyncSnapshot<String?> snapshot) {
    // lazy init
    initUsername ??= snapshot.data;

    final processing = snapshot.connectionState != ConnectionState.done;

    // if initUsername != username, this means successfully changed the username
    if (snapshot.hasData && snapshot.data! != initUsername) {
      Navigator.of(context).pop();
    }

    String? usernameError;
    if (attempted && !processing) {
      usernameError = 'username taken!';
    }

    const double padding = 25;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Container(
        height: 150,
        width: 300,
        margin: const EdgeInsets.only(left: padding, right: padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'new username',
                errorText: usernameError,
              ),
              controller: controller,
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
                  onPressed: processing
                      ? null
                      : () {
                          StoreProvider.of<Future<state.State>>(context)
                              .dispatch(
                            action.AccountPatch(username: controller.text),
                          );
                          setState(() {
                            attempted = true;
                          });
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
