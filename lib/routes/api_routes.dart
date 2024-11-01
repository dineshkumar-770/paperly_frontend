class ApiRoutes {
  static String serverType = "D";
  static String baseURL = getServer(serverType);
  static String addWallpapers = "$baseURL/add_wallpaper";
  static String getAllWallpapersByCategory = "$baseURL/get_all_wall_by_category";
  static String addCategory = "$baseURL/add_category";
  static String getAllWallpapers = "$baseURL/get_all_images";
  static String getAllCategories = "$baseURL/get_all_categories";
}

String getServer(String type) {
  const prodUrl = "https://thedineshdev.tech/paperly";
  const devUrl = "https://1cfa-110-235-233-14.ngrok-free.app";
  if (type == "L") {
    return prodUrl;
  } else {
    return devUrl;
  }
}
