import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class HelperFunctions {
  Future<List<PaletteColor>> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.paletteColors;
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  
}
