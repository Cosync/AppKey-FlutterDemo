
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget{
  const Header({super.key,  required this.message});
  final String message;


  Future<void> _launchUrl(url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

  @override
  Widget build(BuildContext context) {
    return Column( 
    children: [
      Row(
        children: [
          InkWell(
            onTap: () => _launchUrl(Uri.parse('https://cosync.io')),
            child:  Image.asset(
                  "images/cosync_bricks.png",
                  height: 100,
                  width: 100,
                ), 
          ),
          Spacer(),
          InkWell(
            onTap: () => _launchUrl(Uri.parse('https://appkey.info')),
            child:  Image.asset(
                  "images/appkey_logo.png",
                  height: 100,
                  width: 100,
                ), 
          ),
         
          
          
        ],
      ),
      const SizedBox(height: 12),
    
      Text(message),
      const SizedBox(height: 15),
    ],
    );
 
  }
}