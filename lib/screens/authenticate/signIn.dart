import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/appColors.dart';

import 'package:safeer/models/user.dart';
import 'package:safeer/screens/authenticate/register.dart';
import 'package:safeer/services/auth.dart';

class SignIn extends StatefulWidget {
  final UserTyp usertype;
  final String? toast ;

  const SignIn({
    Key? key,
    this.toast = null,

    required this.usertype,
    
  }) : super(key: key , );

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String error = '';
  

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
    
  // 0 for owner and 1 for rider

  @override
  Widget build(BuildContext context) {

    print(widget.usertype.name);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(children: [
        Positioned(
          left: 0,
          top: 0,
          child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkgreen,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(300),
                ),
              ),
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width / 3),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightyellow,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(300),
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
            right: 0,
            left: 0,
            top: MediaQuery.of(context).size.height / 3,
            child: isLoading == false
                ? Container(margin: 
                  EdgeInsets.symmetric(horizontal: 65),
                  child: Form(
                      key: _formKey,
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              widget.usertype == UserTyp.owner
                                  ? Icons.business
                                  : Icons.delivery_dining,
                              size: 60,
                              color: AppColors.darkergreen,
                            ),
                            Text(widget.usertype.name, style: TextStyle(fontSize: 15 ,fontWeight: FontWeight.bold ,color:AppColors.darkgreen )),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 50, color: AppColors.darkergreen),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                        color: AppColors.darkergreen, width: 2.0),
                                  ),
                                  labelText: 'Email',
                                ),
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter an email' : null,
                                onChanged: (val) {
                                  email = val;
                                  setState(() {});
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                        color: AppColors.darkergreen, width: 2.0),
                                  ),
                                  labelText: 'Password',
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
                            //forget password 
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  _auth.resetPassword(email);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'A password reset link has been sent to your email'),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forget Password ?',
                                  style: TextStyle(
                                      color: AppColors.darkergreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                )
                                ,
                              ),
                            ),
                            //error Text for form errors
                           Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 15),
                                  child: Text(
                                    '$error',
                                    style: TextStyle(
                                        color: AppColors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  )),

                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    AppColors.darkergreen),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                    error = '';
                                  });
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password, widget.usertype);
                                  isLoading = false;
                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'either email or password is incorrect';
                                    });
                                  } else {
                                    print('signed in');
                                    print(result.uid);
                  
                                    context.read<UserProvider>().updateUid(
                                        result.uid, widget.usertype,
                                        email: email);
                                    context.read<UserProvider>().isEmailVerified =
                                        await _auth.isEmailVerified();
                  
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(
                                        color: AppColors.lightyellow,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )),
                            ),
                            
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Register(userType: widget.usertype)),
                                );
                              },
                              child: const Text(
                                'Create a new account ?',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: AppColors.darkergreen),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                )
                : Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.darkergreen, size: 40),
                  )),
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
                    color: AppColors.yellow,
                  ))),
        )
      ]),
    );
  }
}
