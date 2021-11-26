import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:mime/mime.dart';

Future<String> imageToDataUrl(FilePickerResult result) async {
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
  return 'data:' + mimeType + ';base64,' + base64UrlEncode(bytes);
}
