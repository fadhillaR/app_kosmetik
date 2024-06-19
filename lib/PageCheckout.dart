import 'package:app_kosmetik/PageListCart.dart';
import 'package:app_kosmetik/PageNavigation.dart';
import 'package:app_kosmetik/models/ModelCart.dart';
import 'package:app_kosmetik/navigation/PageOrder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PageCheckout extends StatefulWidget {
  final List<Datum> selectedItems;

  const PageCheckout({super.key, required this.selectedItems});

  @override
  State<PageCheckout> createState() => _PageCheckoutState();
}

class _PageCheckoutState extends State<PageCheckout> {
  String token = "";
  String first_name = "";
  String last_name = "";
  String phone = "";
  String address = "";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  double calculateTotalAmount() {
    double total = 0.0;
    for (var item in widget.selectedItems) {
      total += getTotalAmount(item);
    }
    return total;
  }

  double getTotalAmount(Datum item) {
    double price = double.tryParse(item.product.price) ?? 0.0;
    return price * (item.quantity ?? 1);
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      first_name = prefs.getString('first_name') ?? '';
      last_name = prefs.getString('last_name') ?? '';
      phone = prefs.getString('phone') ?? '';
      address = prefs.getString('address') ?? '';
    });
  }

  Future<void> _placeOrder(String methodPayment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String cartIds =
        widget.selectedItems.map((item) => item.id.toString()).join(',');

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/order-tambah'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'cart_id': cartIds,
          'methodPayment': methodPayment,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status']) {
          Navigator.pushReplacement(
            context,
            // MaterialPageRoute(
            //   builder: (context) => PageOrder(), 
            // ),

            MaterialPageRoute(
              builder: (context) => BottomNavigationPage(initialIndex: 0),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order berhasil dibuat')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order gagal: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order gagal: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order gagal: $e')),
      );
    }
  }

  void _showPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pilih Metode Pembayaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Cash'),
                onTap: () {
                  Navigator.pop(context);
                  _placeOrder('Cash');
                },
              ),
              // Tambahkan metode pembayaran lain jika diperlukan
            ],
          ),
        );
      },
    );
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
                builder: (context) => PageListCart(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF424252),
          ),
        ),
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Color(0xFF424252),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF424252),
                  Color(0xFF424252),
                  Color(0xFF424252),
                  Color(0xFF424252),
                ],
                stops: [0.1, 0.4, 0.6, 0.9],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.place,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        capitalize('$first_name $last_name | $phone'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        capitalize('$address'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedItems.length,
              itemBuilder: (context, index) {
                Datum item = widget.selectedItems[index];
                double itemTotal = getTotalAmount(item);
                return ListTile(
                  leading: Image.network(
                    'http://127.0.0.1:8000/image/${item.product.image}',
                    width: 50,
                    height: 50,
                  ),
                  title: Text(capitalize(item.product.productName)),
                  subtitle:
                      Text('Rp. ${item.product.price} x ${item.quantity}'),
                  trailing: Text(
                    'Rp. ${itemTotal.toStringAsFixed(3)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
                onPressed: _showPaymentMethodDialog,
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
            ],
          ),
        ),
      ),
    );
  }
}
