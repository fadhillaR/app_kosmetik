import 'dart:async';

import 'package:app_kosmetik/PageDetailProduk.dart';
import 'package:app_kosmetik/PageListCart.dart';
import 'package:app_kosmetik/models/ModelCategory.dart';
import 'package:app_kosmetik/models/ModelProduk.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PageMulai extends StatefulWidget {
  final PageController pageController;

  const PageMulai({required this.pageController, Key? key}) : super(key: key);

  @override
  State<PageMulai> createState() => _PageMulaiState();
}

class _PageMulaiState extends State<PageMulai> with TickerProviderStateMixin {
  String? userFirst;
  String? userLast;
  // String? userFull;
  String? userEmail;
  late Timer _timer;
  List<Category> _categories = [];
  List<Datum> _products = [];
  int _selectedCategoryIndex = -1;
  late TextEditingController _searchController;

  int _currentPage = 0;

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    return isLoggedIn ?? false;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    getUsername();
    startTimer();
    widget.pageController.addListener(_handlePageChange);
    fetchProducts();
    fetchCategories();
  }

  @override
  void dispose() {
    _timer.cancel();
    _searchController.dispose();
    widget.pageController.removeListener(_handlePageChange);
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      widget.pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  void _handlePageChange() {
    if (widget.pageController.page == 2) {
      Future.delayed(Duration(seconds: 3), () {
        if (widget.pageController.hasClients) {
          widget.pageController.jumpToPage(0);
        }
      });
    }
  }

  // filter kategori
  // void _onCategoryTabSelected(int index) {
  //   setState(() {
  //     if (index == 0) {
  //       _selectedCategoryIndex =
  //           -1; // Mengatur indeks kategori menjadi -1 untuk "All"
  //     } else {
  //       _selectedCategoryIndex =
  //           index - 1; // Mengurangi 1 untuk kategori aktual
  //     }
  //     fetchProducts(); // Memuat ulang produk saat kategori berubah
  //   });
  // }

  // filter search
  void _filterProducts(String query) {
    if (query.isEmpty) {
      //menampilkan semua produk jika tidak melakukan pencarian
      fetchProducts();
      return;
    }

    String lowerCaseQuery = query.toLowerCase();

    setState(() {
      _products = _products
          .where((product) => product.productName.toLowerCase().contains(lowerCaseQuery))
          .toList();
    });
  }

  void _onCategoryTabSelected(int index) {
    setState(() {
      _selectedCategoryIndex = index == 0 ? -1 : index - 1;
    });
    fetchProducts(); // Memuat ulang produk saat kategori berubah
  }

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userFirst = prefs.getString('first_name') ?? '';
      userLast = prefs.getString('last_name') ?? '';
      userEmail = prefs.getString('email');
    });
  }

  Future<void> fetchProducts() async {
    try {
      http.Response res =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/produk'));
      if (res.statusCode == 200) {
        List<Datum> allProducts = modelProdukFromJson(res.body).data;
        // Filter produk berdasarkan kategori yang dipilih
        _products = _selectedCategoryIndex == -1
            ? allProducts // Jika kategori "All" dipilih, tampilkan semua produk
            : allProducts
                .where((product) =>
                    product.categoryId ==
                    _categories[_selectedCategoryIndex].id)
                .toList();
        setState(() {});
      } else {
        throw Exception('Failed to load products: ${res.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  // Future<List<Datum>?> fetchProducts() async {
  //   try {
  //     http.Response res =
  //         await http.get(Uri.parse('http://127.0.0.1:8000/api/produk'));
  //     if (res.statusCode == 200) {
  //       setState(() {
  //         _products = modelProdukFromJson(res.body).data;
  //       });
  //     } else {
  //       throw Exception('Failed to load products: ${res.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching products: $e');
  //     setState(() {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text(e.toString())));
  //     });
  //   }
  // }

  Future<void> fetchCategories() async {
    try {
      http.Response res =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/category'));
      setState(() {
        _categories = modelCategoryFromJson(res.body).categories ?? [];
      });
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  String? getCategoryName(int categoryId) {
    final category = _categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => Category(
          id: -1,
          categoryName: 'Unknown',
          description: 'No description available',
          createdAt: DateTime(1970, 1, 1),
          updatedAt: DateTime(1970, 1, 1)),
    );
    return category.categoryName != 'Unknown' ? category.categoryName : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // toolbarHeight: 20,
        // backgroundColor: Color(0xFFE6E6E6),
        backgroundColor: Colors.white,
        title: Text(
          'Enchanté Beauty',
          style: TextStyle(
            color: Color(0xFF424252),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PageListCart(),
                ),
              );
            },
            icon: Container(
              child: Icon(
                Icons.shopping_cart,
                color: Color(0xFF424252),
              ),
            ),
          ),
        ],
      ),
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: 1500,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE6E6E6), // Warna utama di tengah
                Color(0xFFE6E6E6), // Warna transparan di pinggir
                Color(0xFFE6E6E6), // Warna transparan di pinggir
                Color(0xFFE6E6E6), // Warna utama di tengah
              ],
              stops: [
                0.1,
                0.4,
                0.6,
                0.9
              ], // Menentukan ukuran masing-masing warna
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Slider
                Container(
                  height: 200,
                  child: PageView(
                    controller: widget.pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                      print("Page changed to: $page");
                    },
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      Image.network(
                        'https://goodstats.id/img/articles/original/2022/09/15/7-merek-kosmetik-lokal-paling-banyak-digunakan-di-indonesia-2022-ccBqp8iCKF.jpg?p=articles-lg',
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        'https://images.tokopedia.net/blog-tokopedia-com/uploads/2020/08/Featured_Merk-Kosmetik-Lokal.jpg',
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        'https://asset.kompas.com/crops/K06M4do5yUPjJOP5CkYe2aITo5w=/0x0:1999x1333/1200x800/data/photo/2019/06/12/3246172269.jpg',
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                //search
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          _filterProducts(value);
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set border radius here
                            borderSide: BorderSide(color: Color(0xFFE6E6E6)),
                          ),
                          prefixIcon: Icon(
                              Icons.search), // Icon on the left side of input
                        ),
                      ),
                    ),

                    // Expanded(
                    //   child: ListView.builder(
                    //     itemCount: _filteredBudayaList.length,
                    //     itemBuilder: (context, index) {
                    //       return Card(
                    //         child: ListTile(
                    //           title: Text(
                    //             _filteredBudayaList[index]['judul'],
                    //             style: TextStyle(
                    //                 color: Color.fromARGB(255, 74, 48, 0)),
                    //           ),
                    //           onTap: () => _navigateToDetail(
                    //               _filteredBudayaList[
                    //                   index]), // Tambahkan fungsi onTap di sini
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),

                SizedBox(height: 16),

                // Tab Bar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category',
                        style: TextStyle(
                          color: Color(0xFF424252),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     // Handle view all action here
                      //   },
                      //   child: Text(
                      //     'View All',
                      //     style: TextStyle(
                      //       color: Colors.blue,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                _categories.isEmpty
                    ? CircularProgressIndicator() // Show loading indicator while fetching data
                    : DefaultTabController(
                        length: _categories.length + 1,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TabBar(
                                  isScrollable: true,
                                  unselectedLabelColor: Color(0xFF424252),
                                  labelColor: Colors.purple,
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  unselectedLabelStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  // indicator: BoxDecoration(
                                  //   color: Color(0xFF424252).withOpacity(0.4),
                                  // ),
                                  tabs: [
                                    Tab(
                                        text:
                                            'All'), // Tab baru untuk menampilkan semua produk
                                    ..._categories.map((category) =>
                                        Tab(text: category.categoryName)),
                                  ],
                                  // tabs: _categories
                                  //     .map((category) => Tab(
                                  //           text: category.categoryName,
                                  //         ))
                                  //     .toList(),
                                  onTap: _onCategoryTabSelected,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            // Tab Bar View
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.only(left: 8.0, right: 8.0),
                            //   child: Container(
                            //     height: 100,
                            //     child: TabBarView(
                            //       children: _categories
                            //           .map((category) => Container(
                            //                 color: Colors.white,
                            //                 child: Center(
                            //                   child: Text(
                            //                     category.categoryName,
                            //                     style: TextStyle(
                            //                       color: Color(0xFF424252),
                            //                       fontSize: 24,
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ))
                            //           .toList(),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                // produk
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product',
                        style: TextStyle(
                          color: Color(0xFF424252),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     // Handle view all action here
                      //   },
                      //   child: Text(
                      //     'View All',
                      //     style: TextStyle(
                      //       color: Colors.blue,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                // list produk
                _products.isEmpty
                    ? Center(
                        child: Text(
                          'No Products Available',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // item perbaris
                            crossAxisSpacing: 10, //horizontal space between
                            mainAxisSpacing: 10, //vertical space between
                            childAspectRatio: 1, //height
                          ),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            final categoryName =
                                getCategoryName(product.categoryId) ??
                                    'Unknown';

                            // Filter produk sesuai dengan kategori yang dipilih
                            if (_selectedCategoryIndex != -1 &&
                                product.categoryId !=
                                    _categories[_selectedCategoryIndex].id) {
                              return Container(); // Jika bukan kategori yang dipilih, tampilkan kontainer kosong
                            }
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PageDetailProduk(product: product),
                                  ),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.all(0),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        // product.image,
                                        'http://127.0.0.1:8000/image/${product.image}',
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 8.0),
                                      child: Text(
                                        // capitalize(product.productName),
                                        capitalize('$categoryName'),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                          top: 1.0,
                                          bottom: 8.0),
                                      child: Text(
                                        capitalize(product.productName),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            'Rp. ${product.price}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            'Stock : ${product.stock}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
