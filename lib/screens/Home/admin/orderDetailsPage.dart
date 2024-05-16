import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class orderDetails extends StatefulWidget {
  const orderDetails({super.key});

  @override
  State<orderDetails> createState() => _orderDetailsState();
}

class _orderDetailsState extends State<orderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [],
    )));
  }
}