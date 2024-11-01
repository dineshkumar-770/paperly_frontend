import 'package:flutter/material.dart';
import 'package:paperly/src/home_screen/widgets/add_category_widget.dart';
import 'package:paperly/src/home_screen/widgets/add_wallpapers.dart';

class AddContentScreen extends StatefulWidget {
  const AddContentScreen({super.key});

  @override
  State<AddContentScreen> createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> with TickerProviderStateMixin {
  TextEditingController categoryNameController = TextEditingController();
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          TabBar(controller: tabController, tabs: const [
            Tab(
              text: "Add Category",
            ),
            Tab(
              text: "Add Wallpaper",
            ),
          ]),
          Expanded(
            child: TabBarView(physics: const NeverScrollableScrollPhysics(), controller: tabController, children: [
              AddCategoryWidget(
                categoryNameController: categoryNameController,
              ),
              const AddWallpapersWidget()
            ]),
          )
        ],
      ),
    );
  }
}
