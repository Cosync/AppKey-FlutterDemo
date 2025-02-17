

 

import 'package:appkey_flutter_demo/models/app.dart';
import 'package:appkey_flutter_demo/models/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppNotifier extends StateNotifier <AppModel> {

  AppNotifier() : super(AppModel(appId: "", displayAppId: "", name: "", userId: "", status: "", handleType: "", appToken: "", signup: "", anonymousLoginEnabled: false, userNamesEnabled: false, appleLoginEnabled: false, googleLoginEnabled: false, relyPartyId: "", locales: []));

  void addApp(AppModel app){ 
    state = app;
  } 
 
   
} 


final appProvider = StateNotifierProvider < AppNotifier, AppModel> (
  (ref) => AppNotifier(),
);



class UserNotifier extends StateNotifier <UserModel> {

  UserNotifier() : super(   UserModel(handle: "", displayName: "", status: "", appUserId: "", appId: "", authenticators: [], locale: "", loginProvider: "", accessToken: ""));

  void addUser(UserModel user){ 
    state = user;
  } 

  void updateUser(String key, String value){ 
    final userJson = state.toJson(); 

    userJson[key] = value;

    state = UserModel.fromJson(userJson);

  } 
   

  void logout(){ 
    state = UserModel(handle: "", displayName: "", status: "", appUserId: "", appId: "", authenticators: [], locale: "", loginProvider: "", accessToken: "");
  }  
   
} 


final userProvider = StateNotifierProvider < UserNotifier, UserModel> (
  (ref) => UserNotifier(),
);

  