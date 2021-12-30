import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/helpers/future_builder.dart';
import 'package:frontend/states/state.dart' as state;
import 'package:frontend/actions/reducer.dart' as action;

class RenameSection extends StatefulWidget {
  final state.Section section;
  const RenameSection({Key? key, required this.section}) : super(key: key);

  @override
  State<RenameSection> createState() => _RenameSectionState();
}

class _RenameSectionState extends State<RenameSection> {
  TextEditingController? controller;

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MFutureBuilder<state.SectionData>(
      future: widget.section.data,
      builder: _build,
    );
  }

  Widget _build(BuildContext context, state.SectionData sectionData) {
    const double padding = 25;
    controller ??= TextEditingController.fromValue(
      TextEditingValue(text: sectionData.name),
    );
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
              decoration: const InputDecoration(
                labelText: 'name',
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
                  onPressed: () {
                    StoreProvider.of<Future<state.State>>(context).dispatch(
                      action.EditSection(widget.section, controller!.text),
                    );
                    Navigator.of(context).pop();
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
