

import 'package:appkey_flutter_demo/auth_service.dart';
import 'package:appkey_flutter_demo/models/appkey_error.dart';
import 'package:appkey_flutter_demo/providers/app_provider.dart';
import 'package:appkey_flutter_demo/widgets/header.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart'; 

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() {
    return _SignupScreen();
  }
}

class _SignupScreen extends ConsumerState<SignupScreen> {
  
  final _formKey = GlobalKey<FormState>();
  final _formKeyComfirmed = GlobalKey<FormState>();

  var _enteredHandle = '';
  var _enteredFirstName = '';
  var _enteredLastName = '';
  var _enteredCode = '';
  var _signupToken = '';
  var _message = '';
  var _errorMessage = '';
  var _isSending = false;
  var _isConfirmCode = false;   
 
  void _signup() async{

    if (!_formKey.currentState!.validate()){

      setState(() { 
        _errorMessage = "Please enter all required fields";
      });

      return; 
    } 

    _formKey.currentState!.save();

    setState(() {
      _isSending = true;
      _isConfirmCode = false;
      _message = "";
      _errorMessage = "";
    });

    try{

      var result = await AuthService.signup(_enteredHandle, _enteredFirstName, _enteredLastName);  

      final credResponse = await AuthService.credentialManager.savePasskeyCredentials(request: result);

      final attResponse = await AuthService.signupConfirm(_enteredHandle,  credResponse); 

 

      if(attResponse['signup-token'] != null){ 

        setState(() {
          _isConfirmCode = true;
          _signupToken = attResponse['signup-token'];
        });

          setState(() {
          _message = attResponse['message']; 
        });
    
      }
      
    
     } on AppkeyError catch (error) {  

      setState(() {
        _errorMessage = error.message;
      });
     
    } catch (e) {
      // No specified type, handles all
      _errorMessage = 'Internal Server Error: $e';
    }
   

    setState(() {
       _isSending = false;
    });
    
   
  }

   
  void _signupComplete() async { 

  if (!_formKeyComfirmed.currentState!.validate()){ 
       setState(() { 
        _errorMessage = "Please enter all required fields";
      }); 
      return; 
    } 

    _formKeyComfirmed.currentState!.save();

    setState(() {
      _isSending = true; 
      _message = "";
      _errorMessage = "";
    });


    try {
      final user = await AuthService.signupComplete(_enteredCode, _signupToken); 
      if(user.accessToken != "" ) {
          ref.read(userProvider.notifier).addUser(user);
       }
    
    } on AppkeyError catch (error) {  
      setState(() {
        _errorMessage = error.message;
      });
     
    } catch (e) {
      // No specified type, handles all
      _errorMessage = 'Internal Server Error: $e';
    }
    finally{
       setState(() {
        _isSending = false; 
      });
    } 
   
  }

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(appProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
           
            Header(message:"Welcome to the AppKey demo! Sign up with your email to create your passkey and log in effortlessly. Discover how simple and secure passwordless login can be—no passwords, just your passkey."),
            const SizedBox(height: 12),
            Text("Sign Up", style: TextStyle(color: Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.bold)),

            Column(
              children: [ 
                if(_message != "") Text(_message, style: TextStyle(color: Colors.blueAccent, fontSize: 16),),
                if(_errorMessage != "") Text(_errorMessage, style: TextStyle(color: Colors.redAccent, fontSize: 16)), 
                if (_isConfirmCode) ...[
                  Form(
                    key: _formKeyComfirmed,
                    child: Column(
                    children: [
                      TextFormField(
                         
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('Confirmed Code'),
                        ),
                          validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be a valid, positive number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredCode = value!;
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed:  () => { _isSending ? null : _signupComplete() },
                        child: _isSending
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Submit'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed:  () => { _isSending ? null :  setState(() {
                          _isConfirmCode = false;
                          _errorMessage = "";
                          _message = "";
                          }) },
                        child: const Text('Cancel'),
                      )
                    ],
                  )),
                ] else ...[
                  Form(
                    key: _formKey,
                    child: Column(children:[
                          
                    TextFormField(
                      maxLength: 50,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text('Handle'),
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
                        _enteredHandle = value!;
                      },
                    ),
                    TextFormField(
                      maxLength: 50,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        label: Text('First Name'),
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
                        _enteredFirstName = value!;
                      },
                    ),
                     TextFormField(
                      maxLength: 50,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        label: Text('Last Name'),
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
                        _enteredLastName = value!;
                      },
                    ),
                    const SizedBox(height: 12),
                      ElevatedButton(
                      onPressed: _isSending ? null : _signup,
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Sign Up'),
                    ) 
                      
                    ])), 
                ] 
              ]),
              const Spacer(),
          ],
        )
      ),
    );
}
 


}
