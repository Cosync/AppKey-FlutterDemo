
 
import 'package:appkey_flutter_demo/models/appkey_error.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:appkey_flutter_demo/auth_service.dart';
import 'package:appkey_flutter_demo/models/app.dart';
import 'package:appkey_flutter_demo/models/app_user.dart';
import 'package:appkey_flutter_demo/providers/app_provider.dart';
import 'package:flutter/material.dart';
 
 


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() {
    return _ProfileScreen();
  }
}


class _ProfileScreen extends ConsumerState<ProfileScreen> {

  var _message = '';
  var _errorMessage = '';
  var _isSending = false;
  var _enteredUsername = '';
  var _enteredName = '';
  final _formKey = GlobalKey<FormState>();
  
  
  void _updateProfile(ref, UserModel user) async{ 

     if (!_formKey.currentState!.validate()){ 
      setState(() { 
        _errorMessage = "Please enter all required fields";
      });

      return; 
    } 

    _formKey.currentState!.save();

    setState(() {
      _isSending = true;
      _message = "";
      _errorMessage = "";
    });

    try {

      if(_enteredUsername.isNotEmpty){
        final updated = await AuthService.setUserName(_enteredUsername, user.accessToken);
        if(updated) {
          ref.read(userProvider.notifier).updateUser('userName', _enteredUsername); 
        } 
      }

      if(_enteredName != user.displayName){
        final updated = await AuthService.updateProfile(_enteredName, user.accessToken);
        if(updated) { 
          ref.read(userProvider.notifier).updateUser('displayName', _enteredName);
        }
      }

    } on AppkeyError catch (error) {  

      setState(() {
        _errorMessage = error.message;
      });
     
    } catch (e) {
      // No specified type, handles all
      _errorMessage = 'Something really unknown: $e';
    }
    finally{
      setState(() {
        _isSending = false; 
      });
    }
   
   

  }

  void _logout(ref){
    ref.read(userProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) {

    final UserModel user = ref.watch(userProvider);  
    final AppModel app = ref.watch(appProvider);  

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("Success! You’ve Logged into the AppKey Demo. Congratulations on using your passkey—how simple was that? No passwords, no MFA, no cheat sheets—just effortless, secure login. Sign up for AppKey today to bring this seamless passwordless authentication to your mobile or web app!"),
            const SizedBox(height: 12),

            Text( "Welcome: ${user.displayName} "),
            Text(  "Hanlde: ${user.handle} " ),
            if(user.userName != null) Text(  "Hanlde: ${user.userName} " ),

            const SizedBox(height: 12),
            if(_message != "") Text(_message, style: TextStyle(color: Colors.blueAccent, fontSize: 16),),
            if(_errorMessage != "") Text(_errorMessage, style: TextStyle(color: Colors.redAccent, fontSize: 16)),


            Form(
              key: _formKey,
              child: Column(
              children: [
                TextFormField(
                  initialValue: user.displayName,
                  maxLength: 50, 
                  decoration: const InputDecoration(
                    label: Text('Display Name'),
                  ),
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
                    _enteredName = value!;
                  },
                ),

                if(app.userNamesEnabled && user.userName == "" || user.userName == null)  ...[
                  TextFormField(
                      maxLength: 50,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        label: Text('User Name'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 50) {
                          return 'Must be between 1 and 50 characters.';
                        }
                        return null;
                      },
                      onChanged: (text) async{
                        
                        final check = await AuthService.userNameAvailable(text, user.accessToken);
                        if(!check['available']) {
                          setState(() {
                            _errorMessage = "$text is already existed.";
                          });
                        }
                        else{
                          setState(() {
                            _enteredUsername = text;
                          });
                        }
                      },
                      onSaved: (value) {
                        _enteredUsername = value!;
                      },
                    ),

                ],

                 const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed:  () => { _isSending ? null : _updateProfile(ref, user) },
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Update'),
                  ),

                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed:  () => {  _logout(ref) },
                    child: const Text('Logout'),
                  ),
              ],
            ))
           
          ]
        ),
      ),
    );
  }
}
