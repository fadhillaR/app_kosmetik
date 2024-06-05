import 'dart:convert';
import 'dart:core'; //validasi format email

import 'package:app_kosmetik/PageLogin.dart';
import 'package:app_kosmetik/PageVerif.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PageRegister extends StatefulWidget {
  const PageRegister({super.key});

  @override
  State<PageRegister> createState() => _PageRegisterState();
}

class _PageRegisterState extends State<PageRegister> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  // TextEditingController txtPassCon = TextEditingController();
  TextEditingController txtFirst = TextEditingController();
  TextEditingController txtLast = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  // TextEditingController txtRole = TextEditingController(text: 'customer');
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool _obscureText = true;
  // bool _obscureText1 = true;

  // Definisi regex untuk memeriksa format email
  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<int> _register() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/register'),
        body: {
          "username": txtUsername.text,
          "email": txtEmail.text,
          "password": txtPassword.text,
          // "password_confirmation": txtPassCon.text,
          "first_name": txtFirst.text,
          "last_name": txtLast.text,
          "phone": txtPhone.text,
          "address": txtAddress.text,
          // "role": txtRole.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final registerStatus = responseData['value'];

        return registerStatus ?? 0;
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['message'];
        if (errorMessage == 'The given data was invalid.') {
          return 2;
        }
        return 2;
      } else {
        return 2;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: 1000,
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
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Positioned(
                    top: 100,
                    left: 40,
                    right: 40,
                    bottom: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0, // Ketebalan border
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                        ),
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                          ),
                        ),
                        color: Colors.white,
                        child: Container(
                          width: 200,
                          height: 1000,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: Color(0xFF424252),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                contentPadding:
                                    EdgeInsets.fromLTRB(35, 10, 20, 10),
                                subtitle: Text(
                                  'Hello there, fill in below to create an account',
                                  style: TextStyle(
                                    color: Color(0xffA9A297),
                                  ),
                                ),
                              ),
                              Form(
                                key: keyForm,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 30, left: 30, top: 10, bottom: 10),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                          validator: (val) {
                                            return val!.isEmpty
                                                ? "Tidak Boleh kosong"
                                                : null;
                                          },
                                          controller: txtUsername,
                                          decoration: InputDecoration(
                                            fillColor:
                                                Colors.grey.withOpacity(0.2),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            hintText: 'Enter username',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return "Tidak Boleh kosong";
                                            } else if (!emailRegex
                                                .hasMatch(val)) {
                                              return "e.g. ex@mail.com";
                                            }
                                            return null;
                                          },
                                          controller: txtEmail,
                                          decoration: InputDecoration(
                                            fillColor:
                                                Colors.grey.withOpacity(0.2),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            hintText: 'Enter email address',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                          obscureText: _obscureText,
                                          validator: (val) {
                                            return val!.isEmpty
                                                ? "Tidak Boleh kosong"
                                                : null;
                                          },
                                          controller: txtPassword,
                                          decoration: InputDecoration(
                                            fillColor:
                                                Colors.grey.withOpacity(0.2),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            hintText: 'Enter password',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _obscureText = !_obscureText;
                                                });
                                              },
                                              icon: Icon(
                                                _obscureText
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Color(0xFF424252),
                                                size: 14.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                          validator: (val) {
                                            return val!.isEmpty
                                                ? "Tidak Boleh kosong"
                                                : null;
                                          },
                                          controller: txtFirst,
                                          decoration: InputDecoration(
                                            fillColor:
                                                Colors.grey.withOpacity(0.2),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            hintText: 'Enter first name',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                          validator: (val) {
                                            return val!.isEmpty
                                                ? "Tidak Boleh kosong"
                                                : null;
                                          },
                                          controller: txtLast,
                                          decoration: InputDecoration(
                                            fillColor:
                                                Colors.grey.withOpacity(0.2),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            hintText: 'Enter last name',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                          validator: (val) {
                                            return val!.isEmpty
                                                ? "Tidak Boleh kosong"
                                                : null;
                                          },
                                          controller: txtPhone,
                                          decoration: InputDecoration(
                                            fillColor:
                                                Colors.grey.withOpacity(0.2),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            hintText: 'Enter phone number',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                          validator: (val) {
                                            return val!.isEmpty
                                                ? "Tidak Boleh kosong"
                                                : null;
                                          },
                                          controller: txtAddress,
                                          decoration: InputDecoration(
                                            fillColor:
                                                Colors.grey.withOpacity(0.2),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            hintText: 'Enter address',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (keyForm.currentState
                                                    ?.validate() ==
                                                true) {
                                              _register()
                                                  .then((registerStatus) {
                                                if (registerStatus == 1) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Berhasil didaftarkan!'),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  );
                                                  // Navigator
                                                  //     .pushReplacementNamed(
                                                  //         context,
                                                  //         '/PageLogin');
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PageVerif()),
                                                      (route) => false);
                                                } else if (registerStatus ==
                                                    2) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'username atau email telah digunakan!'),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                } else if (registerStatus ==
                                                    0) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Gagal didaftarkan'),
                                                      backgroundColor:
                                                          Colors.deepOrange,
                                                    ),
                                                  );
                                                } else {}
                                              }).catchError((error) {
                                                print(
                                                    "Error during login: $error");
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'An error occurred during login. Please try again later.'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              });
                                            }
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             PageVerif()));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            backgroundColor: Color(0xFF424252),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            minimumSize: Size(300, 40),
                                          ),
                                          child: Text(
                                            'Sign Up',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              text: "I’m already a member ",
                                              style: TextStyle(
                                                color: Color(0xFF424252),
                                              ),
                                              children: [
                                                TextSpan(
                                                    text: 'Sign In',
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PageLogin()));
                                                          },
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
