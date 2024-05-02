// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:safeer/models/appColors.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/authenticate/signIn.dart';

class ChooseUserTypePage extends StatefulWidget {
  final Function? resetWelcomePage;
  const ChooseUserTypePage({
    Key? key,
    this.resetWelcomePage,
  }) : super(key: key);

  @override
  State<ChooseUserTypePage> createState() => _ChooseUserTypePageState();
}

class _ChooseUserTypePageState extends State<ChooseUserTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundForm,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 0,
            top: 00,
            child: Container(
              width: 150,
              height: 300,
              decoration: const BoxDecoration(
                color: AppColors.darkergreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(150),
                ),
              ),
            ),
          ),
          Positioned(
            top: 300,
            child: Container(
              width: 300,
              height: 200,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: AppColors.darkergreen,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome Back \n to Safeer  ",
                      style: TextStyle(
                          color: AppColors.lightyellow,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  Text("Start your journey to success",
                      style: TextStyle(
                          color: AppColors.lightyellow,
                          fontSize: 10,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 260,
            left: MediaQuery.of(context).size.width / 4,
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: AppColors.lightbackgroundButton,
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignIn(
                        usertype: UserTyp.owner,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Admin',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.darkergreen),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 180,
            left: MediaQuery.of(context).size.width / 4,
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: AppColors.darkergreen,
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignIn(
                              usertype: UserTyp.rider,
                            )),
                  );
                },
                child: Text(
                  'Rider',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
              ),
            ),
          ),widget.resetWelcomePage !=null ? Positioned(
            bottom: 100,
            left: MediaQuery.of(context).size.width / 4,
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: AppColors.darkergreen,
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextButton(
                onPressed: () {
                  widget.resetWelcomePage!();
                },
                child: Text(
                  'reset welcome page',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
              ),
            ),
          ): Container(),
          Positioned(
            bottom: 0,
            child: Container(
              width:  100,
              height: 170,
              
              decoration: BoxDecoration(

              color: AppColors.lightyellow,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(120),
                ),
              ),
            ))
        ],
      ),
    );
  }
}
