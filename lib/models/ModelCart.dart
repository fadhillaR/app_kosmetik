// To parse this JSON data, do
//
//     final modelCart = modelCartFromJson(jsonString);

import 'dart:convert';

ModelCart modelCartFromJson(String str) => ModelCart.fromJson(json.decode(str));

String modelCartToJson(ModelCart data) => json.encode(data.toJson());

class ModelCart {
    bool status;
    String message;
    List<Datum> data;

    ModelCart({
        required this.status,
        required this.message,
        required this.data,
    });

    factory ModelCart.fromJson(Map<String, dynamic> json) => ModelCart(
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
    int quantity;
    String totalPrice;
    dynamic createdAt;
    dynamic updatedAt;
    Product product;
    bool selected;

    Datum({
        required this.id,
        required this.userId,
        required this.productId,
        required this.quantity,
        required this.totalPrice,
        required this.createdAt,
        required this.updatedAt,
        required this.product,
        this.selected = false,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        totalPrice: json["totalPrice"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        product: Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "quantity": quantity,
        "totalPrice": totalPrice,
        "created_at": createdAt,
        "updated_at": updatedAt,
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
