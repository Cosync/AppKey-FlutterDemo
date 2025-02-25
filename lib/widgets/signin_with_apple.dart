

import 'package:appkey_flutter_demo/auth_service.dart'; 
import 'package:appkey_flutter_demo/models/appkey_error.dart';
import 'package:appkey_webauthn_flutter/appkey_webauthn_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:developer';

 

class SignInWithAppleWidget extends StatelessWidget {
  const SignInWithAppleWidget({super.key, required this.onAppleLogin});
 
  final void Function(UserModel user) onAppleLogin;
   

  Future<void> _signUpWithApple(AuthorizationCredentialAppleID credential) async {
    try { 

      final displayName = "${credential.givenName} ${credential.familyName}";
      final token = credential.identityToken;
      final user = await AuthService.socialSignup({"token":token, "displayName":displayName, "handle":credential.email, "provider":"apple"});
    
      // send user back to parent screen
      onAppleLogin(user);

    } on AppkeyError catch (e) {
      
      log(e.message);

    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    
    try {
     
     
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
       
      );
     
      
      log('User Token: ${credential.identityToken}');
      log('Email: ${credential.email}');
      log('Given Name: ${credential.givenName}');
      log('Family Name: ${credential.familyName}');
      
      try { 
        final user = await AuthService.socialLogin({"token":credential.identityToken, "provider": "apple"});
        
        // send user back to parent screen
        onAppleLogin(user);

      } on AppkeyError catch (e) {
        if(e.code == 603){
          if(credential.givenName != null && credential.familyName != null)  { 
             _signUpWithApple(credential);
          }
          else if (context.mounted) {
            final errorMessage = "App cannot access to your profile name. Please remove this AppKey in 'Sign with Apple' from your icloud setting and try again.";
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage, style: TextStyle(color: const Color.fromARGB(255, 194, 112, 112)),)),
            );
          }
        }
        else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message, style: TextStyle(color: const Color.fromARGB(255, 194, 112, 112)),))
          );
        }
        log('Error AuthService.socialLogin: $e'); 
      }

    } catch (e) {
      // Handle errors
      log('Error signing in with Apple: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in with Apple.', style: TextStyle(color: const Color.fromARGB(255, 194, 112, 112)),)),
        );
      }
    }
  }

  
  
  @override
  Widget build(BuildContext context) {
    return SignInWithAppleButton(
      onPressed: () => _signInWithApple(context),
    );
  }

}