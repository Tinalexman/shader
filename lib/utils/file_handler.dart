import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class FileHandler
{

  // static Future<void> saveAuthDetails(Map<String, String>? auth) async
  // {
  //   SharedPreferences instance = await SharedPreferences.getInstance();
  //   await instance.setString("user_kde_email", auth == null ? "" : auth["email"]!);
  //   await instance.setString("user_kde_password", auth == null ? "" : auth["password"]!);
  // }
  //
  // static Future<Map<String, String>?> loadAuthDetails() async
  // {
  //   SharedPreferences instance = await SharedPreferences.getInstance();
  //   String? email = instance.getString("user_kde_email");
  //   String? password = instance.getString("user_kde_password");
  //
  //   if(email == null || password == null || email.isEmpty || password.isEmpty) return null;
  //   return {
  //     "email" : email,
  //     "password" : password
  //   };
  // }

  static Future<List<Uint8List>> loadFilesAsBytes(List<String> extensions, {bool many = true}) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: extensions, type: FileType.custom, allowMultiple: many);
    if (result != null)
    {
      List<Uint8List> data = [];
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for(var file in files) {
        data.add(file.readAsBytesSync());
      }
      return data;
    }
    return [];
  }

  static Future<String?> pickFile(String extension) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: [extension], type: FileType.custom, allowMultiple: false);
    if (result != null)
    {
      return result.files.single.path;
    }
    return null;
  }

  static Future<List<String?>> pickFiles(List<String> extensions) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: extensions, type: FileType.custom, allowMultiple: true);
    if (result != null)
    {
      return result.paths;
    }
    return [];
  }

  static List<Uint8List> convertToData(List<String?> data)
  {
    List<Uint8List> response = [];
    for(var path in data)
    {
      File f = File(path!);
      response.add(f.readAsBytesSync());
    }
    return response;
  }

  static String convertTo64(Uint8List data) => base64.encode(data);


}




