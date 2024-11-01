import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paperly/common/custom_message_dialog.dart';
import 'package:paperly/constants/const_strings.dart';
import 'package:paperly/src/home_screen/controller/home_states.dart';
import 'package:paperly/src/home_screen/models/all_categories_model.dart';
import 'package:paperly/src/home_screen/service/wallpapers_service.dart';
import 'package:paperly/utils/shared_prefs.dart';
import 'package:permission_handler/permission_handler.dart';

final homecontrollerProvider = StateNotifierProvider<HomeControllerNotifier, HomeStates>((ref) {
  return HomeControllerNotifier();
});

class HomeControllerNotifier extends StateNotifier<HomeStates> {
  HomeControllerNotifier() : super(HomeStates.init()) {
    getAppInfo();
    fetchAllCategories();
    fetchAllWallpaper();
    getNotificationStatus();
  }

  final WallpapersServices _wallpapersServices = WallpapersServices();
  final ImagePicker _imagePicker = ImagePicker();
  final int _maxFileSizeInBytes = 768000;

  Future<void> fetchAllCategories() async {
    state = state.copyWith(categoriesLoading: true);
    final response = await _wallpapersServices.getAllWallpaperCategories();
    response.fold(
      (data) {
        state = state.copyWith(allCategoriesData: data);
      },
      (error) {
        state = state.copyWith(allCategoriesData: AllCategoriesModel(message: error, status: AppStrings.failed));
        FunckeyMessage.show(isSuccess: true, message: error);
      },
    );
    state = state.copyWith(categoriesLoading: false);
  }

  Future<void> pickImageCategory() async {
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imagePath = await pickedImage.readAsBytes();
      final fileSize = imagePath.length;
      if (fileSize < _maxFileSizeInBytes) {
        state = state.copyWith(pickedImageForCategory: pickedImage);
      } else {
        log("File Size cannot be more than 750kb");
      }
    }
  }

  Future<void> pickImageWallpaper() async {
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imagePath = await pickedImage.readAsBytes();
      final fileSize = imagePath.length;
      if (fileSize < _maxFileSizeInBytes) {
        state = state.copyWith(pickedImageForWallpaper: pickedImage);
      } else {
        log("File Size cannot be more than 750kb");
      }
    }
  }

  Future<void> createWallpaperCategory({required String categoryName, required String filePath}) async {
    state = state.copyWith(createCategoryLoading: true);
    await _wallpapersServices.creatWallCategory(categoryName: categoryName, filePath: filePath);
    state = state.copyWith(createCategoryLoading: false);
  }

  Future<void> postWallpapertoTheirCategories({required String category, required String filePath}) async {
    state = state.copyWith(addWallpaperLoading: true);
    final response = await _wallpapersServices.addWallpaperToCategories(category: category, filePath: filePath);
    state = state.copyWith(addWallpaperLoading: false);
    log(response);
  }

  void selectWallpaperCategory({required String categoryName}) {
    state = state.copyWith(selectedCategoryName: categoryName);
  }

  void resetAddWallpaperScreen() async {
    state = state.copyWith(pickedImageForWallpaper: null);
  }

  Future<void> fetchAllWallpaper() async {
    state = state.copyWith(allWallpapersLoading: true);
    final response = await _wallpapersServices.getAllAvailableWallpapers();
    response.fold(
      (data) {
        state = state.copyWith(allWallpapersLoading: false, allWallpapersData: data);
      },
      (error) {
        state = state.copyWith(
          allWallpapersLoading: false,
        );
        FunckeyMessage.show(isSuccess: false, message: error);
      },
    );
  }

  Future<void> getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    state = state.copyWith(appVerison: packageInfo.version, buildNumber: packageInfo.buildNumber);
  }

  Future<void> fetchCategoryWiseWallpapers({required String categoryName}) async {
    state = state.copyWith(categoryWallaperLoading: true);
    final response = await _wallpapersServices.getWallpapersByCategoryName(categoryName: categoryName);
    response.fold(
      (data) {
        state = state.copyWith(categoryWallaperLoading: false, categoryWiseWallpaperData: data);
      },
      (r) {
        state = state.copyWith(categoryWallaperLoading: false);
        FunckeyMessage.show(isSuccess: false, message: r);
      },
    );
  }

  Future<bool> askNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Future<void> getNotificationStatus() async {
    final status = await askNotificationPermission();
    state = state.copyWith(notificationSwitch: status);
  }

  Future<void> switchBlackBackground(bool useBlack) async {
    await Prefs.setBool(AppStrings.useBlackKey, useBlack);
    final status = Prefs.getBool(AppStrings.useBlackKey);
    state = state.copyWith(useBlackBackground: status);
  }

  Future<void> switchDarkLightMode(bool useDarkMode) async {
    await Prefs.setBool(AppStrings.isDarkModeKey, useDarkMode);
    final status = Prefs.getDarkModeBool(AppStrings.isDarkModeKey);
    state = state.copyWith(isDarkMode: status);
  }
}
