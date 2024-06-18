// To parse this JSON data, do
//
//     final modelFavorite = modelFavoriteFromJson(jsonString);

import 'dart:convert';

ModelFavorite modelFavoriteFromJson(String str) => ModelFavorite.fromJson(json.decode(str));

String modelFavoriteToJson(ModelFavorite data) => json.encode(data.toJson());

class ModelFavorite {
    bool status;
    String message;
    List<Datum> data;

    ModelFavorite({
        required this.status,
        required this.message,
        required this.data,
    });

    factory ModelFavorite.fromJson(Map<String, dynamic> json) => ModelFavorite(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    int userId;
    int productId;
    DateTime createdAt;
    DateTime updatedAt;
    Product product;

    Datum({
        required this.id,
        required this.userId,
        required this.productId,
        required this.createdAt,
        required this.updatedAt,
        required this.product,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product": product.toJson(),
    };
}

class Product {
    int id;
    int categoryId;
    String productName;
    String image;
    String price;
    int stock;
    String description;
    DateTime createdAt;
    DateTime updatedAt;

    Product({
        required this.id,
        required this.categoryId,
        required this.productName,
        required this.image,
        required this.price,
        required this.stock,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        categoryId: json["category_id"],
        productName: json["product_name"],
        image: json["image"],
        price: json["price"],
        stock: json["stock"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "product_name": productName,
        "image": image,
        "price": price,
        "stock": stock,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
