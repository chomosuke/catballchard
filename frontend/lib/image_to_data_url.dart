import 'dart:convert';
import 'package:image/image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:mime/mime.dart';

Future<String> imageToDataUrl(FilePickerResult result) async {
  List<int> bytes = result.files.single.bytes!;
  String mimeType = lookupMimeType(result.files.single.name)!;
  // 100 kB
  const imgSizeLimit = 1024;
  const sizeLimit = 500000;
  await JsIsolatedWorker().importScripts(['imageToDataUrl.js']);
  return await JsIsolatedWorker().run(
      functionName: 'imageToDataUrl',
      arguments: [bytes, mimeType, sizeLimit, imgSizeLimit],
      fallback: () async {
        if (bytes.length > sizeLimit) {
          Image image = decodeImage(bytes)!;
          if (image.width > image.height) {
            image = copyResize(image, width: imgSizeLimit);
          } else {
            image = copyResize(image, height: imgSizeLimit);
          }
          bytes = encodeJpg(image);
          mimeType = 'image/jpeg';
        }
        return 'data:' + mimeType + ';base64,' + base64UrlEncode(bytes);
      });
}
