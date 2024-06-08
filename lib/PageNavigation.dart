import 'package:app_kosmetik/HomePage.dart';
import 'package:app_kosmetik/navigation/PageFav.dart';
import 'package:app_kosmetik/navigation/PageOrder.dart';
import 'package:app_kosmetik/navigation/PageSetting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationPage extends StatefulWidget {
  final int initialIndex;

  const BottomNavigationPage({super.key, this.initialIndex = 0});
  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
          controller: tabController,
          children: const [PageMulai(), PageOrder(), PageFav(), PageSetting()]),
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
                unselectedLabelColor: Color(0xFF424252),
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
                      child: Icon(Icons.local_shipping),
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
                      child: Icon(Icons.settings),
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


