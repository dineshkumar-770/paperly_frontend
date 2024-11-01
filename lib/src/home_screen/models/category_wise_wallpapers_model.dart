class CategoryWiseWallpaperModel {
  String? status;
  String? message;
  List<CategoryWallpaper>? data;

  CategoryWiseWallpaperModel({
    this.status,
    this.message,
    this.data,
  });

  factory CategoryWiseWallpaperModel.fromJson(Map<String, dynamic> json) => CategoryWiseWallpaperModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<CategoryWallpaper>.from(json["data"].map((x) => CategoryWallpaper.fromJson(x))),
      );
}

class CategoryWallpaper {
  String? filename;
  int? size;
  String? timestamp;
  String? wallpaperId;
  String? category;

  CategoryWallpaper({
    this.filename,
    this.size,
    this.timestamp,
    this.wallpaperId,
    this.category,
  });

  factory CategoryWallpaper.fromJson(Map<String, dynamic> json) => CategoryWallpaper(
        filename: json["filename"],
        size: json["size"],
        timestamp: json["timestamp"],
        wallpaperId: json["wallpaper_id"],
        category: json["category"],
      );
}
