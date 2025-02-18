

import 'package:appkey_flutter_demo/models/app_user.dart';
import 'package:appkey_flutter_demo/providers/app_provider.dart';
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


  var _message = '';
  var _errorMessage = '';
  var _isSending = false;

  final List<int> colorCodes = <int>[600, 500, 600, 500, 100, 600, 500, 100, 100];
 
  void _updateKey(item){
     
    showModalBottomSheet(
      context: context,
      builder: (ctx) => EditPasskey(passkey:item),
    );
  }

  void _deleteKey(item){

  }


  Widget renderKey (item){
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Row( 
          children: [ 
            Text('- ${item.name}', style: TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              onPressed: () =>_updateKey(item),
              icon: const Icon(Icons.edit),
            ),
            const SizedBox(height: 30),
            IconButton(
              onPressed: () => _deleteKey(item),
              icon: const Icon(Icons.delete_outline),
            ),
            const SizedBox(height: 30),
            
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
      body: 
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Column(
              children: [ 
                const SizedBox(height: 12),
                if(_message != "") Text(_message, style: TextStyle(color: Colors.blueAccent, fontSize: 16),),
                if(_errorMessage != "") Text(_errorMessage, style: TextStyle(color: Colors.redAccent, fontSize: 16)),
 
                Text(" Display Name: ${user.displayName}", style: TextStyle(color: Colors.blueAccent, fontSize: 16)), 
               
                Text("Your Passkeys: ${user.authenticators.length}", style: TextStyle(fontWeight: FontWeight.bold),),
                 
              ]
            ),  
            Column( 
              children: authenticators.map((item) => renderKey(item)  ).toList(),
            
            ),  

            //PasskeysList(),
            
               
          ]
        )

      )
      );
     
  }
}