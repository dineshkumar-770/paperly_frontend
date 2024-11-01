import 'dart:developer';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paperly/common/custom_loading_widget.dart';
import 'package:paperly/constants/app_colors.dart';
import 'package:paperly/src/home_screen/controller/home_controller.dart';

class AddWallpapersWidget extends StatelessWidget {
  const AddWallpapersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer(builder: (context, ref04, _) {
        final pickerState = ref04.watch(homecontrollerProvider);
        final providerFun = ref04.watch(homecontrollerProvider.notifier);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            pickerState.categoriesLoading
                ? DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.backgroundColor, // Dark fill color for the field
                      hintText: 'Getting Categories...',
                      hintStyle: TextStyle(color: AppColors.textColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppColors.accentColor, // Border color when not focused
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppColors.accentColor, // Border color when focused
                          width: 2.0,
                        ),
                      ),
                    ),
                    items: null,
                    onChanged: null,
                  )
                : pickerState.allCategoriesData.data != null &&
                        (pickerState.allCategoriesData.data?.isNotEmpty ?? false)
                    ? DropdownButtonFormField<String>(
                        style: TextStyle(color: AppColors.textColor),
                        dropdownColor: AppColors.backgroundColor,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundColor, // Dark fill color for the field
                          hintText: 'Select Category',
                          hintStyle: TextStyle(color: AppColors.textColor),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColors.accentColor, // Border color when not focused
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColors.accentColor, // Border color when focused
                              width: 2.0,
                            ),
                          ),
                        ),
                        // value: null,
                        items: (pickerState.allCategoriesData.data ?? []).map(
                          (category) {
                            return DropdownMenuItem<String>(
                              value: category.categoryName ?? "",
                              child: Text(
                                category.categoryName?.replaceAll("_", " ") ?? "",
                                style: TextStyle(color: AppColors.textColor),
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          providerFun.selectWallpaperCategory(categoryName: value.toString());
                        },
                      )
                    : DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundColor, // Dark fill color for the field
                          hintText: 'No Categories available at this time',
                          hintStyle: TextStyle(color: AppColors.textColor),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColors.accentColor, // Border color when not focused
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColors.accentColor, // Border color when focused
                              width: 2.0,
                            ),
                          ),
                        ),
                        items: null,
                        onChanged: null,
                      ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  image: pickerState.pickedImageForWallpaper != null
                      ? DecorationImage(
                          image: FileImage(File(pickerState.pickedImageForWallpaper!.path)), fit: BoxFit.fill)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentColor, width: 1)),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    await providerFun.pickImageWallpaper();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        EvaIcons.fileAdd,
                        color: AppColors.secondaryColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Upload Image",
                        style: TextStyle(color: AppColors.textColor, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Spacer(),
            SizedBox(
              height: 45,
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: () async {
                    await providerFun.postWallpapertoTheirCategories(
                      category: pickerState.selectedCategoryName,
                      filePath: pickerState.pickedImageForWallpaper!.path,
                    );
                    providerFun.resetAddWallpaperScreen();
                  },
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.successColor)),
                  child: pickerState.addWallpaperLoading
                      ? CustomLoadingWidget(
                          color: AppColors.textColor,
                        )
                      : const Text(
                          "Add Wallpaper",
                          style: TextStyle(),
                        )),
            ),
            ElevatedButton(
                onPressed: () async {
                  final token = await FirebaseMessaging.instance.getToken();
                  log(token.toString());
                },
                child: const Text("Generate"))
          ],
        );
      }),
    );
  }
}
