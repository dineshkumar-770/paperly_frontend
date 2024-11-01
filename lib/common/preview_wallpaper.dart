// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paperly/common/custom_loading_widget.dart';
import 'package:paperly/common/custom_message_dialog.dart';
import 'package:paperly/constants/app_colors.dart';
import 'package:paperly/src/main_screen/view/root_screen_new.dart';
import 'package:paperly/utils/apply_wallpaper.dart';
import 'package:paperly/utils/helpers.dart';
import 'package:paperly/utils/image_downloader.dart';

class PreviewWallpaperScreen extends StatefulWidget {
  const PreviewWallpaperScreen({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });
  final String imageUrl;
  final String heroTag;

  @override
  State<PreviewWallpaperScreen> createState() => _PreviewWallpaperScreenState();
}

class _PreviewWallpaperScreenState extends State<PreviewWallpaperScreen> {
  bool _isContainerVisible = true; // Track visibility of the container
  final HelperFunctions _helperFunctions = HelperFunctions();
  ImageDownloader imageDownloader = ImageDownloader();
  bool downloadImageLoading = false;
  ApplyWallpaperTypes? selectedApplyType = ApplyWallpaperTypes.homeScreen;

  void _toggleContainerVisibility() {
    setState(() {
      _isContainerVisible = !_isContainerVisible; // Toggle visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: _toggleContainerVisibility, // Toggle visibility on image tap
            child: Align(
              alignment: Alignment.center,
              child: Hero(
                tag: widget.heroTag,
                transitionOnUserGestures: true,
                child: Image.network(
                  widget.imageUrl,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500), // Animation duration
                opacity: _isContainerVisible ? 1.0 : 0.0, // Show/Hide with opacity
                child: _isContainerVisible // Only render if visible
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          color: AppColors.blackShade87,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final listOfImageColors =
                                              await _helperFunctions.getImagePalette(NetworkImage(widget.imageUrl));
                                          if (context.mounted) {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) => BottomSheet(
                                                enableDrag: true,
                                                showDragHandle: true,
                                                onClosing: () {},
                                                builder: (context) {
                                                  return Container(
                                                    decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(16),
                                                            topRight: Radius.circular(16))),
                                                    height: MediaQuery.of(context).size.height * 0.45,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Colors",
                                                            style: TextStyle(
                                                                color: AppColors.backgroundColor,
                                                                fontSize: 24,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                          Text(
                                                            "Tap swatches to copy.",
                                                            style: TextStyle(
                                                                color: AppColors.backgroundColor,
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          if (listOfImageColors.isNotEmpty) ...[
                                                            SingleChildScrollView(
                                                              child: Wrap(
                                                                spacing: 10,
                                                                runSpacing: 10,
                                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                                children: List.generate(
                                                                    listOfImageColors.length,
                                                                    (index) => GestureDetector(
                                                                          onTap: () async {
                                                                            await Clipboard.setData(ClipboardData(
                                                                                text: _helperFunctions.colorToHex(
                                                                                    listOfImageColors[index].color)));
                                                                          },
                                                                          child: Container(
                                                                            height: 25,
                                                                            width: 70,
                                                                            decoration: BoxDecoration(
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                    color: AppColors.backgroundColor,
                                                                                    blurRadius: 2,
                                                                                    blurStyle: BlurStyle.outer,
                                                                                    spreadRadius: 0)
                                                                              ],
                                                                              borderRadius: BorderRadius.circular(6),
                                                                              color: listOfImageColors[index].color,
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                _helperFunctions.colorToHex(
                                                                                    listOfImageColors[index].color),
                                                                                style: TextStyle(
                                                                                    color: AppColors.textColor,
                                                                                    fontSize: 10),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )),
                                                              ),
                                                            )
                                                          ]
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          EvaIcons.info,
                                          size: 30,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                      Text(
                                        "Info",
                                        style: TextStyle(
                                          color: AppColors.textColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      downloadImageLoading
                                          ? const SizedBox(height: 30, width: 30, child: CustomLoadingWidget())
                                          : IconButton(
                                              onPressed: () async {
                                                setState(() {
                                                  downloadImageLoading = true;
                                                });
                                                await imageDownloader.downloadImage(widget.imageUrl);
                                                setState(() {
                                                  downloadImageLoading = false;
                                                });
                                              },
                                              icon: Icon(
                                                EvaIcons.download,
                                                size: 30,
                                                color: AppColors.textColor,
                                              ),
                                            ),
                                      Text(
                                        "Download",
                                        style: TextStyle(
                                          color: AppColors.textColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => StatefulBuilder(builder: (context, dialogState) {
                                              return AlertDialog(
                                                title: const Text("Apply"),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context).size.height / 4,
                                                  child: Column(
                                                    children: [
                                                      RadioListTile<ApplyWallpaperTypes>(
                                                        title: const Text('Set to home screen'),
                                                        value: ApplyWallpaperTypes.homeScreen,
                                                        groupValue: selectedApplyType,
                                                        onChanged: (value) {
                                                          dialogState(
                                                            () {
                                                              selectedApplyType = value;
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      RadioListTile<ApplyWallpaperTypes>(
                                                        title: const Text('Set to lock screen'),
                                                        value: ApplyWallpaperTypes.lockScreen,
                                                        groupValue: selectedApplyType,
                                                        onChanged: (value) {
                                                          dialogState(
                                                            () {
                                                              selectedApplyType = value;
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      RadioListTile<ApplyWallpaperTypes>(
                                                        title: const Text('Set to both'),
                                                        value: ApplyWallpaperTypes.both,
                                                        groupValue: selectedApplyType,
                                                        onChanged: (value) {
                                                          dialogState(
                                                            () {
                                                              selectedApplyType = value;
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(color: AppColors.backgroundColor),
                                                      )),
                                                  ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              WidgetStatePropertyAll(AppColors.primaryColor),
                                                          shape: const WidgetStatePropertyAll(StadiumBorder())),
                                                      onPressed: () async {
                                                        FunckeyMessage.show(isSuccess: true, message: "Applying...");
                                                        final isSet = await ApplyWallpapers.applyWallpaperOnHomeScreen(
                                                            widget.imageUrl);
                                                        isSet
                                                            ? FunckeyMessage.show(
                                                                isSuccess: true,
                                                                message: "Applied to Home Screen Successfully")
                                                            : FunckeyMessage.show(
                                                                isSuccess: false, message: "Failed to set wallpaper");
                                                      },
                                                      child: Text(
                                                        "OK",
                                                        style: TextStyle(color: AppColors.textColor),
                                                      ))
                                                ],
                                              );
                                            }),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.ios_share,
                                          size: 30,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                      Text(
                                        "Apply",
                                        style: TextStyle(
                                          color: AppColors.textColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const RootScreenNew(),
                                              ));
                                        },
                                        icon: Icon(
                                          EvaIcons.heart,
                                          size: 30,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                      Text(
                                        "Save",
                                        style: TextStyle(
                                          color: AppColors.textColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(), // Render an empty widget when hidden
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: SafeArea(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500), // Animation duration
          opacity: _isContainerVisible ? 1.0 : 0.0, //
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              height: 40,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                }, // Same toggle function for FAB
                backgroundColor: AppColors.secondaryColor,
                child: Icon(
                  EvaIcons.close,
                  color: AppColors.blackShade87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ApplyWallpaperTypes { lockScreen, homeScreen, both }
