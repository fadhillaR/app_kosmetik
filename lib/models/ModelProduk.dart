// To parse this JSON data, do
//
//     final modelProduk = modelProdukFromJson(jsonString);

import 'dart:convert';

ModelProduk modelProdukFromJson(String str) =>
    ModelProduk.fromJson(json.decode(str));

String modelProdukToJson(ModelProduk data) => json.encode(data.toJson());

class ModelProduk {
  bool status;
  String message;
  List<Datum> data;

  ModelProduk({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ModelProduk.fromJson(Map<String, dynamic> json) => ModelProduk(
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
  int categoryId;
  String productName;
  String image;
  String price;
  int stock;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite;

  Datum({
    required this.id,
    required this.categoryId,
    required this.productName,
    required this.image,
    required this.price,
    required this.stock,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
