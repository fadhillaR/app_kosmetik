// To parse this JSON data, do
//
//     final modelCategory = modelCategoryFromJson(jsonString);

import 'dart:convert';

ModelCategory modelCategoryFromJson(String str) => ModelCategory.fromJson(json.decode(str));

String modelCategoryToJson(ModelCategory data) => json.encode(data.toJson());

class ModelCategory {
    bool status;
    String message;
    List<Category> categories;

    ModelCategory({
        required this.status,
        required this.message,
        required this.categories,
    });

    factory ModelCategory.fromJson(Map<String, dynamic> json) => ModelCategory(
        status: json["status"],
        message: json["message"],
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    };
}

class Category {
    int id;
    String categoryName;
    String description;
    DateTime createdAt;
    DateTime updatedAt;

    Category({
        required this.id,
        required this.categoryName,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["category_name"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
