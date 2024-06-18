// To parse this JSON data, do
//
//     final modelOrder = modelOrderFromJson(jsonString);

import 'dart:convert';

ModelOrder modelOrderFromJson(String str) => ModelOrder.fromJson(json.decode(str));

String modelOrderToJson(ModelOrder data) => json.encode(data.toJson());

class ModelOrder {
    bool status;
    List<Datum> data;

    ModelOrder({
        required this.status,
        required this.data,
    });

    factory ModelOrder.fromJson(Map<String, dynamic> json) => ModelOrder(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    int userId;
    String cartId;
    String totalPayment;
    String status;
    String methodPayment;
    DateTime createdAt;
    DateTime updatedAt;
    List<CartItem> cartItems;

    Datum({
        required this.id,
        required this.userId,
        required this.cartId,
        required this.totalPayment,
        required this.status,
        required this.methodPayment,
        required this.createdAt,
        required this.updatedAt,
        required this.cartItems,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        cartId: json["cart_id"],
        totalPayment: json["totalPayment"],
        status: json["status"],
        methodPayment: json["methodPayment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        cartItems: List<CartItem>.from(json["cart_items"].map((x) => CartItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "cart_id": cartId,
        "totalPayment": totalPayment,
        "status": status,
        "methodPayment": methodPayment,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "cart_items": List<dynamic>.from(cartItems.map((x) => x.toJson())),
    };
}

class CartItem {
    int cartId;
    int productId;
    String productName;
    int quantity;
    String totalPrice;
    String image;       
    String description; 
    String price;    

    CartItem({
        required this.cartId,
        required this.productId,
        required this.productName,
        required this.quantity,
        required this.totalPrice,
        required this.image,    
        required this.description,
        required this.price, 
    });

    factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        cartId: json["cart_id"],
        productId: json["product_id"],
        productName: json["product_name"],  
        quantity: json["quantity"],
        totalPrice: json["totalPrice"],
        image: json["image"],      
        description: json["description"],
        price: json["price"],       
    );

    Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "product_id": productId,
        "product_name": productName, 
        "quantity": quantity,
        "totalPrice": totalPrice,
        "image": image,           
        "description": description,
        "price": price, 
    };
}
