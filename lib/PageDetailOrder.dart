import 'package:app_kosmetik/PageNavigation.dart';
import 'package:app_kosmetik/models/ModelOrder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageDetailOrder extends StatefulWidget {
  final Datum order;

  const PageDetailOrder({super.key, required this.order});
  // const PageDetailOrder({super.key});

  @override
  State<PageDetailOrder> createState() => _PageDetailOrderState();
}

class _PageDetailOrderState extends State<PageDetailOrder> {
  // List<Datum> products = [];
  late int totalCartItems;
  String address = "";

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  String truncateDescription(String description, int wordLimit) {
    List<String> words = description.split(' ');
    if (words.length <= wordLimit) {
      return description;
    }
    return words.sublist(0, wordLimit).join(' ') + '...';
  }

  @override
  void initState() {
    super.initState();
    // fetchProducts();
    calculateTotalCartItems();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString('address') ?? '';
    });
  }

  void calculateTotalCartItems() {
    // Calculate total number of cart items
    int total = 0;
    for (CartItem item in widget.order.cartItems) {
      total += item.quantity;
    }
    setState(() {
      totalCartItems = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMd().format(widget.order.createdAt);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigationPage(initialIndex: 1),
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
          'Order Detail',
          style: TextStyle(
            color: Color(0xFF424252),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.grey),
              //   borderRadius: BorderRadius.circular(10),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.order.id}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$formattedDate',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$totalCartItems Items',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Column(
                    children: widget.order.cartItems.map((item) {
                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  'http://127.0.0.1:8000/image/${item.image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      capitalize(item.productName),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      truncateDescription(
                                          'Description : ${item.description}',
                                          10),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${item.quantity} units',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Rp. ${item.totalPrice}',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Order Information',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Shipping Address',
                            style: TextStyle(
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            ':',
                            style: TextStyle(
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              '$address',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                            ),
                          ),
                          SizedBox(width: 78),
                          Text(
                            ':',
                            style: TextStyle(
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${widget.order.status}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Payment Method',
                            style: TextStyle(
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            ':',
                            style: TextStyle(
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${widget.order.methodPayment}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Total Payment',
                            style: TextStyle(
                            ),
                          ),
                          SizedBox(width: 25),
                          Text(
                            ':',
                            style: TextStyle(
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Rp. ${widget.order.totalPayment}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
