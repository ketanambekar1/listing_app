class CategoryItem {
  final int id;
  final String nameEn;
  final String nameAr;
  final String slug;
  final int sortOrder;
  final String status;

  CategoryItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.slug,
    required this.sortOrder,
    required this.status,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'],
      nameEn: json['name_en'] ?? "",
      nameAr: json['name_ar'] ?? "",
      slug: json['slug'] ?? "",
      sortOrder: json['sort_order'] ?? 1,
      status: json['status'] ?? "",
    );
  }
}
