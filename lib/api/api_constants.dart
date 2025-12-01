class ApiConstants {
  ApiConstants._();
  static const String baseUrl =
      "http://10.0.2.2:8055"; //"http://localhost:8055";
  static const String authToken =
      "625xdmc2faJCI2M7qUTHsJFxA6q1umgP"; // put in .env ideally

  static const String banners = "/items/dashboard_banner";
  static const String categories = "/items/categories";
  static const String featureProducts = "/items/feature_products";
  static const String productsByCategory =
      "/items/products?filter[category_id][_eq]=";
}
