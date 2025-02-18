
 
import 'dart:convert';

import 'package:appkey_flutter_demo/models/appkey_error.dart';

 
 

class ErrorHandler{ 
 

  static getFailureFromResponse(dynamic response) {  
    
    if (response.statusCode != 200) {   
      final data = jsonDecode(response.body);  
      throw AppkeyError.fromJson(data);
    }
 
  } 

  static AppkeyError defaultError() {  
    throw AppkeyError.defaultError(); 
  } 

}