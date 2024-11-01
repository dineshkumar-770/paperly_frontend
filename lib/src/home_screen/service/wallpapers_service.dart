import 'dart:convert';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:paperly/common/custom_message_dialog.dart';
import 'package:paperly/routes/api_routes.dart';
import 'package:paperly/src/home_screen/models/all_categories_model.dart';
import 'package:paperly/src/home_screen/models/all_wallpapers_model.dart';
import 'package:paperly/src/home_screen/models/category_wise_wallpapers_model.dart';

class WallpapersServices {
  Future<Either<AllCategoriesModel, String>> getAllWallpaperCategories() async {
    try {
      String endpoint = ApiRoutes.getAllCategories;
      Uri url = Uri.parse(endpoint);
      Map<String, String> headers = {"Content-Type": "application/json", "Connection": "keep-alive"};
      http.Response apiResponse = await http.get(url, headers: headers);
      AllCategoriesModel allCategoriesModel;

      if (apiResponse.statusCode == 200) {
        log(apiResponse.body.toString());
        final decodedData = jsonDecode(apiResponse.body);
        allCategoriesModel = AllCategoriesModel.fromJson(decodedData);
        return left(allCategoriesModel);
      } else {
        final decodedData = jsonDecode(apiResponse.body);
        allCategoriesModel = AllCategoriesModel.fromJson(decodedData);
        return right(allCategoriesModel.message ?? "Something went wrong!");
      }
    } catch (e) {
      return right(e.toString());
    }
  }

  Future<String> creatWallCategory({required String categoryName, required String filePath}) async {
    try {
      String endpoint = ApiRoutes.addCategory;
      Uri url = Uri.parse(endpoint);
      http.MultipartRequest request = http.MultipartRequest('POST', url);
      request.fields.addAll({'category': categoryName.trim().toLowerCase().replaceAll(" ", "_")});
      request.files.add(
        await http.MultipartFile.fromPath('image', filePath, filename: filePath.split("/").last.toString()),
      );

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final apiResponse = await response.stream.bytesToString();
        log(apiResponse.toString());
        final decodedData = jsonDecode(apiResponse.toString());
        final message = decodedData["message"].toString();
        FunckeyMessage.show(isSuccess: true, message: message);
        return message;
      } else {
        final apiResponse = await response.stream.bytesToString();
        final decodedData = jsonDecode(apiResponse.toString());
        final message = decodedData["message"].toString();
        FunckeyMessage.show(isSuccess: false, message: message);
        return message;
      }
    } catch (e) {
      FunckeyMessage.show(isSuccess: false, message: e.toString());
      return e.toString();
    }
  }

  Future<String> addWallpaperToCategories({required String category, required String filePath}) async {
    try {
      String endpoint = ApiRoutes.addWallpapers;
      Uri url = Uri.parse(endpoint);
      http.MultipartRequest request = http.MultipartRequest('POST', url);
      request.fields.addAll({'category': category});
      request.files.add(
        await http.MultipartFile.fromPath('image', filePath, filename: filePath.split("/").last.toString()),
      );
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final apiResponse = await response.stream.bytesToString();
        log(apiResponse.toString());
        final decodedData = jsonDecode(apiResponse.toString());
        final message = decodedData["message"].toString();
        FunckeyMessage.show(isSuccess: true, message: message);
        return message;
      } else {
        final apiResponse = await response.stream.bytesToString();
        final decodedData = jsonDecode(apiResponse.toString());
        final message = decodedData["message"].toString();
        FunckeyMessage.show(isSuccess: false, message: message);
        return message;
      }
    } catch (e) {
      FunckeyMessage.show(isSuccess: false, message: e.toString());
      return e.toString();
    }
  }

  Future<Either<AllWallpapersModel, String>> getAllAvailableWallpapers() async {
    try {
      String endpoint = ApiRoutes.getAllWallpapers;
      Uri url = Uri.parse(endpoint);
      Map<String, String> headers = {"Content-Type": "application/json", "Connection": "keep-alive"};
      http.Response apiResponse = await http.get(url, headers: headers);
      AllWallpapersModel allWallpapersModel;

      if (apiResponse.statusCode == 200) {
        final decodedData = jsonDecode(apiResponse.body);
        allWallpapersModel = AllWallpapersModel.fromJson(decodedData);
        return left(allWallpapersModel);
      } else {
        final decodedData = jsonDecode(apiResponse.body);
        allWallpapersModel = AllWallpapersModel.fromJson(decodedData);
        return right(allWallpapersModel.message ?? "Something went wrong!");
      }
    } catch (e) {
      return right(e.toString());
    }
  }

  Future<Either<CategoryWiseWallpaperModel, String>> getWallpapersByCategoryName({required String categoryName}) async {
    try {
      String endpoint = ApiRoutes.getAllWallpapersByCategory;
      Uri url = Uri.parse(endpoint);
      Map<String, String> headers = {"Connection": "keep-alive"};
      Map<String, dynamic> formData = {"category": categoryName};
      http.Response apiResponse = await http.post(url, headers: headers, body: formData);
      log(apiResponse.body.toString());
      CategoryWiseWallpaperModel categoryWiseWallpaperModel;

      if (apiResponse.statusCode == 200) {
        final decodedData = jsonDecode(apiResponse.body);
        categoryWiseWallpaperModel = CategoryWiseWallpaperModel.fromJson(decodedData);
        return left(categoryWiseWallpaperModel);
      } else {
        final decodeDate = jsonDecode(apiResponse.body);
        categoryWiseWallpaperModel = CategoryWiseWallpaperModel.fromJson(decodeDate);
        return right(categoryWiseWallpaperModel.message.toString());
      }
    } catch (e) {
      return right(e.toString());
    }
  }
}
