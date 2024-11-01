// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paperly/common/custom_loading_widget.dart';
import 'package:paperly/common/preview_wallpaper.dart';
import 'package:paperly/constants/app_colors.dart';
import 'package:paperly/src/home_screen/controller/home_controller.dart';

class CategoryWiseWallpapersScreen extends StatelessWidget {
  const CategoryWiseWallpapersScreen({
    super.key,
    required this.category,
  });
  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: AppColors.backgroundColor,
              pinned: false,
              floating: true,
              snap: true,
              centerTitle: false,
              title: Text(
                category,
                style: TextStyle(color: AppColors.textColor, fontSize: 24),
              ),
              forceElevated: innerBoxIsScrolled,
              // bottom: PreferredSize(
              //     preferredSize: const Size.fromHeight(60.0),
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 16),
              //       child: Align(
              //         alignment: Alignment.topLeft,
              //         child: Text(
              //           category,
              //           style: TextStyle(color: AppColors.textColor, fontSize: 45),
              //         ),
              //       ),
              //     )),
            ),
          ];
        },
        body: SafeArea(
          child: Consumer(builder: (context, ref05, _) {
            final catWallpaper = ref05.watch(homecontrollerProvider);
            return catWallpaper.categoryWallaperLoading
                ? const CustomLoadingWidget()
                : Column(
                    children: [
                      Expanded(
                          child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 3 / 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
                        itemCount: catWallpaper.categoryWiseWallpaperData.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PreviewWallpaperScreen(
                                      heroTag: "CatWall$index",
                                      imageUrl: catWallpaper.categoryWiseWallpaperData.data?[index].filename ?? "",
                                    ),
                                  ));
                            },
                            child: Hero(
                              tag: "CatWall$index",
                              child: Container(
                                height: 80,
                                width: MediaQuery.of(context).size.width / 2,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            catWallpaper.categoryWiseWallpaperData.data?[index].filename ?? ""),
                                        fit: BoxFit.fill),
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                // child: Stack(
                                //   alignment: Alignment.center,
                                //   children: [
                                //     Align(
                                //         alignment: Alignment.bottomRight,
                                //         child: IconButton(
                                //             onPressed: () {},
                                //             icon: Icon(
                                //               EvaIcons.heart,
                                //               color: AppColors.successColor,
                                //             )))
                                //   ],
                                // ),
                              ),
                            ),
                          );
                        },
                      ))
                    ],
                  );
          }),
        ),
      ),
    );
  }
}
