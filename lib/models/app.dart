 

class AppModel {
  final String appId;
  final String displayAppId;
  final String name;
  final String userId;
  final String status; 
  final String handleType;  
  final String appToken;
  final String signup;
  final bool anonymousLoginEnabled;
  final bool userNamesEnabled; 
  final bool appleLoginEnabled;
  final String? appleBundleId;
  final bool googleLoginEnabled;
  final String? googleClientId;
  final String relyPartyId;
  final String? androidApkKey;
  final  List <String> locales;
 


  AppModel( {
    required this.appId,
    required this.displayAppId,
    required this.name,
    required this.userId,
    required this.status,
    required this.handleType,
    required this.appToken,
    required this.signup,
    required this.anonymousLoginEnabled, 
    required this.userNamesEnabled,
    required this.appleLoginEnabled,
    this.appleBundleId,
    required this.googleLoginEnabled,
    this.googleClientId,
    required this.relyPartyId,
    this.androidApkKey,
    required this.locales,
  }
  );

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
          appId: json['appId'],
          displayAppId: json['displayAppId'],
          name: json['name'],
          userId: json['userId'],
          status: json['status'],
          handleType: json['handleType'],
          appToken: json['appToken'],
          signup: json['signup'],
          anonymousLoginEnabled: json['anonymousLoginEnabled'],
          userNamesEnabled: json['userNamesEnabled'],
          appleLoginEnabled:json['appleLoginEnabled'],
          appleBundleId:json['appleBundleId'],
          googleLoginEnabled: json['googleLoginEnabled'],
          googleClientId: json['googleClientId'],
          relyPartyId: json['relyPartyId'],
          androidApkKey: json['androidApkKey'],

          locales: json['locales'] != null
          ? (json['locales'] as List)
              .map((item) => item.toString() )
              .toList()
          : [],

 
    );
  }

}
 