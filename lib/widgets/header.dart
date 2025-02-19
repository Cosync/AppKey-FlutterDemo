
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget{
  const Header({super.key,  required this.message});
  final String message;


  Future<void> _launchUrl(_url) async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column( 
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
        const Spacer(),

        Text(message),

      ],
      )
    );
 
  }
}