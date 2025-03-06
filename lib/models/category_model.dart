class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['category_id'] ?? 0,
      name: json['category_name'] ?? 'Unknown',
    );
  }
}
