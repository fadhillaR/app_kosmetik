import 'dart:convert';

import 'package:app_kosmetik/PageLogin.dart';
import 'package:app_kosmetik/PageNavigation.dart';
import 'package:app_kosmetik/PageRegister.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class PageVerif extends StatefulWidget {
  final String email;

  const PageVerif({Key? key, required this.email}) : super(key: key);
  // const PageVerif({super.key});

  @override
  State<PageVerif> createState() => _PageVerifState();
}

class _PageVerifState extends State<PageVerif> {
  final TextEditingController _otpController = TextEditingController();


  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/verify-code'),
      body: {
        'email': widget.email,
        'otp': _otpController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final status = responseData['status'];

      if (status == true) {
        // OTP verification successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email berhasil diverifikasi'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PageLogin()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP tidak valid atau telah kadaluarsa'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verifikasi OTP gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PageRegister()),
              (route) => false,
            );
          },
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFF424252),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF424252),
            ),
          ),
        ),
        toolbarHeight: 50,
        backgroundColor: Color(0xFFE6E6E6),
        title: Text(
          'Verification',
          style: TextStyle(
            color: Color(0xFF424252),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: 600,
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
              padding: EdgeInsets.all(20),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 100,
                        color: Color(0xFF424252),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Verification Code',
                        style: TextStyle(
                          color: Color(0xFF424252),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'We have sent your verification code to your email',
                        style: TextStyle(
                          color: Color(0xFF424252),
                          fontSize: 14,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _otpController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter verification code',
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _verifyOTP();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          backgroundColor: Color(0xFF424252),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(300, 40),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                    ],
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
