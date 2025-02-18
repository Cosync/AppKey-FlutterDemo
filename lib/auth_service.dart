

import 'dart:convert';
import 'dart:developer';
import 'package:appkey_flutter_demo/error_handler.dart';
import 'package:appkey_flutter_demo/models/app.dart';
import 'package:appkey_flutter_demo/models/app_user.dart';
import 'package:appkey_flutter_demo/models/appkey_error.dart';
import 'package:credential_manager/credential_manager.dart';
import 'package:http/http.dart' as http;
 

// https://dev.to/djsmk123/unlocking-the-future-passwordless-authenticationpasskey-with-flutter-and-nodejs-1ojh
class AuthService {
  // Base URL for the API 
  static const String _apiUrl = String.fromEnvironment('API_URL', defaultValue: "https://api.appkey.io");
  static const String _appToken = String.fromEnvironment('APP_TOKEN',
      defaultValue: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJlN2Y2OWU3ZS01NWJiLTQzY2EtYTE4ZC02ODFkNGI0ZDI1MzciLCJhcHBJZCI6IjA2YTk3NmE4ZDExYjRkOTM5MjY4MTA0NzdmNWYyZDJlIiwic2NvcGUiOiJhcHAiLCJpYXQiOjE3MzMxNTA2OTd9.Dl2pEnxpcaLK8l_wor-XQBwb50TlC2MRCRyQVM3hAVn34wLxxdZOms-5xeVtIN7EIv_mP3BHN9vpTHu679HcsBZ5jWQNbfztzZX5h-FM0IanWHFPp6vihBoyWsRcWOwNHoPdgqNjeihkGfRWjXvpKQXRZv2qErpv4Lb2ferOu1rDkO4P_ghAmgflW2y9jm_UaXmd5Mt05WuVO3pFUyRjjdAgV23yTYYMSLeM3aZ4owOroZmAspNSFG7QWiotPK4itvb2qei1HASo9H5WYWjX3Ul09Sz5DROiPS-6wlWcIwLaYzCOa96O76O_qdFig0Qu9C-Xohn6ald1dCpSj97sPKlghOu-_k_5pvVRttQhpP0P1KbTPA-FMTQwRIhFmejAZQLrrKN2GAfCPgR3jn5zD8aAggCnSUVv2B_c1E-hdAuCuHJR2Q5btSjwnagZ4rVyzG8wy5bK9MkUslsnne8tcHkZQk8cOY3od5rVW2XZeH88h0R6kzm8snWqoqOCoFIV"
  );


    static String base64ToBase64Url(String base64) {
      // Replace '+' with '-', '/' with '_'
      String base64Url = base64.replaceAll('+', '-').replaceAll('/', '_');

      // Remove padding characters ('=')
      base64Url = base64Url.replaceAll('=', '');

      return base64Url;
    }

    static String base64UrlToBase64(String base64Url) {
      // Replace '-' with '+' and '_' with '/'
      String base64 = base64Url.replaceAll('-', '+').replaceAll('_', '/');

      // Add padding characters if necessary
      switch (base64.length % 4) {
        case 2:
          base64 += '==';
          break;
        case 3:
          base64 += '=';
          break;
      }

      return base64;
    }

  static  _apiRequest(String method, String endpoint, data, String? accessToken, String? signupToken  ) async{ 
    
    var headers = {
      'Content-Type': 'application/json' 
    };

    if(accessToken != "" && accessToken != null) { headers['access-token'] = accessToken; }
    else if (signupToken != "" && signupToken != null){ headers['signup-token'] = signupToken; }
    else { headers['app-token'] = _appToken; }

     

      if(method == "GET"){
        final response = await http.get(
          Uri.parse("$_apiUrl/$endpoint"),
          headers: headers,
        ); 

        ErrorHandler.getFailureFromResponse(response);

        return response;
      }

      final params = data ?? {};
      final response = await http.post(
        Uri.parse("$_apiUrl/$endpoint"),
        body: jsonEncode(params),
        headers: headers,
      );

      ErrorHandler.getFailureFromResponse(response);

      return response;

    
    
  }


  static Future<AppModel> getApp() async{
    
      final response = await _apiRequest("GET", "api/appuser/app", null, null, null);
      final decode = jsonDecode(response.body);   
      return AppModel.fromJson(decode); 
   
  }


  static Future<CredentialCreationOptions> signup( String handle,  String displayName) async{

    final response = await _apiRequest("POST", "api/appuser/signup", {'handle': handle, 'displayName':displayName}, null, null);
    final decode = jsonDecode(response.body);  
    
    decode['challenge'] = base64UrlToBase64(decode['challenge']);  
    return CredentialCreationOptions.fromJson( decode); 

   
    
  }


