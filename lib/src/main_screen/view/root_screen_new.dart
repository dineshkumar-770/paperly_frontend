import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paperly/constants/app_colors.dart';
import 'package:paperly/src/home_screen/views/add_content_screen.dart';
import 'package:paperly/src/home_screen/views/app_settings_screen.dart';
import 'package:paperly/src/home_screen/views/category_screen.dart';
import 'package:paperly/src/home_screen/views/favorites_screen.dart';
import 'package:paperly/src/home_screen/views/home_screen.dart';
import 'package:paperly/utils/custom_bottom_nav_bar.dart';

class RootScreenNew extends StatefulWidget {
  const RootScreenNew({super.key});

  @override
  State<RootScreenNew> createState() => _RootScreenNewState();
}

class _RootScreenNewState extends State<RootScreenNew> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<IconData> icons = const [
    EvaIcons.grid,
    EvaIcons.colorPicker,
    EvaIcons.heart,
    EvaIcons.settings2,
    EvaIcons.image,
  ];

  final List<String> names = const [
    "Home",
    "Collections",
    "Favorites",
    "Settings",
    "Add Content",
  ];

  @override
  void initState() {
    _tabController = TabController(length: icons.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundColor,
      body: TabBarView(
        controller: _tabController,
        children: const [
          HomeScreen(),
          CategoryScreen(),
          // DeviceInfoHelper(),
          FavoritesScreen(),
          AppSettingsScreen(),
          AddContentScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        tabController: _tabController,
        icons: icons,
        names: names,
      ),
    );
  }
}
