import 'package:flutter/material.dart';
import 'package:safeer/models/appColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class welcomePage extends StatefulWidget {
  final Function toggleView;
  const welcomePage({super.key , required this.toggleView});

  @override
  State<welcomePage> createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage> {

  
  SharedPreferences? prefs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1CFE8E4),
      body: Stack(children: [
          Positioned(
            top: 0,
            left: 100,
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(

              color: Color(0xFF175C55),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                ),
              ),
              width: 350,
              height: 420,
               child: Image.asset('assets/images/delman.png' ,width: 150,),
            ),
          ),
          Positioned(
            bottom: 150,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: Color(0xFF27847B),
              ),
              padding: EdgeInsets.fromLTRB(0, 30, 15, 0),
              width: 300,
              height: 200,
              child: Column(
                children: [
                  Text(
                    'Deliver with Precision, \n Every Time! ',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 23,
                    ),
                  ),
                  Text(
                    'Start your journey to success ',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.darkgreen,
              ),
              child: TextButton(
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                  ),
                ),
                onPressed: () {
                  widget.toggleView();
                },
              ),
            ),
          ),
        ]));
  }
}
