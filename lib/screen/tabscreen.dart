import 'package:flutter/material.dart';
import 'package:plant/screen/data.dart';
import 'package:plant/screen/homepage.dart';
import 'package:plant/screen/splashscreen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  late List _pages;
  int _selectedPageIndex = 0;
  String title = '';
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      if (_selectedPageIndex == 0) {
        title = 'Plantio';
      } else if (_selectedPageIndex == 1) {
        title = 'Data';
      }
    });
  }

  void initState() {
    _pages = [
      HomePage(),
      Data("0", "0", "0"),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Color.fromARGB(255, 79, 137, 14),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        // backgroundColor: Color.fromARGB(255, 13, 122, 69),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        //unselectedFontSize: Colors.white,
        selectedItemColor: Colors.green,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage_sharp),
            label: 'Data',
          )
        ],
      ),
    );
  }
}
