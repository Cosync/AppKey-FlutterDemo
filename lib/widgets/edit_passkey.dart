
import 'package:appkey_flutter_demo/models/app_user.dart';
import 'package:flutter/material.dart';

class EditPasskey extends StatefulWidget {

  const EditPasskey({super.key, required this.passkey, this.child});
  final Authenticator passkey;  
  final Widget? child;    

  @override
    State<EditPasskey> createState() {
      return _EditPasskey();
    }
}

class _EditPasskey extends State<EditPasskey> { 
  
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
   var _errorMessage = '';
  var _isSending = false;
 
  void _updateKeyName(){

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



  }


  @override
  Widget build(BuildContext context) {
     Widget content = Padding(
      padding: const EdgeInsets.all(12),
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
                  onPressed:  () => { _isSending ? null : _updateKeyName() },
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
        ],
      )
     );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.passkey.name),
      ),
      body: content,
    );

  }
}

 
 

