

 
import 'package:appkey_flutter_demo/providers/app_provider.dart';
import 'package:appkey_flutter_demo/screens/logged_in_screen.dart';
import 'package:appkey_webauthn_flutter/appkey_webauthn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appkey_flutter_demo/auth_service.dart';
import 'package:appkey_flutter_demo/screens/authentication_screen.dart';
import 'package:flutter/material.dart';
 


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (AuthService.credentialManager.isSupportedPlatform) { //check if platform is supported
    await AuthService.credentialManager.init(
      preferImmediatelyAvailableCredentials: true,
    );
  } 
  
  runApp(const ProviderScope(child:  MyApp()));
}
 
class MyApp extends ConsumerWidget {

  const MyApp({super.key});  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    
    UserModel user = ref.watch(userProvider); 
    
    return MaterialApp(
      title: 'AppKey Flutter Demo',
      theme: ThemeData( 
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 70, 56, 171)),
        useMaterial3: true,
      ),
      home: user.appUserId != "" ? LoggedInScreen() :  AuthenticationScreen()
        
      
     
    );
  }
}
 