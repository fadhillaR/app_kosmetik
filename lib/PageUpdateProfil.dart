import 'package:app_kosmetik/PageProfil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

class PageUpdateProfil extends StatefulWidget {
  @override
  _PageUpdateProfilState createState() => _PageUpdateProfilState();
}

class _PageUpdateProfilState extends State<PageUpdateProfil> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  String? id;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('username') ?? '';
      firstController.text = prefs.getString('first_name') ?? '';
      lastController.text = prefs.getString('last_name') ?? '';
      emailController.text = prefs.getString('email') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      addressController.text = prefs.getString('address') ?? '';
      phoneController.text = prefs.getString('phone') ?? '';
      roleController.text = prefs.getString('role') ?? '';
      // id = prefs.getString('id');
      id = prefs.getInt('id_user').toString(); // Konversi ke string
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF424252),
            ),
          ),
        ),
        toolbarHeight: 50,
        backgroundColor: Color(0xFFE6E6E6),
        title: Text(
          'Edit Akun',
          style: TextStyle(
            color: Color(0xFF424252),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            height: 750,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Card(
                        elevation: 1,
                        color: Color(0xFFFEFBFB),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Center(
                                child: Text(
                                  'Edit Profil',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return "Nama tidak boleh kosong";
                                //   }
                                // },
                                controller: usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(fontSize: 14),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return "Nama tidak boleh kosong";
                                //   }
                                // },
                                controller: firstController,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(fontSize: 14),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return "Nama tidak boleh kosong";
                                //   }
                                // },
                                controller: lastController,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  labelStyle: TextStyle(fontSize: 14),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                // validator: (val) {
                                //   if (val!.isEmpty) {
                                //     return "Tidak Boleh kosong";
                                //   } else if (!emailRegex.hasMatch(val)) {
                                //     return "ex: ex@mail.com";
                                //   }
                                //   return null;
                                // },
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(fontSize: 14),
                                ),
                                style: TextStyle(color: Colors.black),
                              ),
                              TextFormField(
                                obscureText: _obscureText,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Password tidak boleh kosong";
                                  }
                                },
                                controller: passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(fontSize: 14),
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
                                      color: Colors.black,
                                      size: 14.0,
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return "Nama tidak boleh kosong";
                                //   }
                                // },
                                controller: addressController,
                                decoration: InputDecoration(
                                  labelText: 'Alamat',
                                  labelStyle: TextStyle(fontSize: 14),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return "Nama tidak boleh kosong";
                                //   }
                                // },
                                controller: phoneController,
                                decoration: InputDecoration(
                                  labelText: 'No. HP',
                                  labelStyle: TextStyle(fontSize: 14),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'ID User: $id',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFFFEFBFB),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: roleController,
                        decoration: InputDecoration(
                          hintText: 'Role',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.transparent),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            "Simpan",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            _editProfile();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editProfile() async {
    final username = usernameController.text;
    final first_name = firstController.text;
    final last_name = lastController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final address = addressController.text;
    final phone = phoneController.text;
    final role = roleController.text;

    // Validasi jika data kosong
    if (username.isEmpty ||
        first_name.isEmpty ||
        last_name.isEmpty ||
        address.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        role.isEmpty ||
        password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text('Isi Semua Data'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('YES'),
              ),
            ],
          );
        },
      );
      return;
    } else if (!email.contains('@')) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text('Format Email tidak valid'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('YES'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getInt('id_user').toString();

      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/user-update/$id'),
        body: {
          // 'id': id,
          'username': username,
          'first_name': first_name,
          'last_name': last_name,
          'email': email,
          'password': password,
          'address': address,
          'phone': phone,
          'role': role,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Response data: $responseData');
        if (responseData['status'] == true) {
          prefs.setString('username', username);
          prefs.setString('first_name', first_name);
          prefs.setString('last_name', last_name);
          prefs.setString('email', email);
          prefs.setString('password', password);
          prefs.setString('address', address);
          prefs.setString('phone', phone);
          prefs.setString('role', role);

          // Update nilai controller
          usernameController.text = username;
          firstController.text = first_name;
          lastController.text = last_name;
          emailController.text = email;
          passwordController.text = password;
          addressController.text = address;
          phoneController.text = phone;
          roleController.text = role;

          // Navigator.pop(context, true);

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Berhasil'),
                content: Text('Data berhasil diupdate.'),
                actions: [
                  TextButton(
                    // onPressed: () => Navigator.pop(context),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => PageProfil())),
                          (route) => false);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Gagal'),
                content: Text('Gagal Edit data'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('YES'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        throw Exception('Gagal edit data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi kesalahan saat mengedit profile.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('YES'),
              ),
            ],
          );
        },
      );
    }
  }
}
