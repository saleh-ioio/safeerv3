// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:safeer/models/appColors.dart';
import 'package:safeer/services/dataBase.dart';

class OrderConfirmationPage extends StatefulWidget {
  final String adminId;
  final String orderId;
  const OrderConfirmationPage({
    Key? key,
    required this.adminId,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  String passcode = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        title: const Text('Order Verfiication Page', style: TextStyle(color: AppColors.white),),
      ),
      body:  Container(
        margin: EdgeInsets.symmetric(horizontal: 20, ),
        child: Form(
          key: _formKey,
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             //Text field for passcode of the order
             TextFormField(
               decoration: const InputDecoration(
                 labelText: 'Enter the passcode of the order',
                 
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.all(Radius.circular(2)),
                 ),
          
               ),
               //only numbers are allowed
                keyboardType: TextInputType.number,
                //filter the input to only allow 5 digits
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5),
                ],
               onChanged: (value) {
                  setState(() {
                    passcode = value;
                  });
               },
               validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the passcode';
                  }
                  return null;
               },
             ),
             Container(
              alignment: Alignment.centerLeft,
              child: Text('Customer Provides the passCode', style: TextStyle(color: AppColors.grey),),),
             Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.centerRight,
               child: TextButton(onPressed: () async{
                 if (_formKey.currentState!.validate()) {
                   //if the passcode is correct desplay a banner for  3 seconds and after that pop the page
                   final iscorrect = await DataBaseService(email: "", uid: "").checkPasscode(orderId: widget.orderId, adminId: widget.adminId, passcode: passcode);
                   if(iscorrect){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Passcode is correct'),
                        duration: const Duration(seconds: 3),
                      ));
                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                   }else{
                     //if the passcode is incorrect display a banner for 3 seconds
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Passcode is incorrect'),
                        duration: const Duration(seconds: 3),
                      ));}

               
                 }
               }, 
               //background color of the button is yellow with no border radius
                style: ButtonStyle(

                  backgroundColor: MaterialStateProperty.all(AppColors.yellow),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                  
                )
               ,
               child: Text('Submit', style: TextStyle(color: AppColors.white),),
                         ),
             )],
          ),
        ),
      ),
    );
  }
}