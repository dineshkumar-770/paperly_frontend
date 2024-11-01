// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import 'package:paperly/constants/const_strings.dart';
import 'package:paperly/src/home_screen/models/all_categories_model.dart';
import 'package:paperly/src/home_screen/models/all_wallpapers_model.dart';
import 'package:paperly/src/home_screen/models/category_wise_wallpapers_model.dart';
import 'package:paperly/utils/shared_prefs.dart';

class HomeStates extends Equatable {
  final bool categoriesLoading;
  final AllCategoriesModel allCategoriesData;
  final XFile? pickedImageForCategory;
  final XFile? pickedImageForWallpaper;
  final bool createCategoryLoading;
  final bool allWallpapersLoading;
  final AllWallpapersModel allWallpapersData;
  final String selectedCategoryName;
  final bool addWallpaperLoading;
  final CategoryWiseWallpaperModel categoryWiseWallpaperData;
  final bool categoryWallaperLoading;
  final bool notificationSwitch;
  final bool useBlackBackground;
  final String appVerison;
  final String buildNumber;
  final bool isDarkMode;

  const HomeStates({
    required this.categoriesLoading,
    required this.allCategoriesData,
    this.pickedImageForCategory,
    this.pickedImageForWallpaper,
    required this.createCategoryLoading,
    required this.allWallpapersLoading,
    required this.allWallpapersData,
    required this.selectedCategoryName,
    required this.addWallpaperLoading,
    required this.categoryWiseWallpaperData,
    required this.categoryWallaperLoading,
    required this.notificationSwitch,
    required this.useBlackBackground,
    required this.appVerison,
    required this.buildNumber,
    required this.isDarkMode,
  });

  factory HomeStates.init() {
    final statusBlack = Prefs.getBool(AppStrings.useBlackKey);
    final darkModeStatus = Prefs.getDarkModeBool(AppStrings.isDarkModeKey);
    return HomeStates(
        categoriesLoading: false,
        pickedImageForCategory: null,
        useBlackBackground: statusBlack,
        notificationSwitch: false,
        isDarkMode: darkModeStatus,
        createCategoryLoading: false,
        addWallpaperLoading: false,
        categoryWiseWallpaperData: CategoryWiseWallpaperModel(),
        pickedImageForWallpaper: null,
        categoryWallaperLoading: false,
        allWallpapersLoading: false,
        appVerison: "",
        buildNumber: "",
        selectedCategoryName: "",
        allWallpapersData: AllWallpapersModel(data: [], message: "", status: AppStrings.failed),
        allCategoriesData: AllCategoriesModel(data: [], message: "", status: AppStrings.failed));
  }

  @override
  List<Object> get props {
    return [
      categoriesLoading,
      allCategoriesData,
      pickedImageForCategory!,
      pickedImageForWallpaper!,
      createCategoryLoading,
      allWallpapersLoading,
      allWallpapersData,
      selectedCategoryName,
      addWallpaperLoading,
      categoryWiseWallpaperData,
      categoryWallaperLoading,
      notificationSwitch,
      useBlackBackground,
      appVerison,
      buildNumber,
      isDarkMode,
    ];
  }

  HomeStates copyWith({
    bool? categoriesLoading,
    AllCategoriesModel? allCategoriesData,
    XFile? pickedImageForCategory,
    XFile? pickedImageForWallpaper,
    bool? createCategoryLoading,
    bool? allWallpapersLoading,
    AllWallpapersModel? allWallpapersData,
    String? selectedCategoryName,
    bool? addWallpaperLoading,
    CategoryWiseWallpaperModel? categoryWiseWallpaperData,
    bool? categoryWallaperLoading,
    bool? notificationSwitch,
    bool? useBlackBackground,
    String? appVerison,
    String? buildNumber,
    bool? isDarkMode,
  }) {
    return HomeStates(
      categoriesLoading: categoriesLoading ?? this.categoriesLoading,
      allCategoriesData: allCategoriesData ?? this.allCategoriesData,
      pickedImageForCategory: pickedImageForCategory ?? this.pickedImageForCategory,
      pickedImageForWallpaper: pickedImageForWallpaper ?? this.pickedImageForWallpaper,
      createCategoryLoading: createCategoryLoading ?? this.createCategoryLoading,
      allWallpapersLoading: allWallpapersLoading ?? this.allWallpapersLoading,
      allWallpapersData: allWallpapersData ?? this.allWallpapersData,
      selectedCategoryName: selectedCategoryName ?? this.selectedCategoryName,
      addWallpaperLoading: addWallpaperLoading ?? this.addWallpaperLoading,
      categoryWiseWallpaperData: categoryWiseWallpaperData ?? this.categoryWiseWallpaperData,
      categoryWallaperLoading: categoryWallaperLoading ?? this.categoryWallaperLoading,
      notificationSwitch: notificationSwitch ?? this.notificationSwitch,
      useBlackBackground: useBlackBackground ?? this.useBlackBackground,
      appVerison: appVerison ?? this.appVerison,
      buildNumber: buildNumber ?? this.buildNumber,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
