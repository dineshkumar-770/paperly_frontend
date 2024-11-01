class AllWallpapersModel {
  String? status;
  String? message;
  List<WallpaperData>? data;

  AllWallpapersModel({
    this.status,
    this.message,
    this.data,
  });

  factory AllWallpapersModel.fromJson(Map<String, dynamic> json) => AllWallpapersModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null? []:List<WallpaperData>.from(json["data"].map((x) => WallpaperData.fromJson(x))),
      );
}

class WallpaperData {
  String? filename;
  int? size;
  String? wallpaperId;
  String? category;
  String? timestamp;

  WallpaperData({
    this.filename,
    this.size,
    this.timestamp,
    this.wallpaperId,
    this.category,
  });

  factory WallpaperData.fromJson(Map<String, dynamic> json) => WallpaperData(
        filename: json["filename"],
        size: json["size"],
        timestamp: json["timestamp"],
        wallpaperId: json["wallpaper_id"],
        category: json["category"],
      );
}
