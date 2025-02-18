import 'package:appkey_flutter_demo/screens/passkey_screen.dart';
import 'package:appkey_flutter_demo/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class LoggedInScreen extends StatefulWidget{
  
  const LoggedInScreen({super.key});

  @override
  State<LoggedInScreen> createState() {
    return _LoggedInScreen();
  }  
}

class _LoggedInScreen extends State<LoggedInScreen> {

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget activePage = ProfileScreen(); 

    if (_selectedPageIndex == 1) {
      activePage = PasskeyScreen(); 
    }

    return Scaffold(
      appBar: AppBar( ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.key_outlined),
            label: 'Passkey',
          ),
        ],
      ),
    );
  }
}