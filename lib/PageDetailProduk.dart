import 'package:app_kosmetik/PageNavigation.dart';
import 'package:app_kosmetik/models/ModelProduk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PageDetailProduk extends StatefulWidget {
  final Datum product;
  const PageDetailProduk({Key? key, required this.product}) : super(key: key);

  @override
  _PageDetailProdukState createState() => _PageDetailProdukState();
}

class _PageDetailProdukState extends State<PageDetailProduk> {
  int _quantity = 1;
  String token = '';
  bool _isAddingToCart = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkIfFavorite();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
      print('Token: $token');
      if (token.isEmpty) {
        print('Token is empty. Login process may have failed.');
      } else {}
    });
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  double getTotalAmount() {
    double price = double.tryParse(widget.product.price) ?? 0.0;
    return _quantity * price;
  }

  Future<void> _addToCart() async {
    if (_isAddingToCart) {
      return; // menghindari pemanggilan API ganda
    }
    try {
      setState(() {
        _isAddingToCart = true; // Menonaktifkan tombol "Add to Cart"
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      print('Token: $token');

      if (token == null) {
        throw Exception('Token not found!');
      }

      print('Product ID: ${widget.product.id}');
      print('Quantity: $_quantity');
      print(
          'Data yang dikirim ke API: { "product_id": ${widget.product.id}, "quantity": $_quantity }');

      final response = await http.post(
        Uri.parse(
            'http://127.0.0.1:8000/api/add-toCart?product_id=${widget.product.id}&quantity=$_quantity'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'product_id': widget.product.id,
          'quantity': _quantity,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product successfully added to cart')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to add product to cart: ${responseBody['message']}')),
          );
        }
      } else if (response.statusCode == 422) {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Validation error: ${responseBody['errors']}')),
        );
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product not found')),
        );
      } else {
        throw Exception('Failed to add to cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to cart: $e')),
      );
    } finally {
      setState(() {
        _isAddingToCart = false; // Mengaktifkan kembali tombol "Add to Cart"
      });
    }
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteProductIds =
        prefs.getStringList('favoriteProducts') ?? [];
    if (_isFavorite) {
      favoriteProductIds.remove(widget.product.id.toString());
    } else {
      favoriteProductIds.add(widget.product.id.toString());
    }
    await prefs.setStringList('favoriteProducts', favoriteProductIds);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _checkIfFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteProductIds =
        prefs.getStringList('favoriteProducts') ?? [];
    setState(() {
      _isFavorite = favoriteProductIds.contains(widget.product.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 800,
          child: Stack(
            children: [
              Image.network(
                'http://127.0.0.1:8000/image/${widget.product.image}',
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 20,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BottomNavigationPage(initialIndex: 0),
                      ),
                    );
                    // Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 300,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            capitalize('${widget.product.productName}'),
                            style: TextStyle(
                                color: Color(0xFF424252),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: Color(0xFF424252),
                              size: 24,
                            ),
                            onPressed: _toggleFavorite,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${widget.product.description}',
                        style: TextStyle(
                          color: Color(0xFF424252),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp. ${widget.product.price}',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                color: Color(0xFF424252),
                                onPressed: _decrementQuantity,
                              ),
                              Text(
                                '$_quantity',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                color: Color(0xFF424252),
                                onPressed: _incrementQuantity,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                                color: Color(0xFF424252),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rp. ${getTotalAmount().toStringAsFixed(3)}',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: _addToCart,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            backgroundColor: Color(0xFF424252),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: Size(300, 50),
                          ),
                          child: Text(
                            'Add to cart',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
