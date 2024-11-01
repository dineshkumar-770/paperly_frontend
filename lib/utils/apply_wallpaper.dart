import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/services.dart';
import 'package:paperly/common/custom_message_dialog.dart';

class ApplyWallpapers {
  static Future<void> applyWallpaperOnLockScreen(String url) async {
    try {
      final isSet = await AsyncWallpaper.setWallpaper(
        url: url,
        wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      );
      isSet
          ? FunckeyMessage.show(isSuccess: true, message: "Applied to Lock Screen Successfully")
          : FunckeyMessage.show(isSuccess: false, message: "Failed to set wallpaper");
    } on PlatformException catch (e) {
      FunckeyMessage.show(isSuccess: false, message: e.message.toString());
    }
  }

  static Future<bool> applyWallpaperOnHomeScreen(String url) async {
    try {
      final isSet = await AsyncWallpaper.setWallpaper(
        url: url,
        goToHome: false,
        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      );
      return isSet;
    } on PlatformException catch (e) {
      FunckeyMessage.show(isSuccess: false, message: e.message.toString());
      return false;
    }
  }

  static Future<void> applyWallpaperOnBothScreen(String url) async {
    try {
      final isSet = await AsyncWallpaper.setWallpaper(
        url: url,
        wallpaperLocation: AsyncWallpaper.BOTH_SCREENS,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      );
      isSet
          ? FunckeyMessage.show(isSuccess: true, message: "Applied to Both Screens Successfully")
          : FunckeyMessage.show(isSuccess: false, message: "Failed to set wallpaper");
    } on PlatformException catch (e) {
      FunckeyMessage.show(isSuccess: false, message: e.message.toString());
    }
  }
}
