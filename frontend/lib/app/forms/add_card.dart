import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/helpers/future_builder.dart';
import 'package:frontend/helpers/pick_image.dart';
import 'package:frontend/states/state.dart' as state;
import 'package:frontend/actions/reducer.dart' as action;

class AddCard extends StatefulWidget {
  final state.Section section;
  const AddCard({Key? key, required this.section}) : super(key: key);

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  Future<String>? imageUrl;
  String description = '';

  @override
  Widget build(BuildContext context) {
    const double padding = 25;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Container(
        height: 600,
        width: 500,
        margin: const EdgeInsets.all(padding),
        child: Column(
          children: [
            Expanded(
              child: imageUrl == null
                  ? IconButton(
                      onPressed: () async {
                        final img = await pickImage();
                        if (img != null) {
                          setState(() {
                            imageUrl = img;
                          });
                        }
                      },
                      tooltip: 'Add Image',
                      iconSize: 100,
                      icon: const Icon(Icons.add),
                    )
                  : Container(
                      alignment: Alignment.topCenter,
                      child: MFutureBuilder<String>(
                        future: imageUrl!,
                        builder: (context, data) => Image.network(
                          data,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'description'),
              onChanged: (value) {
                description = value;
              },
            ),
            SizedBox.fromSize(size: const Size(0, 25)),
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
                  onPressed: imageUrl == null
                      ? null
                      : () async {
                          StoreProvider.of<Future<state.State>>(context)
                              .dispatch(
                            action.AddCard(
                              await imageUrl!,
                              description,
                              widget.section,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                  child: const Text('Confirm'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
