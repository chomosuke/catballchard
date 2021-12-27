import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/states/state.dart' as state;
import 'package:frontend/actions/reducer.dart' as action;

class AddSection extends StatelessWidget {
  const AddSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Dialog(
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'name',
            ),
            controller: controller,
          ),
          ElevatedButton(
            onPressed: () {
              StoreProvider.of<Future<state.State>>(context).dispatch(
                action.AddSection(controller.text),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Add Section'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
