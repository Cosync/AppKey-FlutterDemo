import 'dart:convert';

import 'package:credential_manager/credential_manager.dart';

class SingupChallenge{


  final PublicKeyCredential credential; 

  SingupChallenge({
    required this.credential
  }) ;

  factory SingupChallenge.fromJson(Map<String, dynamic> json){

    json['challenge'] =  base64Url.encode(json['challenge']);
    return SingupChallenge(
       credential:json as PublicKeyCredential
    );
  }



  /// Convert PublicKeyCredential to JSON.
  Map<String, dynamic> toJson() {
    return {
      'rawId': credential.rawId,
      'authenticatorAttachment': credential.authenticatorAttachment,
      'type': credential.type,
      'id': credential.id,
      'response' : credential.response?.toJson(),
      'transports': credential.transports,
      'clientExtensionResults': credential.clientExtensionResults?.toJson(),
      'publicKeyAlgorithm': credential.publicKeyAlgorithm,
      'publicKey': credential.publicKey,
    };
  }
 

  
}