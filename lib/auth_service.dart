 
 
import 'package:appkey_webauthn_flutter/appkey_webauthn_flutter.dart'; 
import 'package:appkey_flutter_demo/config.dart';

// https://dev.to/djsmk123/unlocking-the-future-passwordless-authenticationpasskey-with-flutter-and-nodejs-1ojh
class AuthService {
  // Base URL for the API 

  static AppkeyWebAuthn appkeyInstance = AppkeyWebAuthn(appToken, apiUrl); 
   
 
  static Future<AppModel> getApp() async {
    final app = appkeyInstance.getApp();
    return app;
  }

  static Future<CredentialCreationOptions> signup(
      String handle, String displayName) async {
    final response = appkeyInstance.signup(handle, displayName);
    return response;
  }

  static signupConfirm(
      String handle, PublicKeyCredential request) async { 
    final response = appkeyInstance.signupConfirm(handle, request);
    return response;

    
  }

  static Future<UserModel> signupComplete(
      String code, String signupToken) async {

    return appkeyInstance.signupComplete(code, signupToken); 
  }

  // Initialize passkey login
  static Future<Map<String, dynamic>> login(String handle) async {
    return appkeyInstance.login(handle);  
  }

  // Initialize passkey loginComplete
  static Future<UserModel> loginComplete(
      String handle, PublicKeyCredential request) async {

    return appkeyInstance.loginComplete(handle, request);  
 
  }

  static Future<CredentialCreationOptions> loginAnonymous(handle) async {
    return appkeyInstance.loginAnonymous(handle);  
  }

  static Future<UserModel> loginAnonymousComplete(
      String handle, PublicKeyCredential request) async {
      return appkeyInstance.loginAnonymousComplete(handle, request);  
  }

  static Future<bool> setUserName(String userName, String accessToken) async { 
    return appkeyInstance.setUserName(userName, accessToken);   
  }

  static Future<bool> updateProfile(
      String displayName, String accessToken) async {
      return appkeyInstance.updateProfile(displayName, accessToken);  
  }

  static Future<UserModel> setLocale(String locale, String accessToken) async {
    return appkeyInstance.setLocale(locale, accessToken);   
  }

  static Future<Map<String, dynamic>> userNameAvailable(
      String userName, String accessToken) async {
      return appkeyInstance.userNameAvailable(userName, accessToken);  
  }

  static Future<UserModel> socialLogin(
      Map<String, dynamic> data) async {
    return appkeyInstance.socialLogin(data);  
  }

  static Future<UserModel> socialSignup(
      Map<String, dynamic> data) async {
    return appkeyInstance.socialSignup(data);  
  }

  static Future<UserModel> verifySocialAccount(
      Map<String, dynamic> data) async {

    return appkeyInstance.verifySocialAccount(data);  
    
  }

  // Initialize passkey login
  static Future<CredentialLoginOptions> verify(String handle) async {
    return appkeyInstance.verify(handle);  
  }

  static Future<UserModel> verifyComplete(
      String handle, PublicKeyCredential request) async {

    return appkeyInstance.verifyComplete(handle, request);  
    
  }

  static Future<UserModel> updatePasskey(
      String id, String keyName, String accessToken) async {
    return appkeyInstance.updatePasskey(id, keyName, accessToken); 
  }

  static Future<CredentialCreationOptions> addPasskey(String token) async { 
    return appkeyInstance.addPasskey(token);  
  }

  static Future<UserModel> addPasskeyComplete(
      String handle, PublicKeyCredential credential, String token) async {
    return appkeyInstance.addPasskeyComplete(handle, credential, token);  
  }

  static Future<UserModel> removePasskey(
      String keyId, token) async { 

    return appkeyInstance.removePasskey(keyId, token);   
  }

  // Instance of CredentialManager
  static CredentialManager credentialManager = CredentialManager();
  

}
