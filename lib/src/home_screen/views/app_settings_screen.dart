import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paperly/constants/app_colors.dart';
import 'package:paperly/src/home_screen/controller/home_controller.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 150.0,
          floating: false,
          backgroundColor: AppColors.backgroundColor,
          pinned: true,
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double appBarHeight = constraints.biggest.height;
              final bool isAppBarCollapsed = appBarHeight <= kToolbarHeight + MediaQuery.of(context).padding.top;

              return FlexibleSpaceBar(
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 75),
                  opacity: isAppBarCollapsed ? 1.0 : 0.0,
                  child: const Text(
                    "Settings",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                background: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Consumer(builder: (context, ref06, _) {
            final settingState = ref06.watch(homecontrollerProvider);
            final providerFunc = ref06.read(homecontrollerProvider.notifier);
            return Column(
              children: [
                ListTile(
                  title: Text(
                    "Use Amoled Black",
                    style: TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Use amoled black background (Restart Required)",
                    style: TextStyle(color: AppColors.textColor, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  trailing: Theme(
                    data: ThemeData(useMaterial3: true),
                    child: Switch(
                      value: settingState.useBlackBackground,
                      onChanged: (value) {
                        providerFunc.switchBlackBackground(value);
                      },
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Use Dark Mode",
                    style: TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Use Dark Mode (Restart Required)",
                    style: TextStyle(color: AppColors.textColor, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  trailing: Theme(
                    data: ThemeData(useMaterial3: true),
                    child: Switch(
                      value: settingState.isDarkMode,
                      onChanged: (value) {
                        providerFunc.switchDarkLightMode(value);
                      },
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Allow Notification",
                    style: TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Leave this on if you want to be aware of new wallpapers being added.",
                    style: TextStyle(color: AppColors.textColor, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  trailing: Theme(
                    data: ThemeData(useMaterial3: true),
                    child: Switch(
                      value: settingState.notificationSwitch,
                      onChanged: (value) {},
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Wallpapers Saved To",
                    style: TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "/storage/emulated/0/Download",
                    style: TextStyle(color: AppColors.textColor, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                ListTile(
                  title: Text(
                    "App Version",
                    style: TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    settingState.appVerison,
                    style: TextStyle(color: AppColors.textColor, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                ListTile(
                  title: Text(
                    "App Stage",
                    style: TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    settingState.buildNumber,
                    style: TextStyle(color: AppColors.textColor, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Terms of Use",
                    style: TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Privacy Policy",
                    style: TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
