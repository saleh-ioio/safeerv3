import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safeer/models/user.dart';

class ChooseUserTyp extends StatefulWidget {
  const ChooseUserTyp({super.key,});

  @override
  State<ChooseUserTyp> createState() => _ChooseUserTypState();
}

class _ChooseUserTypState extends State<ChooseUserTyp> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListTile(
            title: const Text('Owner'),
            onTap: () {
              
            },
          ),
          ListTile(
            title: const Text('Rider'),
            onTap: () {
              
            },
          ),
        ],
      ),
    );
  }
}