class CategoryTranslation {
  final int id;
  final String language;
  final String name;
  final int category;

  CategoryTranslation({required this.id, required this.language, required this.name, required this.category});

  factory CategoryTranslation.fromJson(Map<String, dynamic> json) {
    return CategoryTranslation(id: json["id"], language: json["language"], name: json["name"], category: json["category"]);
  }
}
