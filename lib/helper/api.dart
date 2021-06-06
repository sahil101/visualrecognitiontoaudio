import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

final objectapiUrl = 'http://[IP]/getobjects';
final textapiUrl = 'http://[IP]/gettext';

class CallApi {
  Future<Map<String, dynamic>> getresults(File image, String text) async {
    Uri uri;
    if (text == "object")
      uri = Uri.parse(objectapiUrl);
    else
      uri = Uri.parse(textapiUrl);
    try {
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
      final imageUploadRequest = http.MultipartRequest('POST', uri);
      final file = await http.MultipartFile.fromPath('image', image.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
      imageUploadRequest.files.add(file);

      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        Future<Map<String, dynamic>> responseData = json.decode(response.body);
        return responseData;
      }
    } catch (e) {
      print(e);
    }
  }
}
