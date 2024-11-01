import 'package:flutter/material.dart';
import 'package:paperly/constants/const_strings.dart';
import 'package:paperly/utils/shared_prefs.dart';

class AppColors {
  static Color backgroundColor = isDarkMode()
      ? getBackgorundColor()
          ? Colors.black
          : const Color(0xff121212)
      : Colors.white;
  static Color primaryColor = const Color(0xff0D47A1);
  static Color secondaryColor = const Color(0xff64B5F6);
  static Color accentColor = const Color(0xff00BCD4);
  static Color surfaceColor = const Color(0xff424242);
  static Color textColor = isDarkMode() ? const Color(0xffE0E0E0) : Colors.black;
  static Color errorColor = const Color(0xffD32F2F);
  static Color warningColor = const Color(0xffFFC107);
  static Color successColor = const Color(0xff388E3C);
  static Color textColor2 = isDarkMode() ? const Color(0xff616161) : Colors.black;
  static Color blackShade = Colors.black54;
  static Color appWhite = Colors.white;
  static Color blackShade87 = Colors.black87;

  static bool getBackgorundColor() {
    final status = Prefs.getBool(AppStrings.useBlackKey);
    return status;
  }

  static bool isDarkMode() {
    final status = Prefs.getDarkModeBool(AppStrings.isDarkModeKey);
    return status;
  }
}
