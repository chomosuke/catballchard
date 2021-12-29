import 'dart:convert';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:mime/mime.dart';

// simply interface into the webworker.
Future<String> imageToDataUrl(
    List<int> bytes, String mimeType, int sizeLimit) async {
  await JsIsolatedWorker().importScripts(['imageToDataUrl.js']);
  return await JsIsolatedWorker().run(
    functionName: 'imageToDataUrl',
    arguments: [bytes, mimeType, sizeLimit],
    fallback: () async {
      if (bytes.length > sizeLimit) {
        Image image = decodeImage(bytes)!;
        int len = bytes.length;
        if (mimeType != 'image/jpeg') {
          // check jpeg size
          len = encodeJpg(image).length;
        }
        if (len > sizeLimit) {
          // now resize
          image = copyResize(image,
              width: image.width * sqrt(sizeLimit / len) * 0.6 as int);
        }
        bytes = encodeJpg(image, quality: 80);
        return 'data:image/jpeg;base64,' + base64UrlEncode(bytes);
      }
      return 'data:' + mimeType + ';base64,' + base64UrlEncode(bytes);
    },
  );
}

Future<Future<String>?> pickImage() async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.image);

  if (result == null) {
    // User canceled the picker
    return null;
  }

  List<int> bytes = result.files.single.bytes!;
  String mimeType = lookupMimeType(result.files.single.name)!;
  const sizeLimit = 262144;

  // return automatically await, we wrap another future to get around this
  return Future.value(imageToDataUrl(bytes, mimeType, sizeLimit));
}
