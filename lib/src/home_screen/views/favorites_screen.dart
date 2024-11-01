import 'package:flutter/material.dart';
import 'package:paperly/constants/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
                final bool isAppBarCollapsed = appBarHeight <= kToolbarHeight + MediaQuery.of(context).padding.top;

                return FlexibleSpaceBar(
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 75),
                    opacity: isAppBarCollapsed ? 1.0 : 0.0,
                    child: const Text(
                      "Favorites",
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
                        "Favorites",
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
              child: Text(
            "*Favorites images will be stored for maximum 7 days.",
            style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
          )),
          SliverToBoxAdapter(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Icon(
                Icons.heart_broken,
                size: 75,
                color: AppColors.textColor,
              ),
              Text(
                "No Favorites",
                style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w400),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
