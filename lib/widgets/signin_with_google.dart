
import 'package:appkey_flutter_demo/auth_service.dart';
import 'package:appkey_flutter_demo/models/app_user.dart';
import 'package:appkey_flutter_demo/models/appkey_error.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:appkey_flutter_demo/config.dart' as config;
 
import 'package:flutter/foundation.dart';
import 'dart:developer';

const List<String> scopes = <String>[
  'email'
];
 
GoogleSignIn _googleSignIn = GoogleSignIn(
   
  clientId: "990108157672-utd6gf7eecnnd3o0uomqug6mtci0dfmo.apps.googleusercontent.com",
  scopes: scopes,
);

class SigninWithGoogle extends StatefulWidget{ 
 
  const SigninWithGoogle({super.key, required this.onGoogleLogin});

  final void Function(UserModel user) onGoogleLogin;
  
  @override
  State createState() => _SigninWithGoogle();
}

class _SigninWithGoogle extends State<SigninWithGoogle> {

 
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  

   _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
 
      bool isAuthorized = account != null;
      // However, on web...
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      } 

      if(account != null){
        //handleGoogleAuth(account); 
      }
    });

    // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
    //
    // It is recommended by Google Identity Services to render both the One Tap UX
    // and the Google Sign In button together to "reduce friction and improve
    // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
    _googleSignIn.signInSilently();

  }
 
 
  void handleGoogleAuth(GoogleSignInAccount account) async{
    try {
      
   
        final displayName = account.displayName ?? "";
        final googleAuth = await account.authentication ;
        final idToken = googleAuth.idToken ?? ""; 

        final result = await AuthService.socialLogin({"token":idToken, "provider": "google"});
        final user = UserModel.fromJson(result);
        if (context.mounted) {
          widget.onGoogleLogin(user);
        }

    } on AppkeyError catch (e) {
      if(e.code == 603) {
        _signUpWithGoogle(account);
      }
      else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message, style: TextStyle(color: const Color.fromARGB(255, 194, 112, 112)),))
          );
        }
      }

    } catch (e) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString(), style: TextStyle(color: const Color.fromARGB(255, 194, 112, 112)),))
        );
      }
    }
  }

  Future<void> _signUpWithGoogle(GoogleSignInAccount account) async {
    try { 

      final displayName = account.displayName;

      final googleAuth = await account.authentication ;
      final token = googleAuth.idToken ?? "";  
      final result = await AuthService.socialSignup({"token":token, "displayName":displayName, "handle":account.email, "provider":"google"});
      final user = UserModel.fromJson(result);
      // send user back to parent screen
      widget.onGoogleLogin(user);

    } on AppkeyError catch (e) {
      
      log(e.message);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message, style: TextStyle(color: const Color.fromARGB(255, 194, 112, 112)),))
        );
      } 
    } catch (e) {
      log(e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sign in with Google.", style: TextStyle(color: const Color.fromARGB(255, 194, 112, 112)),))
        );
      }
    }
  }

   Future<void> _handleSignIn() async {
    try {
      _googleSignIn.disconnect();

      final auth = await _googleSignIn.signIn();

      if(auth != null) { handleGoogleAuth(auth); }
      else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sign in with Google.", style: TextStyle(color: const Color.fromARGB(255, 194, 112, 112)),))
        );
      }


    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sign in with Google.", style: TextStyle(color: const Color.fromARGB(255, 194, 112, 112)),))
        );
      }
      log(error.toString());
    }
  }
   

  @override
  Widget build(BuildContext context) {
    return  
        Center( 
          child: ElevatedButton(
                 
                  onPressed: () {
                    _handleSignIn();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      //mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image: AssetImage("images/google_icon.png",),
                          height: 18.0,
                          width: 24,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 24, right: 8),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
            // Card(
            //     elevation: 5,
            //     shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10)),
            //     child: IconButton(
            //       iconSize: 40,
            //       icon: const Icon(Icons.google_sign_in), 
            //       onPressed: () async {
            //         _handleSignIn();
            //       },
            //     ),
            // ),
        );
     
  }
}