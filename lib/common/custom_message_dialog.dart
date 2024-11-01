import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:paperly/constants/app_colors.dart';
import 'package:paperly/main.dart';

class FunckeyMessage {
  static show({required bool isSuccess, required String message}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        margin: const EdgeInsets.all(16),
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.easeInOut,
        backgroundColor: isSuccess ? AppColors.textColor : AppColors.errorColor,
        isDismissible: false,
        borderRadius: BorderRadius.circular(100),
        duration: const Duration(seconds: 3),
        messageSize: 30,
        messageText: Text(
          message,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            color: isSuccess ? AppColors.backgroundColor : AppColors.textColor,
          ),
        ),
      ).show(context);
    } else {
      log("Context is null!");
    }
  }
}
