import 'package:app_kosmetik/PageCheckout.dart';
import 'package:app_kosmetik/PageNavigation.dart';
import 'package:app_kosmetik/models/ModelCart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PageListCart extends StatefulWidget {
  const PageListCart({super.key});

  @override
  State<PageListCart> createState() => _PageListCartState();
}

class _PageListCartState extends State<PageListCart> {
  String token = '';
  // String id = '';
  List<Datum> _cart = [];
  List<Datum> _selectedCartItems = [];
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> fetchCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found!');
      }

      http.Response res = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/list-cart'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');

      if (res.statusCode == 200) {
        final parsedData = modelCartFromJson(res.body);
        print('Parsed data: ${parsedData.data}');
        // setState(() {
        //   _cart = modelCartFromJson(res.body).data ?? [];
        // });

        setState(() {
          _cart = parsedData.data ?? [];
        });

        // cek data apakah berhasil didapatkan
        // if (_cart.isNotEmpty) {
        //   print('Data cart berhasil diambil: $_cart');
        // } else {
        //   print('Data cart kosong');
        // }
      } else {
        throw Exception('Failed to load cart: ${res.statusCode}');
      }
    } catch (e) {
      print('Error fetching cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching cart: $e')),
      );
    }
  }

  Future<void> _deleteCartItem(int id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found!');
      }

      http.Response res = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/cart-hapus/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        setState(() {
          _cart.removeWhere((item) => item.id == id);
        });
      } else {
        throw Exception('Failed to delete cart item: ${res.statusCode}');
      }
    } catch (e) {
      print('Error deleting cart item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting cart item: $e')),
      );
    }
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
      // id = prefs.getString('id_user') ?? '';
      print('Token: $token');
      // print('ID: $id');
      if (token.isEmpty) {
        print('Token is empty. Login process may have failed.');
      } else {
        fetchCart();
      }
    });
  }

  String truncateDescription(String description, int wordLimit) {
    List<String> words = description.split(' ');
    if (words.length <= wordLimit) {
      return description;
    }
    return words.sublist(0, wordLimit).join(' ') + '...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigationPage(initialIndex: 0),
              ),
            );
            // Navigator.pop(context);
          },
          icon: Container(
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF424252),
            ),
          ),
        ),
        toolbarHeight: 50,
        // backgroundColor: Color(0xFFE6E6E6),
        backgroundColor: Colors.white,
        title: Text(
          'My Cart',
          style: TextStyle(
            color: Color(0xFF424252),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _cart.isEmpty // Periksa apakah data cart kosong
          ? Center(
              // child: CircularProgressIndicator(),
              child: Center(
                child: Text('Your Cart is Empty'),
              ),
            )
          : ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                Datum cartItem = _cart[index];
                int _quantity = cartItem.quantity ?? 1;

                double getTotalAmount() {
                  double price = double.tryParse(cartItem.product.price) ?? 0.0;
                  return _quantity * price;
                }

                void _incrementQuantity() {
                  setState(() {
                    _quantity++;
                    cartItem.quantity = _quantity;
                  });
                }

                void _decrementQuantity() {
                  setState(() {
                    if (_quantity > 1) {
                      _quantity--;
                      cartItem.quantity = _quantity;
                    } else {
                      _deleteCartItem(cartItem.id);
                    }
                  });
                }

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Checkbox(
                          value: cartItem.selected,
                          onChanged: (bool? value) {
                            // setState(() {
                            //   cartItem.selected = value ?? false;
                            // });
                            setState(() {
                              cartItem.selected = value ?? false;
                              if (cartItem.selected) {
                                _selectedCartItems.add(cartItem);
                              } else {
                                _selectedCartItems.remove(cartItem);
                              }
                            });
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Image.network(
                          'http://127.0.0.1:8000/image/${cartItem.product.image}',
                          width: 110,
                          height: 110,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  capitalize(cartItem.product.productName),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  truncateDescription(
                                      cartItem.product.description, 20),
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rp. ${getTotalAmount().toStringAsFixed(3)}',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    // Text(
                                    //   'Rp. ${cartItem.product.price}',
                                    //   style: TextStyle(
                                    //     color: Colors.red,
                                    //     fontWeight: FontWeight.bold,
                                    //     fontSize: 16,
                                    //   ),
                                    // ),
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
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      //bottom bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 50.0,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total : Rp. ${calculateTotalAmount().toStringAsFixed(3)}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: _selectedCartItems.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageCheckout(
                              selectedItems: _selectedCartItems,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF424252),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => PageCheckout(),
              //       ),
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Color(0xFF424252),
              //     elevation: 0,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //   ),
              //   child: Text(
              //     'Checkout',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 16.0,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateTotalAmount() {
    double total = 0.0;
    for (var cartItem in _cart) {
      if (cartItem.selected == true) {
        double price = double.tryParse(cartItem.product.price) ?? 0.0;
        total += price * (cartItem.quantity ?? 1);
      }
    }
    return total;
  }
}
