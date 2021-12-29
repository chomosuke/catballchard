import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/helpers/future_builder.dart';
import 'package:frontend/helpers/image_to_data_url.dart';
import 'package:frontend/states/state.dart' as state;
import 'package:frontend/actions/reducer.dart' as action;
import 'package:mime/mime.dart';

class AddCard extends StatefulWidget {
  state.Section section;
  AddCard({Key? key, required this.section}) : super(key: key);

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  Future<String>? imageUrl;
  String description = '';
  void onAdd() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result == null) {
      // User canceled the picker
      return null;
    }

    List<int> bytes = result.files.single.bytes!;
    String mimeType = lookupMimeType(result.files.single.name)!;
    const sizeLimit = 262144;

    setState(() {
      imageUrl = imageToDataUrl(bytes, mimeType, sizeLimit);
    });
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 25;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Container(
        width: 300,
        margin: const EdgeInsets.all(padding),
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: imageUrl == null
                    ? IconButton(
                        onPressed: onAdd,
                        tooltip: 'Add Image',
                        iconSize: 100,
                        icon: const Icon(Icons.add),
                      )
                    : MFutureBuilder<String>(
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
