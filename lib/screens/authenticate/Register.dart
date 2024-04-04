import 'package:flutter/material.dart';
import 'package:safeer/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

enum UserKind { owner, rider }

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String username = '';
  String error = '';

  UserKind _userKind = UserKind.owner;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Screen'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              ListTile(
                title: const Text('Owner'),
                leading: Radio(
                  value: UserKind.owner,
                  groupValue: _userKind,
                  onChanged: (UserKind? value) {
                    setState(() {
                      _userKind = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Rider'),
                leading: Radio(
                  value: UserKind.rider,
                  groupValue: _userKind,
                  onChanged: (UserKind? value) {
                    setState(() {
                      _userKind = value!;
                    });
                  },
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  email = val;
                  setState(() {});
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'UserName',
                ),
                validator: (val) => val!.isEmpty ? 'Enter a UserName' : null,
                onChanged: (val) {
                  username = val;
                  setState(() {});
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                validator: (val) =>
                    val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {});
                  password = val;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    print('valid');
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        email: email, userName: username, password: password);
                    if (result == null) {
                      {
                        print('error signing in');
                        setState(() {
                          error = 'Please supply a valid email';
                        });
                      }
                    } else {
                      print('signed in');
                      print(result.uid);
                      widget.toggleView();
                    }
                  }
                },
                child: Text('Register'),
              ),
              Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  widget.toggleView();
                },
                child: Text('Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
