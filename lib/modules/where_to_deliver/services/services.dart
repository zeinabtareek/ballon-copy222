import 'dart:io';

import 'package:dio/dio.dart';

class Service {
  final dio = Dio();

  Future<String> uploadImage(File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    final response = await dio.post("/info", data: formData);
    return response.data['id'];
  }
}
