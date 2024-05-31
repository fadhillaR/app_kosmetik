import 'package:app_kosmetik/HomePage.dart';
import 'package:app_kosmetik/navigation/PageFav.dart';
import 'package:app_kosmetik/navigation/PageOrder.dart';
import 'package:app_kosmetik/navigation/PageProfil.dart';
import 'package:flutter/material.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});
  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
          controller: tabController,
          children: const [PageMulai(), PageOrder(), PageFav(), PageProfil()]),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(5), bottom: Radius.circular(5)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TabBar(
                isScrollable: true,
                labelColor: 
                          Color.fromARGB(255, 85, 77, 181),
                unselectedLabelColor: Color.fromARGB(255, 110, 97, 255),
                controller: tabController,
                tabs: [
                  Tab(
                    icon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust spacing here
                      child: Icon(Icons.home_outlined),
                    ),
                  ),
                  Tab(
                    icon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust spacing here
                      child: Icon(Icons.receipt),
                    ),
                  ),
                  Tab(
                    icon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust spacing here
                      child: Icon(Icons.favorite),
                    ),
                  ),
                  Tab(
                    icon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust spacing here
                      child: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 0),
            ],
          ),
        ),
      ),
    );
  }
}


