// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:safeer/models/appColors.dart';

import 'package:safeer/models/user.dart';
import 'package:safeer/screens/authenticate/signIn.dart';
import 'package:safeer/services/auth.dart';
import 'package:safeer/services/dataBase.dart';

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
  bool isLoading = false;

  
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
        ),
        Positioned(
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
          top: MediaQuery.of(context).size.height / 3.3,
          right: 0,
          left: 0,
          child: isLoading == false
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 65),
                  child: Form(
                    key: _formKey,
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            widget.userType == UserTyp.owner
                                ? Icons.business
                                : Icons.delivery_dining,
                            size: 60,
                            color: AppColors.darkergreen,
                          ),
                          Text(widget.userType.name,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkgreen)),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Sign UP",
                              style: TextStyle(
                                  color: AppColors.darkergreen,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                      color: AppColors.darkergreen,
                                      width: 2.0), // Change this line
                                ),
                                labelText: 'Email',
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter an email';
                                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(val)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
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
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                      color: AppColors.red,
                                      width: 10.0), // Change this line
                                ),
                                labelText: 'UserName',
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter a username';
                                } else if (val.length < 3) {
                                  return 'Username must be at least 3 characters long';
                                }
                                return null;
                              },
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
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                labelText: 'Password',
                              ),
                              // validator: (val) => val!.length < 6
                              //     ? 'Enter a password 6+ chars long'
                              //     : null,

                              obscureText: true,
                              // onChanged: (val) {
                              //   setState(() {});
                              //   password = val;
                              // },
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter a password';
                                } else if (val.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                password = val;
                                setState(() {});
                              },
                            ),
                          ),
                           //error Text for form errors
                           Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Text(
                                    '$error',
                                    style: TextStyle(
                                        color: AppColors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  )),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.darkergreen),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                    error = '';
                                  });
                                 DataBaseServiceWithNoUser().checkUserExist(widget.userType, email).then((value) {
                                    if (value == true) {
                                      setState(() {
                                        error = 'User already exists';
                                        isLoading = false;
                                      });
                                    }
                                  });
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email: email,
                                          userName: username,
                                          password: password,
                                          userType: widget.userType);
                                  setState(() {
                                    isLoading = false;
                                  });
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
                                          builder: (context) => SignIn(
                                              usertype: widget.userType)),
                                    );
                                  }
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                        color: AppColors.lightyellow,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  )),
                            ),
                          ),
                         
                          Row(
                            children: [
                              Text("Already have an account?"),
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
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                      color: AppColors.darkergreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: AppColors.darkergreen, size: 40),
                ),
        ),
        Positioned(
          top: 20,
          left: 5,
          child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.darkergreen,
                  ))),
        )
      ]),
    );
  }
}
