

 
import 'package:appkey_flutter_demo/providers/app_provider.dart';
import 'package:appkey_webauthn_flutter/appkey_webauthn_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasskeysList extends ConsumerStatefulWidget{
  const PasskeysList({super.key});

  @override
  ConsumerState<PasskeysList> createState() => _PasskeysListState();
}

class _PasskeysListState extends ConsumerState<PasskeysList> {


  final List<int> colorCodes = <int>[600, 500, 600, 500, 100, 600, 500, 100, 100];
 

  @override
  Widget build(BuildContext context) {
    final UserModel user = ref.watch(userProvider);  

    return Scaffold(
      body: ListView.builder(
        itemCount: user.authenticators.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(user.authenticators[index].name),
          leading: Container(
            width: 24,
            height: 24,
            color: Colors.amber[colorCodes[index]],
          ),
          trailing: Text(
            user.authenticators[index].platform,
          ),
        ),
      ),
    );
  }

}