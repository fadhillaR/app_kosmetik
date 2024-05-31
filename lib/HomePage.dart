import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class PageMulai extends StatefulWidget {
  const PageMulai({super.key});

  @override
  State<PageMulai> createState() => _PageMulaiState();
}

class _PageMulaiState extends State<PageMulai> with TickerProviderStateMixin {
  // String? userName;
  // String? userFull;
  // String? userEmail;

  // Future<bool> _checkLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? isLoggedIn = prefs.getBool('isLoggedIn');
  //   return isLoggedIn ?? false;
  // }

  // Future<void> _logout(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('isLoggedIn');
  //   await prefs.clear();

  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => PageLogin()),
  //   );
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getUsername();
  // }

  // Future<void> getUsername() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     userName = prefs.getString('username') ?? '';
  //     userFull = prefs.getString('fullname') ?? '';
  //     userEmail = prefs.getString('email');
  //   });
  // }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hide the back button
        toolbarHeight: 0, //app bar height
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: 750,
          width: double.infinity,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //card
                  Positioned(
                    top: 50,
                    right: 25,
                    left: 25,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFE6E6E6), // Warna transparan di pinggir
                              Color(0xFFE6E6E6),  // Warna utama di tengah
                              Color(0xFFE6E6E6),  // Warna utama di tengah
                              Color(0xFFE6E6E6),  // Warna transparan di pinggir
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
                        child: Stack(
                          children: [
                            Positioned(
                                top: 80,
                                left: 100,
                                right: 100,
                                bottom: 20,
                                child: Text(
                                  // userFull != null ? 'Welcome, $userFull' : '',
                                  'Discover the Magic of Beauty',
                                  style: TextStyle(
                                      color: Color(0xFF424252),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Open Sans'),
                                )),
                            // Positioned(
                            //   top: 18,
                            //   right: 10,
                            //   child: IconButton(
                            //     icon: Icon(
                            //       Icons.exit_to_app,
                            //       color: Color.fromARGB(255, 74, 48, 0),
                            //       size: 24,
                            //     ),
                            //     onPressed: () async {
                            //       // await _logout(context);
                            //     },
                            //   ),
                            // ),
                            // Positioned(
                            //     top: 45,
                            //     left: 20,
                            //     child: Text(
                            //       userEmail ?? '',

                            //       style: TextStyle(
                            //         color: Color.fromARGB(255, 74, 48, 0),
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     )),
                            // Positioned(
                            //   top: 115,
                            //   // width: 415,
                            //   right: 20,
                            //   left: 20,
                            //   // left:
                            //   //     MediaQuery.of(context).size.width / 7.6 - 50,
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => PageProfil(),
                            //         ),
                            //       );
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //       padding: EdgeInsets.symmetric(
                            //           horizontal: 20, vertical: 15),
                            //       backgroundColor: Colors.white,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(10),
                            //       ),
                            //     ),
                            //     child: Text(
                            //       'Info Profile',
                            //       style: TextStyle(
                            //         color: Color.fromARGB(255, 74, 48, 0),
                            //         fontWeight: FontWeight.w500,
                            //         fontSize: 14,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //rekomendasi
                  // Positioned(
                  //   top: 270,
                  //   left: 20,
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         '| ',
                  //         style: TextStyle(
                  //             color: Colors.blue,
                  //             fontFamily: ('Open Sans'),
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //       Text(
                  //         'Menyediakan Informasi',
                  //         style: TextStyle(
                  //             fontFamily: ('Open Sans'),
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  //menu items
                  Positioned(
                    top: 300,
                    left: 70,
                    right: 70,
                    // left: MediaQuery.of(context).size.width / 5 - 50,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFE6E6E6)
                                      .withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           PageListPegawai()),
                                // );
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 13,),
                                  Image.asset(
                                    'assets/b1.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                  // SizedBox(height: 17),
                                  // Text(
                                  //   'Pengaduan\nPegawai',
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //       color: Color.fromARGB(255, 85, 77, 181),
                                  //       fontSize: 10,
                                  //       fontFamily: 'Open Sans',
                                  //       fontWeight: FontWeight.w600),
                                  // ),
                                  // SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFE6E6E6)
                                      .withOpacity(0.2), // Warna bayangan
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           PageListKorupsi()),
                                // );
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 13,
                                  ),
                                  Image.asset(
                                    'assets/b2.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                  // SizedBox(height: 17),
                                  // Text(
                                  //   'Pengaduan Tindak\nPidana Korupsi',
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //       color: Color.fromARGB(255, 85, 77, 181),
                                  //       fontSize: 10,
                                  //       fontFamily: 'Open Sans',
                                  //       fontWeight: FontWeight.w600),
                                  // ),
                                  // SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //menu items
                  Positioned(
                    top: 500,
                    left: 70,
                    right: 70,
                    // left: MediaQuery.of(context).size.width / 5 - 50,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFE6E6E6)
                                      .withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           PageListPegawai()),
                                // );
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 13,),
                                  Image.asset(
                                    'assets/b2.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                  // SizedBox(height: 17),
                                  // Text(
                                  //   'Pengaduan\nPegawai',
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //       color: Color.fromARGB(255, 85, 77, 181),
                                  //       fontSize: 10,
                                  //       fontFamily: 'Open Sans',
                                  //       fontWeight: FontWeight.w600),
                                  // ),
                                  // SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFE6E6E6)
                                      .withOpacity(0.2), // Warna bayangan
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           PageListKorupsi()),
                                // );
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 13,
                                  ),
                                  Image.asset(
                                    'assets/b1.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                  // SizedBox(height: 17),
                                  // Text(
                                  //   'Pengaduan Tindak\nPidana Korupsi',
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //       color: Color.fromARGB(255, 85, 77, 181),
                                  //       fontSize: 10,
                                  //       fontFamily: 'Open Sans',
                                  //       fontWeight: FontWeight.w600),
                                  // ),
                                  // SizedBox(height: 5),
                                ],
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
        ),
      ),
    );
  }
}
