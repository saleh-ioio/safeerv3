// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safeer/models/appColors.dart';

import 'package:safeer/models/user.dart';
import 'package:safeer/screens/authenticate/signIn.dart';
import 'package:safeer/services/auth.dart';

class Register extends StatefulWidget {
  final UserTyp userType;
  const Register({
    Key? key,
    required this.userType,
  }) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String username = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(children: [
        
        Positioned(
          left: 0,
          top: 0,
          child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(300),
                ),
              ),
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width / 3),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(300),
                ),
              ),
              height: MediaQuery.of(context).size.height / 5,
              width: MediaQuery.of(context).size.width / 3),
        ),Positioned(
          right: 0,
          bottom: 0,
          child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkergreen,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(300),
                ),
              ),
              height: MediaQuery.of(context).size.height / 5,
              width: MediaQuery.of(context).size.width / 3),
        ),

        Positioned(
          top: MediaQuery.of(context).size.height / 2.4,
          right: MediaQuery.of(context).size.width / 6,
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height / 1.5,
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  Icon(widget.userType == UserTyp.owner ? Icons.business : Icons.delivery_dining, size: 60, color: AppColors.darkergreen,),
                  Text("Sign UP", style: TextStyle(color: AppColors.darkergreen, fontSize: 40 , fontWeight: FontWeight.bold),),
                  Container(
                    
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        email = val;
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'UserName',
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter a UserName' : null,
                      onChanged: (val) {
                        username = val;
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (val) => val!.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {});
                        password = val;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(AppColors.darkergreen),
                            
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  email: email,
                                  userName: username,
                                  password: password,
                                  userType: widget.userType);
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
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SignIn(usertype: widget.userType)),
                            );
                          }
                        }
                      },
                      child: Container(margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15), child: Text('Register', style: TextStyle(color: AppColors.lightyellow, fontWeight: FontWeight.bold, fontSize: 17), )),
                    ),
                  ),
                  Row(children: [Text("Already have an account?" ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignIn(usertype: widget.userType)),
                      );
                    },
                    child: Text('Sign in', style: TextStyle(color: AppColors.darkergreen, fontWeight: FontWeight.bold ,fontSize:  20), ),
                  ),
],)                 ],
              ),
            ),
          ),
        ),
Positioned(
          top: 20,
          left: 5,
          child: TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Container(
          width: 100,
          height: 100,
            child: Icon(Icons.arrow_back , color: AppColors.darkergreen,))),)
      ]),
    );
  }
}
