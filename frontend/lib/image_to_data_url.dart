import 'dart:convert';
import 'package:image/image.dart';
import 'package:isolated_worker/js_isolated_worker.dart';

// simply interface into the webworker.
Future<String> imageToDataUrl(
    List<int> bytes, String mimeType, int sizeLimit, int imgSizeLimit) async {
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
    },
  );
}
