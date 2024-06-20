import 'dart:convert';

import 'package:app_kosmetik/PageNavigation.dart';
import 'package:app_kosmetik/PageRegister.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  // bool isLoading = true;
  bool isLoading = false;
  bool _obscureText = true;

  // Definisi regex untuk memeriksa format email
  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    final email = txtEmail.text;
    final password = txtPassword.text;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/login'),
        body: {
          "email": email,
          "password": password,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', txtEmail.text);
          prefs.setString('password', txtPassword.text);
          prefs.setString('username', responseData['username']);
          prefs.setString('first_name', responseData['first_name']);
          prefs.setString('last_name', responseData['last_name']);
          prefs.setString('phone', responseData['phone']);
          prefs.setString('address', responseData['address']);
          prefs.setString('role', responseData['role']);
          prefs.setString('token', responseData['token']);
          // prefs.setString('email_verified_at', responseData['email_verified_at']);
          // prefs.setInt('id', responseData['id']);
          prefs.setInt('id_user', responseData['id']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigationPage()),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Login Gagal'),
                content: Text('Email atau Password salah.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else if (response.statusCode == 401) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Login Gagal'),
              content: Text(errorResponse['message'] ??
                  'Email atau Password tidak sesuai.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi kesalahan saat melakukan login.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _forgotPassword() {
    TextEditingController txtEmail = TextEditingController();
    TextEditingController txtNewPassword = TextEditingController();
    TextEditingController txtConfirmPassword = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool _isEmailValid = false;
    bool _isLoading = false;
    bool _obscureText = true;
    bool _obscureText2 = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(_isEmailValid ? 'Reset Password' : 'Forgot Password'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isEmailValid) ...[
                      Text("Enter your email to reset your password:"),
                      TextFormField(
                        controller: txtEmail,
                        decoration: InputDecoration(
                          hintText: 'Enter email address',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email cannot be empty.';
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                    ] else ...[
                      Text("Enter your new password:"),
                      TextFormField(
                        controller: txtNewPassword,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Enter new password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password cannot be empty.';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters long.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: txtConfirmPassword,
                        obscureText: _obscureText2,
                        decoration: InputDecoration(
                          hintText: 'Confirm new password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText2
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText2 = !_obscureText2;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value != txtNewPassword.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
              ),
              actions: <Widget>[
                if (!_isEmailValid) ...[
                  TextButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      final email = txtEmail.text;

                      try {
                        final response = await http.post(
                          Uri.parse('http://127.0.0.1:8000/api/check-email'),
                          body: {'email': email},
                        );

                        // Log the response body
                        print('Response status: ${response.statusCode}');
                        print('Response body: ${response.body}');

                        final Map<String, dynamic> responseData =
                            json.decode(response.body);

                        if (response.statusCode == 200 &&
                            responseData['status'] == true) {
                          setState(() {
                            _isEmailValid = true;
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text(responseData['message'] ??
                                  'Email not found.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (error) {
                        print('Error: $error');

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content:
                                Text('An error occurred while checking email.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                ] else ...[
                  TextButton(
                    child: Text('Reset Password'),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        final response = await http.post(
                          Uri.parse('http://127.0.0.1:8000/api/reset-password'),
                          body: {
                            'email': txtEmail.text,
                            'password': txtNewPassword.text,
                            'password_confirmation': txtConfirmPassword.text,
                          },
                        );

                        // Log the response body
                        print('Response status: ${response.statusCode}');
                        print('Response body: ${response.body}');

                        final Map<String, dynamic> responseData =
                            json.decode(response.body);

                        if (response.statusCode == 200 &&
                            responseData['status'] == true) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Success'),
                              content:
                                  Text('Password has been reset successfully.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text(responseData['message'] ??
                                  'Failed to reset password.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (error) {
                        print('Error: $error');

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(
                                'An error occurred during password reset.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                ],
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: 640,
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
                  Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      // child: IconButton(
                      //   onPressed: () {
                      //     Navigator.pushAndRemoveUntil(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => PageRegister()),
                      //         (route) => false);
                      //   },
                      //   icon: Container(
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       border: Border.all(
                      //         color: Colors.white,
                      //         width: 2,
                      //       ),
                      //     ),
                      //     child: Icon(
                      //       Icons.arrow_back,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 40,
                    right: 40,
                    bottom: 100,
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
                            topLeft: Radius.circular(
                                30.0), // Melengkungkan ujung kiri atas
                            bottomRight: Radius.circular(
                                30.0), // Melengkungkan ujung kanan bawah
                            topRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                          ),
                        ),
                        color: Colors.white,
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Center(
                                child: Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    color: Color(0xFF424252),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    // fontFamily: 'Open Sans',
                                  ),
                                ),
                              ),
                              ListTile(
                                contentPadding:
                                    EdgeInsets.fromLTRB(35, 10, 20, 0),
                                subtitle: Text(
                                  'Hello there, Sign In to continue!',
                                  style: TextStyle(
                                    color: Color(0xffA9A297),
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 5, top: 0, bottom: 5, left: 5),
                                // padding: EdgeInsets.all(10),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 350,
                                  child: Form(
                                    key: keyForm,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return "Tidak Boleh kosong";
                                            } else if (!emailRegex
                                                .hasMatch(val)) {
                                              return "ex: ex@mail.com";
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

                                        //passwordField
                                        SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
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

                                        // forgot password
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: _forgotPassword,
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF424252),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              //button
                              SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                onPressed: isLoading ? null : () => _login(),
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : Text(
                                        'Sign In',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  backgroundColor: Color(0xFF424252),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: Size(260, 40),
                                ),
                              ),

                              // manual button
                              // ElevatedButton(
                              //   onPressed: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => BottomNavigationPage()));
                              //   },
                              //   child: Text(
                              //     'Sign In',
                              //     style: TextStyle(
                              //       fontSize: 16,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              //   style: ElevatedButton.styleFrom(
                              //     padding: EdgeInsets.symmetric(horizontal: 20),
                              //     backgroundColor:
                              //         Color(0xFF424252),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(10),
                              //     ),
                              //     minimumSize: Size(260, 40),
                              //   ),
                              // ),

                              //link
                              SizedBox(
                                height: 15,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(
                                      color: Color(0xFF424252),
                                    ),
                                    children: [
                                      TextSpan(
                                          text: 'Sign up',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PageRegister()));
                                            },
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold))
                                    ]),
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
