import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/future_builder.dart';
import 'package:frontend/image_to_data_url.dart';
import 'package:provider/provider.dart';
import 'lifecycle.dart' as lifecycle;
import 'package:mime/mime.dart';

class NewName extends StatefulWidget {
  const NewName({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewNameState();
}

class _NewNameContent {
  Future<String> imageUrl;
  String name;
  _NewNameContent(this.imageUrl, this.name);
}

class _NewNameState extends State<NewName> {
  _NewNameContent? _content;

  @override
  Widget build(BuildContext context) {
    void onConfirm() async {
      Provider.of<lifecycle.All>(context, listen: false)
          .add(lifecycle.NewName(await _content!.imageUrl, _content!.name));
      setState(() {
        _content = null;
      });
    }

    void onCancel() {
      setState(() {
        _content = null;
      });
    }

    void onAdd() async {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result == null) {
        // User canceled the picker
        return null;
      }

      List<int> bytes = result.files.single.bytes!;
      String mimeType = lookupMimeType(result.files.single.name)!;
      const imgSizeLimit = 512;
      const sizeLimit = 50000;

      setState(() {
        _content = _NewNameContent(
            imageToDataUrl(bytes, mimeType, sizeLimit, imgSizeLimit), '');
      });
    }

    return Container(
      padding: _content == null ? null : const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: _content == null
          ? IconButton(
              onPressed: onAdd,
              tooltip: 'Add new ComboName',
              icon: const Icon(Icons.add, size: 100),
            )
          : Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: MFutureBuilder<String>(
                        future: _content!.imageUrl,
                        builder: (context, data) => Image.network(data)),
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Combo Name'),
                  onChanged: (value) {
                    _content!.name = value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        onPressed: onCancel, child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: onConfirm, child: const Text('Confirm')),
                  ],
                )
              ],
            ),
    );
  }
}
