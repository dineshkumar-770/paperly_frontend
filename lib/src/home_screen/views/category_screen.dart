import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paperly/common/custom_error_widget.dart';
import 'package:paperly/common/custom_loading_widget.dart';
import 'package:paperly/constants/app_colors.dart';
import 'package:paperly/constants/const_strings.dart';
import 'package:paperly/src/home_screen/controller/home_controller.dart';
import 'package:paperly/src/home_screen/views/category_wise_wallpapers_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(builder: (context, ref01, _) {
        final categoryState = ref01.watch(homecontrollerProvider);
        final providerFun = ref01.read(homecontrollerProvider.notifier);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RefreshIndicator(
            onRefresh: () async {
              providerFun.fetchAllCategories();
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
                          child: const Text(
                            "Collections",
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
                              "Collections",
                              style: TextStyle(
                                fontSize: 40.0,
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
                categoryState.categoriesLoading
                    ? const SliverToBoxAdapter(child: CustomLoadingWidget())
                    : categoryState.allCategoriesData.data == null ||
                            categoryState.allCategoriesData.status?.toLowerCase() == AppStrings.failed ||
                            categoryState.allCategoriesData.data == []
                        ? SliverToBoxAdapter(
                            child: MyErrorWidget(
                            errorMessage: "${categoryState.allCategoriesData.message}",
                          ))
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () async {},
                                    child: Container(
                                      height: MediaQuery.of(context).size.height / 4.5,
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  categoryState.allCategoriesData.data?[index].categoryImage ?? ""),
                                              fit: BoxFit.fill),
                                          color: AppColors.secondaryColor,
                                          borderRadius: BorderRadius.circular(500)),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => CategoryWiseWallpapersScreen(
                                                        category: (categoryState
                                                                    .allCategoriesData.data?[index].categoryName
                                                                    ?.toUpperCase() ??
                                                                "")
                                                            .replaceAll("_", " "),
                                                      ),
                                                    ));
                                                providerFun.fetchCategoryWiseWallpapers(
                                                    categoryName: categoryState
                                                            .allCategoriesData.data?[index].categoryName
                                                            .toString() ??
                                                        "");
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context).size.height / 4.5,
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                    color: AppColors.blackShade,
                                                    borderRadius: BorderRadius.circular(500)),
                                                child: Center(
                                                  child: Text(
                                                    (categoryState.allCategoriesData.data?[index].categoryName
                                                                ?.toUpperCase() ??
                                                            "")
                                                        .replaceAll("_", " "),
                                                    style: TextStyle(
                                                        color: AppColors.appWhite,
                                                        fontSize: 36,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: categoryState.allCategoriesData.data?.length ?? 0,
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
