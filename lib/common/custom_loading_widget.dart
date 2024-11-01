import 'package:flutter/material.dart';
import 'package:paperly/constants/app_colors.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key,this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color?? AppColors.secondaryColor,
      ),
    );
  }
}
