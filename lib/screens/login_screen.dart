import 'package:appkey_flutter_demo/auth_service.dart';
import 'package:appkey_flutter_demo/models/appkey_error.dart';
import 'package:appkey_flutter_demo/providers/app_provider.dart';
import 'package:credential_manager/credential_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTokenValue = '';
  var _enteredHandle = '';
  var _isSending = false;
  var _requireAddPasskey = false;

  final _message = '';
  var _errorMessage = '';

  void _resetPasskey() async{
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isSending = true;
    });

    try { 
      var result = await AuthService.addPasskey(_enteredTokenValue);  

      final credResponse = await AuthService.credentialManager.savePasskeyCredentials(request: result);

      final user = await AuthService.addPasskeyComplete(_enteredHandle,  credResponse, _enteredTokenValue); 

      if(user.accessToken != "" ) {
        ref.read(userProvider.notifier).addUser(user);
      }

    } on AppkeyError catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Something really unknown: $e';
    }
  }


  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isSending = true;
    });

    try {
      final result = await AuthService.login(_enteredHandle);
      if(result['requireAddPasskey']){
        setState(() {
          _requireAddPasskey = true;
        });
        
        return;
      }

      final credential =  CredentialLoginOptions.fromJson(result); 

      final credResponse = await AuthService.credentialManager.getCredentials(
        passKeyOption: CredentialLoginOptions(
          challenge: credential.challenge,
          rpId: credential.rpId,
          userVerification: credential.userVerification,
        ),
      );

      if (credResponse.publicKeyCredential != null) {
        final user = await AuthService.loginComplete(
            _enteredHandle, credResponse.publicKeyCredential!);

        if (user.accessToken != "") {
          ref.read(userProvider.notifier).addUser(user);
        }
      }
    } on AppkeyError catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Something really unknown: $e';
    } finally {
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
      appBar: AppBar(
        title: const Text(
          "Login",
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
            Row(
              children: [
                Image.asset(
                  "images/appkey_logo.png",
                  height: 100,
                  width: 100,
                ),
                Spacer(),
                Image.asset(
                  "images/cosync_bricks.png",
                  height: 100,
                  width: 100,
                ),
              ],
            ),
            const Spacer(),
            Text(
                "Welcome to the AppKey demo! Log in securely using your passkey or sign up with your email to create one in seconds. See for yourself how fast and seamless passkey creation can be with AppKey—no passwords, no hassle, just security made simple."),
            Form(
                key: _formKey,
                child: Column(children: [
                  if (_message != "")
                    Text(
                      _message,
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ),
                  if (_errorMessage != "")
                    Text(_errorMessage,
                        style:
                            TextStyle(color: Colors.redAccent, fontSize: 16)),
                  const SizedBox(height: 12),

                  if(_requireAddPasskey) ...[

                      Text(
                        "Your account has been requested to reset passkey. Please enter a reset passkey token.",
                        style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      TextFormField( 
                        minLines: null,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          label: Text('Reset Token'),
                           border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        ),
                        autocorrect: false,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty
                            ) {
                            return 'Please enter a valid token.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredTokenValue = value!;
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => {_isSending ? null : _resetPasskey()},
                        child: _isSending
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Submit'),
                      ),
                  ] else ...[

                    TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Handle'),
                      ),
                      autocorrect: false,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 50) {
                          return 'Handle must be between 1 and 50 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredHandle = value!;
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => {_isSending ? null : _login()},
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Login'),
                    ),
                  ]
                ])),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