  static Future < Map<String,dynamic> > signupConfirm( String handle , PublicKeyCredential request ) async{ 

    Map<String, dynamic> body = {
      'handle': handle, 
    };

    body.addAll(request.toJson()); 

  
    final response = await _apiRequest("POST", "api/appuser/signupConfirm", body, null, null); 
    final decode = jsonDecode(response.body); 
    
    return decode;

    
  }

  static Future < UserModel > signupComplete( String code , String signupToken ) async{  

    try {
      final response = await _apiRequest("POST", "api/appuser/signupComplete", {"code":code}, null, signupToken); 
      

      final decode = jsonDecode(response.body);

      
      return UserModel.fromJson(decode);

    } catch (e) {
        throw Exception(e);
    }
  }

  // Initialize passkey login
  static Future<CredentialLoginOptions> login(String handle) async {

    final response = await _apiRequest("POST", "api/appuser/login", {'handle': handle}, null, null);  
    final decode = jsonDecode(response.body); 
     
    decode['challenge'] = base64UrlToBase64(decode['challenge']); 
    final result =  CredentialLoginOptions.fromJson(decode); 
    return result;
  }


  // Initialize passkey loginComplete
  static Future<UserModel> loginComplete(String handle,  PublicKeyCredential request) async {

    Map<String, dynamic> body = {
    'handle': handle, 
    }; 
    body.addAll(request.toJson()); 

    final response = await _apiRequest("POST", "api/appuser/loginComplete", body, null, null); 

    final decode = jsonDecode(response.body);
    
    log("Response from passkey login complete init: ${decode.toString()}");
    return UserModel.fromJson(decode);

  }


  
  static Future<CredentialCreationOptions> loginAnonymous( String handle) async{

    final response = await _apiRequest("POST", "api/appuser/loginAnonymous", {'handle': handle}, null, null); 
    final decode = jsonDecode(response.body);  
    decode['challenge'] = base64UrlToBase64(decode['challenge']);  
    return CredentialCreationOptions.fromJson(decode);
  }


  static Future < Map<String,dynamic> > loginAnonymousComplete( String handle , PublicKeyCredential request ) async{ 

    Map<String, dynamic> body = {
    'handle': handle, 
    };

    body.addAll(request.toJson()); 

    try {
      final response = await _apiRequest("POST", "api/appuser/loginAnonymousComplete", body, null, null); 
      final decode = jsonDecode(response.body);
 
      return decode;

    } catch (e) {
       throw Exception(e);
    }
  }



  static Future<bool> setUserName(String userName, String accessToken) async {
    
    final response = await _apiRequest("POST", "api/appuser/setUserName", {"userName":userName}, accessToken, null); 
    final decode = jsonDecode(response.body); 
    return decode;
  }



  static Future<bool> updateProfile(String displayName, String accessToken) async {
    
    final response = await _apiRequest("POST", "api/appuser/updateProfile", {"displayName":displayName}, accessToken, null); 
     
    final decode = jsonDecode(response.body);
    
    return decode;
  }



  static Future<UserModel> setLocale(String locale, String accessToken) async {

    final response = await _apiRequest("POST", "api/appuser/setLocale", {"locale":locale}, accessToken, null); 
    final decode = jsonDecode(response.body);
    return UserModel.fromJson(decode);
  }



  static Future<Map<String, dynamic>> userNameAvailable(String userName, String accessToken) async {
    
    final response = await _apiRequest("GET", "api/appuser/userNameAvailable?userName=$userName", null, accessToken, null); 
    return jsonDecode(response.body);
 
  }



  static Future<Map<String, dynamic>> socialLogin(Map <String, dynamic> data) async {
    
    final response = await _apiRequest("POST", "api/appuser/socialLogin", data, null, null);  
    final decode = jsonDecode(response.body);
    return decode;
  }


  static Future<Map<String, dynamic>> socialSignup(Map <String, dynamic> data) async {
    

    final response = await _apiRequest("POST", "api/appuser/socialSignup", data, null, null); 
    final decode = jsonDecode(response.body);
    return decode;
  }


  static Future<Map<String, dynamic>> verifySocialAccount(Map <String, dynamic> data) async {
    
    final response = await _apiRequest("POST", "api/appuser/verifySocialAccount", data, null, null);  
    final decode = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(AppkeyError.fromJson(decode));
    }

    
    return decode;
  }




  static Future<Map<String, dynamic>> verify(Map <String, dynamic> data) async {
    
    final response = await _apiRequest("POST", "api/appuser/verify", data, null, null);   
    
    final decode = jsonDecode(response.body);
    return decode;
  }


  static Future<Map<String, dynamic>> verifyComplete(Map <String, dynamic> data) async {
    
    final response = await _apiRequest("POST", "api/appuser/verifyComplete", data, null, null);   

    final decode = jsonDecode(response.body);
    return decode;
  }
 


  // Instance of CredentialManager
  static CredentialManager credentialManager = CredentialManager();
}