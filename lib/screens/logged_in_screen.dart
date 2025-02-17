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
  @override
  Widget build(BuildContext context) {

    Widget activePage = ProfileScreen(); 

    return Scaffold(
      appBar: AppBar( ),
      body: activePage,
    );
  }
}