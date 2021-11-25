import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'lifecycle.dart' as lifecycle;

class NewName extends StatefulWidget {
  const NewName({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewNameState();
}

class _NewNameContent {
  String imageUrl;
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
      if (bytes.length > 100000) {
        // 100 kB
        img.Image image = img.decodeImage(bytes)!;
        const sizeLimit = 500;
        if (image.width > image.height) {
          image = img.copyResize(image, width: sizeLimit);
        } else {
          image = img.copyResize(image, height: sizeLimit);
        }
        bytes = img.encodeJpg(image);
        mimeType = 'image/jpeg';
      }
      String imageUrl =
          'data:' + mimeType + ';base64,' + base64UrlEncode(bytes);
      setState(() {
        _content = _NewNameContent(imageUrl, '');
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
                      child: Image.network(_content!.imageUrl)),
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
