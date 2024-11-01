import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:paperly/common/custom_message_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageDownloader {
  final Dio dio = Dio();
  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.request().isGranted) {
        final status = await Permission.manageExternalStorage.request();
        if (status.isGranted) {
          return true;
        } else {
          await openAppSettings();
          return false;
        }
      }
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }
    }
    return false;
  }

  Future<String> _getCustomDirectoryPath() async {
    String customPath = "/storage/emulated/0/Download";
    Directory customDir = Directory(customPath);

    if (!customDir.existsSync()) {
      await customDir.create(recursive: true);
    }

    return customDir.path;
  }

  Future<bool> downloadImage(String imageUrl) async {
    if (await _requestPermission()) {
      try {
        String customPath = await _getCustomDirectoryPath();
        String fullPath = "";
        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        if (imageUrl.split('/').last.contains(".jpg") || imageUrl.split('/').last.contains(".jpeg")) {
          fullPath = "$customPath/$fileName.jpg";
        } else if (imageUrl.split('/').last.contains("png")) {
          fullPath = "$customPath/$fileName.png";
        } else {
          fullPath = "$customPath/$fileName.jpg";
        }
        await dio.download(imageUrl, fullPath);

        log("Image downloaded to $fullPath");
        FunckeyMessage.show(isSuccess: true, message: "Image downloaded to $fullPath");
        return true;
      } catch (e) {
        log("Error: $e");
        FunckeyMessage.show(isSuccess: false, message: e.toString());
        return false;
      }
    } else {
      FunckeyMessage.show(isSuccess: false, message: "Permission Denied for Storage!");
      return false;
    }
  }
}
