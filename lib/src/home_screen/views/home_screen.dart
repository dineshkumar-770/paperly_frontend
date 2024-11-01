import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paperly/common/custom_error_widget.dart';
import 'package:paperly/common/custom_loading_widget.dart';
import 'package:paperly/common/preview_wallpaper.dart';
import 'package:paperly/constants/app_colors.dart';
import 'package:paperly/constants/const_strings.dart';
import 'package:paperly/src/home_screen/controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(builder: (context, ref00, _) {
        final allWallState = ref00.watch(homecontrollerProvider);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RefreshIndicator(
            onRefresh: () async {
              ref00.read(homecontrollerProvider.notifier).fetchAllWallpaper();
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 150.0,
                  floating: false,
                  backgroundColor: AppColors.backgroundColor,
                  pinned: true,
                  flexibleSpace: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final double appBarHeight = constraints.biggest.height;
                      final bool isAppBarCollapsed =
                          appBarHeight <= kToolbarHeight + MediaQuery.of(context).padding.top;

                      return FlexibleSpaceBar(
                        title: AnimatedOpacity(
                          duration: const Duration(milliseconds: 75),
                          opacity: isAppBarCollapsed ? 1.0 : 0.0,
                          child: Text(
                            "Paperly",
                            style: TextStyle(fontSize: 24, color: AppColors.textColor),
                          ),
                        ),
                        centerTitle: true,
                        collapseMode: CollapseMode.parallax,
                        background: Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Image(
                                  image: AssetImage("assets/images/app_icon.png"),
                                  height: 60,
                                  width: 60,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Paperly Wallpapers",
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                allWallState.allWallpapersLoading
                    ? const SliverToBoxAdapter(child: CustomLoadingWidget())
                    : allWallState.allWallpapersData.data == null ||
                            allWallState.allWallpapersData.data == [] ||
                            allWallState.allWallpapersData.status?.toLowerCase() == AppStrings.failed
                        ? SliverToBoxAdapter(
                            child: MyErrorWidget(
                            errorMessage: allWallState.allWallpapersData.message ?? "Something went Wrong",
                          ))
                        : SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3 / 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PreviewWallpaperScreen(
                                          heroTag: "Home_$index",
                                          imageUrl: allWallState.allWallpapersData.data?[index].filename ?? "",
                                        ),
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: "Home_$index",
                                    child: Material(
                                      color: AppColors.backgroundColor,
                                      child: Container(
                                        height: 80,
                                        width: MediaQuery.of(context).size.width / 2,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              allWallState.allWallpapersData.data?[index].filename ?? "",
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: allWallState.allWallpapersData.data?.length ?? 0,
                            ),
                          ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
