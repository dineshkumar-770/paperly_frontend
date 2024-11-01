class AllCategoriesModel {
  String? status;
  String? message;
  List<CategoryData>? data;

  AllCategoriesModel({
    this.status,
    this.message,
    this.data,
  });

  factory AllCategoriesModel.fromJson(Map<String, dynamic> json) => AllCategoriesModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<CategoryData>.from(json["data"].map((x) => CategoryData.fromJson(x))),
      );
}

class CategoryData {
  String? categoryName;
  String? categoryId;
  int? totalImages;
  String? categoryImage;

  CategoryData({
    this.categoryName,
    this.categoryId,
    this.totalImages,
    this.categoryImage,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        categoryName: json["category_name"],
        categoryId: json["category_id"],
        totalImages: json["total_images"],
        categoryImage: json["category_image"],
      );
}
