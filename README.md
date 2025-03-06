# appkey_flutter_demo

A AppKey Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



## Update xCode for apple associate domain
- open Runner.xcworkspace in ios folder
- add/update Associated Domain in Xcode properties "Signin & Capabilites" eg: webcredentials:demo.appkey.io

## To Start Appkey 
- rename lib/config_default.dart to lib/config.dart
- update API_URL and APP_TOKEN in lib/config.dart
- open an iOS simulator
- open terminal and go to root folder of this project
- run "flutter pub get"
- run "flutter run lib/main.dart"

