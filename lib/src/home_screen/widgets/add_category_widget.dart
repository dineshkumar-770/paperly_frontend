import 'dart:developer';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paperly/common/custom_loading_widget.dart';
import 'package:paperly/constants/app_colors.dart';
import 'package:paperly/src/home_screen/controller/home_controller.dart';

class AddCategoryWidget extends StatelessWidget {
  const AddCategoryWidget({super.key, required this.categoryNameController});
  final TextEditingController categoryNameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer(builder: (context, ref02, _) {
        final pickerState = ref02.watch(homecontrollerProvider);
        final providerFun = ref02.watch(homecontrollerProvider.notifier);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Category",
              style: TextStyle(color: AppColors.textColor, fontSize: 24),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  image: pickerState.pickedImageForCategory != null
                      ? DecorationImage(
                          image: FileImage(File(pickerState.pickedImageForCategory!.path)), fit: BoxFit.fill)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentColor, width: 1)),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    await providerFun.pickImageCategory();
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
              height: 20,
            ),
            TextFormField(
              style: TextStyle(
                color: AppColors.textColor, // Text color in dark theme
              ),
              controller: categoryNameController,
              cursorColor: AppColors.accentColor, // Cursor color
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.backgroundColor, // Dark fill color for the field
                hintText: 'Enter your Category Name',
                hintStyle: TextStyle(color: AppColors.textColor), // Hint color
                labelText: 'Category Name',
                labelStyle: TextStyle(color: AppColors.accentColor), // Label color
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
            ),
            const Spacer(),
            SizedBox(
              height: 45,
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: () {
                    if (pickerState.pickedImageForCategory != null) {
                      providerFun.createWallpaperCategory(
                          categoryName: categoryNameController.text,
                          filePath: pickerState.pickedImageForCategory!.path);
                    } else {
                      log("Select the file upload first!");
                    }
                  },
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.successColor)),
                  child: pickerState.createCategoryLoading
                      ? CustomLoadingWidget(
                          color: AppColors.textColor,
                        )
                      : const Text(
                          "Add Category",
                          style: TextStyle(),
                        )),
            )
          ],
        );
      }),
    );
  }
}
