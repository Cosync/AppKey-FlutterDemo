 
import 'package:appkey_flutter_demo/auth_service.dart'; 
import 'package:appkey_flutter_demo/models/appkey_error.dart';
import 'package:appkey_flutter_demo/providers/app_provider.dart';
import 'package:appkey_webauthn_flutter/appkey_webauthn_flutter.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPasskey extends ConsumerStatefulWidget {

  const EditPasskey({super.key, required this.passkey, required this.user, this.child});
  final Authenticator passkey; 
  final UserModel user;  
  final Widget? child;    

  @override
    ConsumerState<EditPasskey> createState() {
      return _EditPasskey();
    }
}

class _EditPasskey extends ConsumerState<EditPasskey> { 
  
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _errorMessage = '';
  var _isSending = false;
 
  

 @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(appProvider);
  }

  void _updateKeyName(context) async{

     if (!_formKey.currentState!.validate()){ 
      setState(() { 
        _errorMessage = "Please enter key name";
      });

      return; 
    } 

    _formKey.currentState!.save();

     setState(() { 
        _isSending = true;
      });

    final auth = widget.user.authenticators.where((item) => item.name == _enteredName);
    if(auth.isNotEmpty){
      setState(() { 
        _errorMessage = "Key name is in used.";
      });
      return;
    }

    final checked = await _verifyAccount();

    if(checked ){  
      final UserModel user = ref.watch(userProvider);  

      final UserModel newUser = await AuthService.updatePasskey(widget.passkey.id, _enteredName, user.accessToken);
      ref.read(userProvider.notifier).addUser(newUser);

      Navigator.pop(context);
    } 

  }

  Future <bool> _verifyAccount() async{
    try {
      setState(() { 
        _isSending = true; 
        _errorMessage = "";
      });

      final result = await AuthService.verify(widget.user.handle); 
      final credResponse = await AuthService.credentialManager.getCredentials(
        passKeyOption: CredentialLoginOptions(
          challenge: result.challenge,
          rpId: result.rpId,
          userVerification: result.userVerification,
        ),
      );

      if (credResponse.publicKeyCredential != null) {
        final user = await AuthService.verifyComplete(widget.user.handle, credResponse.publicKeyCredential!);
 
        if (user.accessToken != "") {
          ref.read(userProvider.notifier).addUser(user);

          return true;
        }
      }

      return false;

    } on AppkeyError catch (e) {

      _errorMessage = e.message;
       return false;
    } catch (e) {

      _errorMessage = 'Internal Server Error: $e';
      return false;
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
     Widget content = Padding(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey, 
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Key Name'),
              ),
              maxLength: 50, 
              initialValue: widget.passkey.name,
              validator: (value) {
                if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters.';
                    }
                return null;
              },
              onSaved: (value) {
                _enteredName = (value!);
              },
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed:  () => { _isSending ? null : _updateKeyName(context) },
                  child: _isSending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Update'),
                ),

                
              ],
            ),
             const SizedBox(height: 16),
            if(_errorMessage != "") Text(_errorMessage, style: TextStyle(color: Colors.redAccent, fontSize: 16)),

          ]
          
          )
        ), 
     );
     
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.passkey.name),
      ),
      body: content,
    );

  }


}

 
 

