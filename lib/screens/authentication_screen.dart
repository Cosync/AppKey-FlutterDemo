 
import 'package:appkey_flutter_demo/auth_service.dart';
import 'package:appkey_flutter_demo/providers/app_provider.dart';
import 'package:appkey_flutter_demo/screens/login_screen.dart';
import 'package:appkey_flutter_demo/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
 
import 'dart:developer';


class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  ConsumerState<AuthenticationScreen> createState() {
    return _AuthenticationScreen();
  }  

}


class _AuthenticationScreen extends ConsumerState<AuthenticationScreen> {

 int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

 

 @override
  void initState() {

    super.initState();
    log(" authentication initState");

    AuthService.getApp().then((app) => {  
      ref.read(appProvider.notifier).addApp(app)  
      
    });

    
  }

  @override
  Widget build(BuildContext context) { 

    Widget activePage = LoginScreen();
    

    if (_selectedPageIndex == 1) {
      activePage = SignupScreen(); 
    }

    return Scaffold(
      appBar: AppBar( ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.login_outlined),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1_outlined),
            label: 'Signup',
          ),
        ],
      ),
    );
}
}