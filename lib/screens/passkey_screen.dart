

import 'package:appkey_flutter_demo/models/app_user.dart';
import 'package:appkey_flutter_demo/providers/app_provider.dart';
import 'package:appkey_flutter_demo/widgets/delete_passkey.dart';
import 'package:appkey_flutter_demo/widgets/edit_passkey.dart';
import 'package:appkey_flutter_demo/widgets/passkeys_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PasskeyScreen extends ConsumerStatefulWidget {
  const PasskeyScreen({super.key});

  @override
  ConsumerState<PasskeyScreen> createState() {
    return _PasskeyScreen();
  }
}

 

class _PasskeyScreen extends ConsumerState<PasskeyScreen> { 


  final _message = '';
  final _errorMessage = '';
 

  final List<int> colorCodes = <int>[600, 500, 600, 500, 100, 600, 500, 100, 100];
 
  void _updateKey(item, user){
     
    showModalBottomSheet(
      context: context,
      builder: (ctx) => EditPasskey(passkey:item, user:user),
    );
  }

  void _deleteKey(item, user){
    showModalBottomSheet(
      context: context,
      builder: (ctx) => DeletePasskey(passkey:item, user:user),
    );
  }


  Widget renderKey (item, UserModel user){
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Row( 
          children: [ 
            if(item.name.length > 30) ...[
              Text('- ${item.name.substring(0,30)}...', style: TextStyle(fontWeight: FontWeight.bold)),
            ]
            else ...[
               Text('- ${item.name}', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
           
            const Spacer(),
            IconButton(
              onPressed: () =>_updateKey(item, user),
              icon: const Icon(Icons.edit),
            ),
            const SizedBox(width: 10),
            //if (user.authenticators.length > 1) ...[
              IconButton(
                onPressed: () => _deleteKey(item, user),
                icon: const Icon(Icons.delete_outline),
              ),
              const SizedBox(height: 20),
           //],
          ]
        )
      )
    );
    
  }

  @override
  Widget build(BuildContext context) {

    final UserModel user = ref.watch(userProvider);  
    final authenticators = user.authenticators;

    return Scaffold(
      appBar: AppBar(
         title: const Text(
          "Manage Passkey",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:  Center( 
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 12),
                if(_message != "") Text(_message, style: TextStyle(color: Colors.blueAccent, fontSize: 16),),
                if(_errorMessage != "") Text(_errorMessage, style: TextStyle(color: Colors.redAccent, fontSize: 16)),
 
                Text("Account Handle: ${user.handle}", style: TextStyle(color: Colors.blueAccent, fontSize: 16)), 
                const SizedBox(height: 12),
                if(user.loginProvider == "handle") ...[
                  Text("Your Passkeys: ${authenticators.length}", style: TextStyle(fontWeight: FontWeight.bold),),
                ]
                else ...[

                  Text("Your account is using Social Login Provider: ${user.loginProvider.toUpperCase()}.", style: TextStyle(fontWeight: FontWeight.bold),),
                ]
              ]
            ),  
            Column( 
              children: authenticators.map((item) => renderKey(item, user)  ).toList(),
            
            ),  

            //PasskeysList(),
            
               
          ]
        )

      )
      );
     
  }
}